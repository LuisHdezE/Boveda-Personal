allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Move the root build directory to the root of the Flutter project.
rootProject.layout.buildDirectory.value(rootProject.layout.projectDirectory.dir("../build"))

subprojects {
    // Ensure all subprojects are evaluated after the app project, as plugins may depend on app configuration.
    if (project.path != ":app") {
        project.evaluationDependsOn(":app")
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
