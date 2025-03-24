# BubbleBar

<img src="https://github.com/user-attachments/assets/57228e48-9d6b-4d4d-84d7-33c9371f16df" width="100%">

A modern, customizable SwiftUI tab bar with a bubble effect animation. BubbleBar provides a sleek and intuitive navigation experience for iOS and macOS applications.

## Features

- 🎨 Multiple built-in themes (Dark, Desert, Forest, Night Owl, High Contrast, Ocean)
- ✨ Smooth bubble animation between tabs
- 🎯 Customizable container and item shapes
- 📐 Flexible sizing options (fixed or edge-to-edge)
- 🔤 Optional label display for selected tabs
- 🎭 Customizable shadows and effects
- 🎬 Independent animations for tab bar and view transitions
- 📱 iOS 16+ and macOS 14+ support

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/archetapp/BubbleBar.git", from: "1.0.0")
]
```

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

### Available Themes

- `.dark` - Dark mode optimized with blue accents
- `.desert` - Warm orange and beige tones
- `.forest` - Natural green theme
- `.nightOwl` - Dark blue theme for night use
- `.highContrast` - Accessibility optimized theme
- `.ocean` - Cool blue tones
- Or create your own!

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

### Sizing Behavior

BubbleBar supports two sizing modes:
1. Edge-to-edge (default) - The bar stretches to fill the available width
2. Fixed size - Set a specific size using `bubbleBarSize()`

### Item Sizing Options

Control how items are sized within the bar:
1. Dynamic (default) - Selected items expand to show labels
2. Equal sizing - All items maintain equal width using `bubbleBarItemEqualSizing(true)`

## Accessibility

BubbleBar includes some accessibility support (Could be better I think)
I just need to deep dive into accessibility to really know.

## Requirements

- iOS 16.0+ / macOS 14.0+
- Swift 6.0+
- Xcode 15.0+

## License

This project is licensed under the MIT License - see the LICENSE file for details.
