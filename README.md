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
  - [Shape Customization](#shape-customization)
  - [Sizing Options](#sizing-options)
- [Accessibility](#accessibility)
- [Localization and Multi-Language Support](#localization-and-multi-language-support)
- [Best Practices](#best-practices)
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

BubbleBar is designed with accessibility as a priority, ensuring a great experience for all users including those who use assistive technologies.

### Supported Accessibility Features

- **VoiceOver Support**: Each tab has appropriate accessibility labels and hints
- **Dynamic Type**: Supports all text sizes including accessibility sizes
- **Reduced Motion**: Automatically detects and adjusts animations for users with reduced motion enabled
- **High Contrast**: Includes a high contrast theme and contrast-aware design for all themes
- **Keyboard Navigation**: Full keyboard navigation support
- **Right-to-Left Languages**: Complete RTL language support

### Accessibility Implementation Checklist

✅ **VoiceOver**: Tab items have proper labels, hints, and traits
✅ **Dynamic Type**: Text and UI scales appropriately with system font size settings
✅ **Reduced Motion**: Animations are disabled or simplified when Reduce Motion is enabled
✅ **High Contrast**: All themes pass color contrast checks for readability
✅ **RTL Support**: Layout automatically adjusts for right-to-left languages
✅ **Keyboard Navigation**: Tab selection works with keyboard focus and activation
✅ **Localization**: Supports multiple languages including English, Japanese, and Arabic

### Accessibility Implementation Guide

When implementing BubbleBar in your app, consider the following best practices:

1. **Provide Clear Labels**: When using the `tabBarItem` modifier, provide explicit accessibility labels:

```swift
.tabBarItem(
    label: { Label("Home", systemImage: "house.fill") },
    accessibilityLabel: "Home"
)
```

2. **Custom Hints**: Provide custom accessibility hints if needed:

```swift
.tabBarItem(
    label: { Label("Settings", systemImage: "gear") },
    accessibilityLabel: "Settings", 
    accessibilityHint: "View and change application settings"
)
```

3. **Support Dynamic Type**: Ensure your tab content also supports dynamic type:

```swift
Text("Content")
    .font(.body)  // System fonts automatically scale with Dynamic Type
    .dynamicTypeSize(...DynamicTypeSize.accessibility5)  // Optional: limit maximum size
```

4. **Test with Assistive Technologies**: Test your implementation with:
   - VoiceOver enabled
   - Different Dynamic Type sizes
   - Reduce Motion enabled
   - High Contrast enabled
   - RTL language settings

### Accessibility Tests

BubbleBar undergoes extensive accessibility testing to ensure compliance with accessibility standards. Our automated test suite checks:

| Test Category | Description |
|---------------|-------------|
| Color Contrast | Verifies sufficient contrast between text/icons and backgrounds |
| Touch Targets | Ensures touch targets meet minimum size requirements |
| Dynamic Type | Tests UI adaptation to various text sizes |
| Element Descriptions | Checks for proper element descriptions for assistive technologies |
| VoiceOver | Verifies VoiceOver functionality and traits |
| RTL Layout | Tests proper display in right-to-left languages |
| Reduced Motion | Validates behavior when reduce motion is enabled |
| Keyboard Navigation | Tests keyboard-based navigation and selection |
| Language Support | Validates localization for multiple languages |

These tests run across different configurations including light/dark modes, high contrast settings, and with various assistive technologies enabled.

## Localization and Multi-Language Support

BubbleBar is designed to support localization and has been tested with multiple languages. However, it doesn't include built-in translations - you'll need to provide your own localized strings.

### Language Support

The example application demonstrates localization for:
- English
- Japanese (日本語)
- Arabic (العربية)

These examples show how to implement proper localization in your own apps using BubbleBar.

### RTL Language Support

BubbleBar automatically adjusts its layout for right-to-left languages:

- Layout direction automatically flips
- Tab order adapts to the reading direction
- Animation direction follows the language direction

### Implementing Your Own Localization

To implement localization in your BubbleBar-based UI:

1. **Create Localization Files**: Add `.strings` files for each language you want to support

2. **Use Localization Keys**: Provide localized strings for your tab labels:

```swift
// Using SwiftUI's built-in localization
.tabBarItem {
    Label(NSLocalizedString("Home", comment: "Home tab label"), systemImage: "house.fill")
}

// Or using LocalizedStringKey for SwiftUI
.tabBarItem {
    Label(LocalizedStringKey("HomeTab"), systemImage: "house.fill")
}
```

3. **Accessibility Labels**: Ensure accessibility labels are also localized:

```swift
.tabBarItem(
    label: { Label(NSLocalizedString("Settings", comment: "Settings tab"), systemImage: "gear") },
    accessibilityLabel: NSLocalizedString("Settings", comment: "Settings tab accessibility label")
)
```

4. **RTL Support**: Enable RTL support automatically with SwiftUI's environment:

```swift
BubbleBarView(selectedTab: $selectedTab) {
    // Tab content
}
.environment(\.layoutDirection, Locale.current.languageDirection == .rightToLeft ? .rightToLeft : .leftToRight)
```

### Testing Localization

To test your localized BubbleBar implementation:

1. Add localized string files (.strings) for each supported language
2. Set appropriate accessibility identifiers for testing
3. Run the app with different locale settings
4. Verify text and layout appears correctly in all languages

Our test suite includes automated tests for multiple languages and RTL support to ensure the component works correctly across different localization scenarios.

## Best Practices

Here are some best practices for implementing BubbleBar in your applications:

### Performance Optimization

1. **Lazy Loading**: Use lazy loading for tab content when appropriate:

```swift
BubbleBarView(selectedTab: $selectedTab) {
    LazyView { HomeView() }
        .tabBarItem { Label("Home", systemImage: "house.fill") }
    
    LazyView { SettingsView() }
        .tabBarItem { Label("Settings", systemImage: "gear") }
}
```

2. **Memory Management**: Use `onDisappear` to clean up resources when views are not visible:

```swift
MyTabContent()
    .onDisappear {
        // Clean up resources
    }
    .tabBarItem { Label("Tab", systemImage: "star") }
```

### UI Design

1. **Consistent Icons**: Maintain consistent icon styles across tabs:
   - Use SF Symbols when possible
   - Keep similar visual weight between icons
   - Use filled versions for selected state if appropriate

2. **Color Coordination**: Match BubbleBar theme with your app's color scheme:

```swift
// Using your app's accent color
let customStyle = BubbleBar.Style.copying(.dark) { colors in
    var colors = colors
    colors.selectedItemColor = Color.accentColor
    colors.bubbleBackgroundColor = Color.accentColor.opacity(0.15)
    return colors
}
```

3. **Spacing**: Provide adequate spacing between items:

```swift
BubbleBarView(selectedTab: $selectedTab) {
    // Content
}
.bubbleBarPadding(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
```

### Accessibility

1. **Test with Assistive Technologies**: Regularly test with VoiceOver, different text sizes, and contrast settings.

2. **Provide Good Labels**: Ensure tab items have clear, concise labels that make sense when read aloud.

3. **Use System Fonts**: System fonts automatically adapt to Dynamic Type settings.

### Integration

1. **Navigation Integration**: Combine with NavigationStack when appropriate:

```swift
NavigationStack {
    BubbleBarView(selectedTab: $selectedTab) {
        // Tab content
    }
    .navigationTitle(titles[selectedTab])
}
```

2. **State Management**: Use appropriate state management for your app size:

```swift
// For smaller apps
@State private var selectedTab = 0

// For larger apps with more complex state
@EnvironmentObject var appState: AppState
// ...
BubbleBarView(selectedTab: $appState.selectedTab)
```

3. **Safe Area Handling**: Respect safe areas appropriately:

```swift
BubbleBarView(selectedTab: $selectedTab) {
    TabContent()
        .edgesIgnoringSafeArea([.horizontal, .top]) // Custom safe area handling
        .tabBarItem { /* ... */ }
}
```

## Requirements

- iOS 16.0+ / macOS 14.0+
- Swift 6.0+
- Xcode 15.0+

## License

This project is licensed under the MIT License - see the LICENSE file for details.
