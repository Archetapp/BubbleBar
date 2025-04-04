# BubbleBar

<img src="https://github.com/user-attachments/assets/57228e48-9d6b-4d4d-84d7-33c9371f16df" width="100%">

A modern, customizable SwiftUI tab bar with a bubble effect animation. BubbleBar provides a sleek and intuitive navigation experience for iOS and macOS applications.

## Table of Contents
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
  - [Basic Implementation](#basic-implementation)
  - [Customization](#customization)
- [Themes](#themes)
  - [Available Themes](#available-themes)
  - [Creating Custom Styles](#creating-custom-styles)
- [Advanced Customization](#advanced-customization)
  - [Animation Control](#animation-control)
  - [Content Padding](#content-padding)
  - [Shape Customization](#shape-customization)
  - [Sizing Options](#sizing-options)
- [Accessibility](#accessibility)
- [Localization and Multi-Language Support](#localization-and-multi-language-support)
- [Requirements](#requirements)
- [License](#license)

---

## Features

- **Themes & Styles**
  - 🎨 Multiple built-in themes (Dark, Desert, Forest, Night Owl, High Contrast, Ocean)
  - 🎭 Customizable shadows and effects
  - 🌟 Glass effect option for modern UI
  
- **Animations & Interactions**
  - ✨ Smooth bubble animation between tabs
  - 🎬 Independent animations for tab bar and view transitions
  - 🔄 Configurable transition effects
  
- **Customization**
  - 🎯 Customizable container and item shapes
  - 📐 Flexible sizing options (fixed or edge-to-edge)
  - 🔤 Optional label display for selected tabs
  
- **Accessibility**
  - 🔍 VoiceOver and screen reader support
  - 📱 Dynamic Type compatibility
  - 🚫 Reduced Motion support
  - 🌗 High Contrast mode
  - ⌨️ Keyboard navigation
  
- **Localization**
  - 🌐 Multiple language support
  - 🔄 Right-to-Left (RTL) layout support
  - 🔠 Proper text handling for all languages

- **Platforms**
  - 📱 iOS 16+ support
  - 💻 macOS 14+ support

---

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/archetapp/BubbleBar.git", branch: "main")
]
```

---

## Usage

### Basic Implementation

```swift
import SwiftUI
import BubbleBar

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        BubbleBarView(selectedTab: $selectedTab) {
            Text("Home View")
                .tabBarItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            Text("Settings View")
                .tabBarItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .bubbleBarStyle(.dark)
    }
}
```

### Customization

BubbleBar offers extensive customization options:

```swift
BubbleBarView(selectedTab: $selectedTab) {
    // Your tab content here
}
.bubbleBarStyle(.ocean)                    // Choose a theme
.bubbleBarAnimation(.spring())             // Custom animation for bubble movement
.bubbleBarViewTransition(.easeInOut)       // Custom animation for view transitions
.showBubbleBarLabels(true)                 // Show/hide labels
.bubbleBarSize(CGSize(width: 350, height: 60))  // Optional fixed size
.bubbleBarShape(RoundedRectangle(cornerRadius: 20))  // Container shape
.bubbleBarItemShape(Capsule())             // Selected item shape
.bubbleBarItemEqualSizing(true)            // Equal width items
.bubbleBarPadding(.init(top: 8, leading: 16, bottom: 8, trailing: 16))  // Custom padding
.bubbleBarShadow(radius: 4, color: .black.opacity(0.1), offset: .init(x: 0, y: 2))  // Custom shadow
```

---

## Themes

### Available Themes

- `.dark` - Dark mode optimized with blue accents
- `.desert` - Warm orange and beige tones
- `.forest` - Natural green theme
- `.nightOwl` - Dark blue theme for night use
- `.highContrast` - Accessibility optimized theme
- `.ocean` - Cool blue tones
- Or create your own!

### Creating Custom Styles

You can create your own custom style in several ways:

1. Using the comprehensive color initializer:
```swift
let customStyle = BubbleBar.Style(
    selectedItemColor: .blue,           // Color for selected tab items
    unselectedItemColor: .gray,         // Color for unselected tab items
    bubbleBackgroundColor: .blue.opacity(0.15),  // Background of selected item bubble
    bubbleStrokeColor: .blue.opacity(0.4),       // Border of selected item bubble
    barBackgroundColor: .white,         // Background color of the bar
    barStrokeColor: .blue.opacity(0.2), // Border color of the bar
    barShadowColor: .black.opacity(0.1) // Shadow color of the bar
)
```

2. Using the copying modifier to modify specific colors:
```swift
let modifiedStyle = BubbleBar.Style.copying(existingStyle) { colors in
    var colors = colors
    colors.selectedItemColor = .red      // Only change what you need
    colors.bubbleBackgroundColor = .red.opacity(0.15)
    return colors
}
```

3. Using the direct configuration initializer for more control:
```swift
BubbleBar.Configuration(
    selectedItemColor: .blue,
    unselectedItemColor: .gray,
    bubbleBackgroundColor: .blue.opacity(0.15),
    bubbleStrokeColor: .blue.opacity(0.4),
    barStrokeColor: .blue.opacity(0.2),
    barShadowColor: .black.opacity(0.1),
    // Additional configuration options...
    showLabels: true,
    isGlass: false
)
```

Apply your custom style using the `.bubbleBarStyle()` modifier:
```swift
BubbleBarView(selectedTab: $selectedTab) {
    // Your tab content here
}
.bubbleBarStyle(customStyle)
```

The colors are organized in a `Theme.Colors` structure for better organization:
- Bar colors: `barBackgroundColor`, `barStrokeColor`, `barShadowColor`
- Item colors: `selectedItemColor`, `unselectedItemColor`
- Bubble colors: `bubbleBackgroundColor`, `bubbleStrokeColor`

<div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 10px; margin-bottom: 20px; text-align: center;">
  <div>
    <img src="https://github.com/user-attachments/assets/d6a06b03-9fab-4763-97bd-59fff6f24f55" width="50%" alt="Desert Theme" style="display: block; margin: 0 auto;">
    <p><strong>Desert</strong> - Warm orange and beige tones</p>
  </div>
  <div>
    <img src="https://github.com/user-attachments/assets/565b436d-ba72-4ebd-93c5-b0ceb98ca2e0" width="50%" alt="Forest Theme" style="display: block; margin: 0 auto;">
    <p><strong>Forest</strong> - Natural green theme</p>
  </div>
  <div>
    <img src="https://github.com/user-attachments/assets/a9d3ad7e-8310-4ff1-9c24-414a593c34dd" width="50%" alt="Ocean Theme" style="display: block; margin: 0 auto;">
    <p><strong>Ocean</strong> - Cool blue tones</p>
  </div>
  <div>
    <img src="https://github.com/user-attachments/assets/3aecba08-e5e3-4e89-96cc-55ee3a3b656d" width="50%" alt="High Contrast Theme" style="display: block; margin: 0 auto;">
    <p><strong>High Contrast</strong> - Dark blue theme for night use</p>
  </div>
  <div>
    <img src="https://github.com/user-attachments/assets/25316f83-ffbe-4e9c-b90c-1448ade11010" width="50%" alt="Dark Theme" style="display: block; margin: 0 auto;">
    <p><strong>Dark</strong> - Dark mode optimized with blue accents</p>
  </div>
  <div>
    <img src="https://github.com/user-attachments/assets/a91922a1-228f-48a5-8f82-289ac56fa6ad" width="50%" alt="Night Owl Theme" style="display: block; margin: 0 auto;">
    <p><strong>Night Owl</strong> - Cool blue tones Dark blue theme for night use</p>
  </div>
</div>

---

## Advanced Customization

### Animation Control

BubbleBar provides three separate animation modifiers for fine-tuned control over different aspects of the interface:

1. `bubbleBarAnimation(_:)` - Controls the animation of the bubble movement and tab bar changes
2. `bubbleBarViewTransitionAnimation(_:)` - Controls the timing and curve of the view transition animation
3. `bubbleBarViewTransition(_:)` - Controls the type of transition effect between views

Example usage:
```swift
BubbleBarView(selectedTab: $selectedTab) {
    // Your tab content here
}
.bubbleBarAnimation(.spring(response: 0.3, dampingFraction: 0.7))  // Bubble movement
.bubbleBarViewTransitionAnimation(.easeInOut)                      // View transition timing
.bubbleBarViewTransition(.slide)                                   // View transition effect
```

Available transition effects include:
- `.opacity` (default)
- `.scale`
- `.slide`
- `.move(edge:)`
- `.asymmetric(insertion:removal:)`
- `.combined(with:)`

You can combine transitions for more complex effects:
```swift
// Scale and fade
.bubbleBarViewTransition(.scale.combined(with: .opacity))

// Slide from right, fade out to left
.bubbleBarViewTransition(.asymmetric(
    insertion: .move(edge: .trailing).combined(with: .opacity),
    removal: .move(edge: .leading).combined(with: .opacity)
))
```

<div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 10px; margin-bottom: 20px; text-align: center;">
  <div>
    <img src="https://github.com/user-attachments/assets/8e030d18-943a-4d94-b68b-e932fa27313b" width="50%" alt="Default Animation" style="display: block; margin: 0 auto;">
    <p><strong>Default</strong> - Standard animation</p>
  </div>
  <div>
    <img src="https://github.com/user-attachments/assets/12d8471a-949b-4992-aee1-42c61b21bc34" width="50%" alt="Ease In Out Animation" style="display: block; margin: 0 auto;">
    <p><strong>.bubbleBarAnimation(.easeInOut)</strong> - Smooth ease in/out timing</p>
  </div>
</div>
<div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 10px; margin-bottom: 20px; text-align: center;">
  <div>
    <img src="https://github.com/user-attachments/assets/60f93b83-2823-43f9-9ca0-717642a37b99" width="50%" alt="Spring Animation" style="display: block; margin: 0 auto;">
    <p><strong>.bubbleBarAnimation(.spring(bounce: 0.6))</strong> - Bouncy spring effect</p>
  </div>
</div>

### Content Padding

BubbleBar offers control over how content is padded to avoid overlapping with the tab bar:

- By default (with `bubbleBarContentPadding(0)`), content respects the system's safe area insets
- For custom spacing, use the `bubbleBarContentPadding(_:)` modifier with a positive value

```swift
BubbleBarView(selectedTab: $selectedTab) {
    // Your tab content here
}
.bubbleBarContentPadding(0)  // Default - respects system safe areas
```

```swift
BubbleBarView(selectedTab: $selectedTab) {
    // Your tab content here
}
.bubbleBarContentPadding(20)  // Custom padding - adds 20pt of space above the tab bar
```

This is especially useful when:
- You need precise control over the spacing between content and the tab bar
- Your content needs more or less clearance than the default safe area provides
- You're implementing a custom layout where the tab bar overlays part of the content

### Shape Customization

BubbleBar allows you to customize both the container and item shapes:

1. `.bubbleBarShape(RoundedRectangle(cornerRadius: 20))` - Container shape
2. `.bubbleBarItemShape(Capsule())` - Inner items shape

NOTE: Padding is defaulted to 4 between inner items and outer shape. (Might make customizable)

<div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 10px; margin-bottom: 20px; text-align: center;">
  <div>
    <img src="https://github.com/user-attachments/assets/7ca1901b-8f32-43ad-b331-beb861d5d392" width="50%" alt="RoundedRectangle Shape" style="display: block; margin: 0 auto;">
    <p><strong>Capsule</strong> - Default</p>
  </div>
  <div>
    <img src="https://github.com/user-attachments/assets/cbd3437f-c0b6-411c-8074-38e22b014b2f" width="50%" alt="Capsule Shape" style="display: block; margin: 0 auto;">
    <p><strong>Rounded Rectangle (15) - Rounded Rectangle (11) Inner Item</strong></p>
  </div>
</div>

### Sizing Options

#### Container Sizing
- Edge-to-edge (default) - The bar stretches to fill the available width
- Fixed size - Set a specific size using `bubbleBarSize()`

#### Item Sizing
- Dynamic (default) - Selected items expand to show labels
- Equal sizing - All items maintain equal width using `bubbleBarItemEqualSizing(true)`

---

## Accessibility

BubbleBar is designed with accessibility as a priority, ensuring a great experience for all users.

### Key Accessibility Features

- **VoiceOver Support**: Proper accessibility labels, hints, and traits
- **Dynamic Type**: Full support for all text sizes
- **Reduced Motion**: Simplified animations when Reduce Motion is enabled
- **High Contrast**: Accessible color themes with adequate contrast
- **Keyboard Navigation**: Complete keyboard focus and selection support
- **RTL Languages**: Right-to-left language support

### Accessibility Checklist

- ✅ **VoiceOver**: Tab items have proper labels, hints, and traits
- ✅ **Dynamic Type**: UI scales appropriately with system font size
- ✅ **Reduced Motion**: Animations adapt when Reduce Motion is enabled
- ✅ **High Contrast**: Themes pass color contrast requirements
- ✅ **RTL Support**: Layout correctly adapts when RTL direction is set
- ✅ **Keyboard Navigation**: Full keyboard interaction support
- ✅ **Localization**: Support for multiple languages

### Implementation Guide

When implementing BubbleBar in your app:

1. **Provide clear accessibility labels**:
```swift
.tabBarItem(
    label: { Label("Home", systemImage: "house.fill") },
    accessibilityLabel: "Home"
)
```

2. **Test with assistive technologies** enabled:
   - VoiceOver
   - Dynamic Type (various sizes)
   - Reduce Motion
   - High Contrast

Our automated test suite verifies all accessibility features across different configurations including light/dark modes and various assistive technology settings.

## Localization and Multi-Language Support

BubbleBar supports localization but doesn't include built-in translations - you'll need to provide your own localized strings.

### Features

- **RTL Support**: Layout properly adapts to right-to-left languages when RTL direction is set
- **Example Localization**: The example app demonstrates English, Japanese, and Arabic
- **Flexible Implementation**: Works with standard iOS localization patterns

### Implementation Guide

1. **Create localization files** for each supported language

2. **Use localization keys** for tab labels:
```swift
.tabBarItem {
    Label(NSLocalizedString("Home", comment: "Home tab"), systemImage: "house.fill")
}
```

3. **Set RTL support** when needed:
```swift
// In SwiftUI apps, the system typically sets this automatically based on the user's language
// For specific language switching or testing, set it explicitly:
.environment(\.layoutDirection, Locale.current.languageDirection == .rightToLeft ? .rightToLeft : .leftToRight)

// Example for direct language setting:
ExampleGreen(language: .arabic)
    .environment(\.layoutDirection, .rightToLeft)
```

The system will automatically set the correct layout direction based on the user's language preferences. You only need to set it explicitly if you're implementing a language switcher or for testing purposes.

Test your implementation with different locale settings to ensure correct display across languages.

## Requirements

- iOS 16.0+ / macOS 14.0+
- Swift 6.0+
- Xcode 15.0+

## License

This project is licensed under the MIT License - see the LICENSE file for details.
