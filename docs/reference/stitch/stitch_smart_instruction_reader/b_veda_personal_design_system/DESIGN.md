---
name: Bóveda Personal Design System
colors:
  surface: '#091421'
  surface-dim: '#091421'
  surface-bright: '#303a48'
  surface-container-lowest: '#050f1c'
  surface-container-low: '#121c2a'
  surface-container: '#16202e'
  surface-container-high: '#212b39'
  surface-container-highest: '#2b3544'
  on-surface: '#d9e3f6'
  on-surface-variant: '#c4c7c7'
  inverse-surface: '#d9e3f6'
  inverse-on-surface: '#27313f'
  outline: '#8e9192'
  outline-variant: '#444748'
  surface-tint: '#c9c6c5'
  primary: '#c9c6c5'
  on-primary: '#313030'
  primary-container: '#0a0a0a'
  on-primary-container: '#7b7979'
  inverse-primary: '#5f5e5e'
  secondary: '#e9c349'
  on-secondary: '#3c2f00'
  secondary-container: '#af8d11'
  on-secondary-container: '#342800'
  tertiary: '#4edea3'
  on-tertiary: '#003824'
  tertiary-container: '#000d06'
  on-tertiary-container: '#008b5f'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#e5e2e1'
  primary-fixed-dim: '#c9c6c5'
  on-primary-fixed: '#1c1b1b'
  on-primary-fixed-variant: '#474646'
  secondary-fixed: '#ffe088'
  secondary-fixed-dim: '#e9c349'
  on-secondary-fixed: '#241a00'
  on-secondary-fixed-variant: '#574500'
  tertiary-fixed: '#6ffbbe'
  tertiary-fixed-dim: '#4edea3'
  on-tertiary-fixed: '#002113'
  on-tertiary-fixed-variant: '#005236'
  background: '#091421'
  on-background: '#d9e3f6'
  surface-variant: '#2b3544'
typography:
  display-lg:
    fontFamily: Inter
    fontSize: 57px
    fontWeight: '600'
    lineHeight: 64px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
    letterSpacing: '0'
  headline-lg-mobile:
    fontFamily: Inter
    fontSize: 28px
    fontWeight: '600'
    lineHeight: 36px
  title-lg:
    fontFamily: Inter
    fontSize: 22px
    fontWeight: '500'
    lineHeight: 28px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
    letterSpacing: 0.5px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-lg:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
    letterSpacing: 0.1px
  label-md:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.5px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 8px
  container-padding: 20px
  gutter: 16px
  stack-sm: 4px
  stack-md: 12px
  stack-lg: 24px
---

## Brand & Style

The design system is engineered for a premium, high-end mobile financial experience that prioritizes security, wealth, and clarity. The brand personality is authoritative yet understated, evoking the feeling of a private digital vault.

The aesthetic blends **Minimalism** with **Glassmorphism**. By utilizing a deep, monochromatic foundation punctuated by high-fidelity metallic accents and functional status colors, the UI achieves a sophisticated balance between professional utility and luxury. The target audience expects a quiet, "stealth-wealth" interface that minimizes cognitive load while providing maximum financial insight.

## Colors

This design system utilizes a "True Dark" palette to optimize for OLED displays and premium aesthetics. 

- **Primary Background:** Deep Black (#0A0A0A) serves as the infinite canvas.
- **Accent (Patrimonio):** Metallic Gold (#D4AF37) is used sparingly for high-value indicators, primary actions, and wealth milestones.
- **Success (Ingresos):** Vibrant Emerald Green (#10B981) for positive cash flow and gains.
- **Error (Gastos):** Soft Crimson Red (#EF4444) for expenses and alerts, balanced to remain legible against dark backgrounds without being jarring.
- **Info:** Sky Blue (#0EA5E9) for neutral data points and system updates.
- **Surfaces:** Use varying shades of dark grey (100–300 alpha-blended) to create hierarchical depth.

## Typography

The system adopts a modified **Material Design 3** scale using **Inter**. This typeface was chosen for its exceptional legibility in data-dense financial environments and its neutral, systematic character.

Numbers and currency should always use `Medium` or `SemiBold` weights to ensure they are the focal point of the interface. For large currency displays (Net Worth), use `display-lg` with tighter letter spacing to create a sense of solidity and importance.

## Layout & Spacing

This design system follows a **Fluid Grid** model optimized for Android handheld devices. 

- **Grid:** A 4-column grid for mobile, expanding to 8 columns for tablets.
- **Margins:** Standard horizontal margin of 20px to provide breathing room on edge-to-edge displays.
- **Rhythm:** An 8px linear scale governs all spatial relationships. 
- **Verticality:** Content is organized in "stacks." Use 24px spacing between distinct functional sections (e.g., between a Chart card and a Transaction list) and 12px for internal group elements.

## Elevation & Depth

Hierarchy is established through **Glassmorphism** and **Tonal Layering** rather than traditional heavy shadows.

- **Surface 0 (Base):** True Black (#000000).
- **Surface 1 (Cards):** Semi-transparent white overlay (approx. 4-6% opacity) with a 20px Backdrop Blur. This creates a "frosted obsidian" effect.
- **Borders:** Cards and inputs feature a 1px "Inner Glow" or hairline stroke using a 10% white opacity to define edges against the dark background.
- **Shadows:** Use only for primary floating action buttons (FABs). Shadows should be long, soft, and tinted with the accent color (Gold) at very low opacity (15%) to simulate a subtle glow.

## Shapes

The shape language is generous and friendly, contrasting the serious nature of finance with approachable geometry.

- **Primary Containers:** 16px radius for standard cards and modals.
- **Large Containers:** 24px radius for main dashboard overview panels.
- **Interactive Elements:** 12px for buttons and input fields to maintain a distinct "clicky" feel.
- **Icons:** Use a 2px stroke weight with rounded terminals to match the container language.

## Components

### Buttons
- **Primary:** Metallic Gold background with black text. High-gloss finish.
- **Secondary:** Glassmorphic fill (10% white) with white text and 1px border.
- **Tertiary:** Text-only with Gold or Sky Blue coloring.

### Cards
All cards must use the `Surface 1` glassmorphic specification. Header sections within cards should be separated by a subtle 1px divider at 5% white opacity.

### Input Fields
Filled style with 8% white background and a bottom-border only, or a fully outlined glassmorphic box. The cursor and active label should transition to Metallic Gold when focused.

### Chips
Small, 100px-pill shaped containers for category tagging (e.g., "Food", "Rent"). Use Success/Error colors at 15% opacity for the background and 100% opacity for the text.

### Financial Lists
List items should have a minimum height of 72px. The "Amount" column should be right-aligned using `Label-Large` with color-coding based on transaction type (Green for Income, Red for Expenses).

### Wealth Tracker (Chart)
A custom component featuring a Bezier-smoothed line chart. The area under the line should feature a vertical gradient from Metallic Gold (20% opacity) to Transparent.