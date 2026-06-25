param(
    [string]$Flutter = "flutter"
)

$ErrorActionPreference = "Stop"
$projectRoot = Split-Path -Parent $PSScriptRoot
$temporaryRoot = [System.IO.Path]::GetTempPath()
$scaffold = Join-Path $temporaryRoot ("boveda-flutter-scaffold-" + [guid]::NewGuid())

Push-Location $projectRoot
try {
    if (-not (Test-Path (Join-Path $projectRoot "android"))) {
        & $Flutter create `
            --platforms=android `
            --org com.luishdeze `
            --project-name boveda_personal `
            $scaffold

        Copy-Item `
            -LiteralPath (Join-Path $scaffold "android") `
            -Destination (Join-Path $projectRoot "android") `
            -Recurse

        $activity = Join-Path $projectRoot `
            "android\app\src\main\kotlin\com\luishdeze\boveda_personal\MainActivity.kt"
        $activityContent = Get-Content -LiteralPath $activity -Raw
        $activityContent = $activityContent `
            -replace "io\.flutter\.embedding\.android\.FlutterActivity",
                "io.flutter.embedding.android.FlutterFragmentActivity" `
            -replace "FlutterActivity\(\)", "FlutterFragmentActivity()"
        Set-Content -LiteralPath $activity -Value $activityContent

        $manifest = Join-Path $projectRoot "android\app\src\main\AndroidManifest.xml"
        $manifestContent = Get-Content -LiteralPath $manifest -Raw
        if ($manifestContent -notmatch "android.permission.USE_BIOMETRIC") {
            $manifestContent = $manifestContent -replace `
                "<application", `
                "<uses-permission android:name=`"android.permission.USE_BIOMETRIC`" />`r`n    <application"
        }
        Set-Content -LiteralPath $manifest -Value $manifestContent

        $gradle = Join-Path $projectRoot "android\app\build.gradle.kts"
        $gradleContent = Get-Content -LiteralPath $gradle -Raw
        $gradleContent = $gradleContent -replace `
            "minSdk = flutter\.minSdkVersion", `
            "minSdk = 24"
        Set-Content -LiteralPath $gradle -Value $gradleContent
    }

    & $Flutter pub get
    & $Flutter gen-l10n
    & dart run build_runner build --delete-conflicting-outputs
    & dart format .
    & $Flutter analyze
    & $Flutter test
}
finally {
    Pop-Location

    $resolvedScaffold = [System.IO.Path]::GetFullPath($scaffold)
    if (
        (Test-Path -LiteralPath $resolvedScaffold) -and
        $resolvedScaffold.StartsWith(
            [System.IO.Path]::GetFullPath($temporaryRoot),
            [System.StringComparison]::OrdinalIgnoreCase
        )
    ) {
        Remove-Item -LiteralPath $resolvedScaffold -Recurse -Force
    }
}
