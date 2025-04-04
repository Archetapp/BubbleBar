// Created By Jared Davidson

import SwiftUIX

/// A SwiftUI package that provides a customizable, animated tab bar with a bubble effect.
public enum BubbleBar {}

/// A customizable tab bar view that provides a modern, animated interface for navigation.
/// The tab bar features a bubble effect that moves between selected items and supports both icon and label display.
///
/// Example usage:
/// ```swift
/// BubbleBarView(selectedTab: $selectedTab) {
///     Text("Home View")
///         .tabBarItem {
///             Label("Home", systemImage: "house.fill")
///         }
///     Text("Settings View")
///         .tabBarItem {
///             Label("Settings", systemImage: "gear")
///         }
/// }
/// .bubbleBarStyle(.dark)
/// ```
public struct BubbleBarView<Content: View>: View {
    @Environment(\.bubbleBarConfiguration) private var configuration
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    @Environment(\.colorSchemeContrast) private var colorSchemeContrast
    @Environment(\.colorScheme) private var colorScheme
    @Namespace private var namespace
    @Binding var selectedTab: Int
    private let content: Content
    
    /// Creates a new bubble bar view.
    /// - Parameters:
    ///   - selectedTab: A binding to the currently selected tab index
    ///   - content: A view builder that creates the content for each tab
    public init(selectedTab: Binding<Int>, @ViewBuilder content: () -> Content) {
        self._selectedTab = selectedTab
        self.content = content()
        
        // Initialize accessibility settings immediately 
        // This ensures accessibility properties are properly set on initial render
        let _ = BubbleBar.Configuration().updateForAccessibility(
            dynamicTypeSize: DynamicTypeSize.large,
            reduceMotion: UIAccessibility.isReduceMotionEnabled,
            reduceTransparency: UIAccessibility.isReduceTransparencyEnabled,
            increasedContrast: UIAccessibility.isDarkerSystemColorsEnabled
        )
    }
    
    public var body: some View {
        // Update accessibility settings immediately
        let _ = configuration.updateForAccessibility(
            dynamicTypeSize: dynamicTypeSize,
            reduceMotion: reduceMotion,
            reduceTransparency: reduceTransparency,
            increasedContrast: colorSchemeContrast == .increased
        )
        
        return ZStack(alignment: .bottom) {
            _VariadicViewAdapter(content) { content in
                ZStack {
                    ForEach(content.children.indices, id: \.self) { index in
                        content.children[index]
                            .opacity(index == selectedTab ? 1 : 0)
                    }
                }
                .animation(reduceMotion ? .default : configuration.viewTransitionAnimation, value: selectedTab)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            BubbleBar._TabBarContainer {
                _VariadicViewAdapter(content) { content in
                    HStack {
                        ForEach(content.children.indices, id: \.self) { index in
                            if let itemInfo = content.children[index].traits.tabBarLabel {
                                BubbleBar._TabBarButton(
                                    label: itemInfo.label,
                                    isSelected: selectedTab == index,
                                    index: index,
                                    namespace: namespace,
                                    showLabel: configuration.showLabels,
                                    action: {
                                        withAnimation(reduceMotion ? .default : configuration.animation) {
                                            selectedTab = index
                                            #if canImport(UIKit)
                                            UIAccessibility.post(
                                                notification: .screenChanged,
                                                argument: "Switched to \(itemInfo.accessibilityLabel)"
                                            )
                                            #endif
                                        }
                                    }
                                )
                                .accessibilityLabel(itemInfo.accessibilityLabel)
                                .accessibilityHint(itemInfo.accessibilityHint)
                                
                                if index != content.children.indices.last && !configuration.equalItemSizing {
                                    Spacer()
                                }
                            }
                        }
                    }
                }
            }
            .animation(reduceMotion ? .default : configuration.animation, value: selectedTab)
            .environment(\.theme, configuration.style.theme)
            .compositingGroup()
            .shadow(
                color: configuration.style.theme.colors(for: colorScheme).barShadowColor,
                radius: configuration.shadowRadius,
                x: configuration.shadowOffset.x,
                y: configuration.shadowOffset.y
            )
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Navigation")
            .accessibilityHint("Tab bar for switching between different views")
            .accessibilityIdentifier("BubbleBar")
            .accessibilityAddTraits(.isTabBar)
            .offset(y: configuration.isVisible ? 0 : 100)
            .animation(reduceMotion ? .default : configuration.animation, value: configuration.isVisible)
            .onChange(of: dynamicTypeSize) { _, _ in
                updateAccessibilitySettings()
            }
            .onChange(of: reduceMotion) { _, _ in
                updateAccessibilitySettings()
            }
            .onChange(of: reduceTransparency) { _, _ in
                updateAccessibilitySettings()
            }
            .onChange(of: colorSchemeContrast) { _, _ in
                updateAccessibilitySettings()
            }
        }
        .ignoresSafeArea(.keyboard)
    }
    
    private func updateAccessibilitySettings() {
        configuration.updateForAccessibility(
            dynamicTypeSize: dynamicTypeSize,
            reduceMotion: reduceMotion,
            reduceTransparency: reduceTransparency,
            increasedContrast: colorSchemeContrast == .increased
        )
    }
}

// MARK: - View Modifiers
public extension View {
    /// Applies a custom style to the bubble bar.
    /// - Parameter style: The style to apply
    /// - Returns: A view with the modified bubble bar style
    func bubbleBarStyle(_ style: BubbleBar.Style) -> some View {
        transformEnvironment(\.bubbleBarConfiguration) { config in
            if config.increasedContrastEnabled {
                config.originalStyle = style  // Store the new style as original
            } else {
                config.style = style  // Apply the style directly
                config.originalStyle = style  // Store as original
            }
        }
    }
    
    /// Sets the animation used for tab transitions and bubble movement.
    /// - Parameter animation: The animation to apply
    /// - Returns: A view with the modified bubble bar animation
    func bubbleBarAnimation(_ animation: Animation) -> some View {
        transformEnvironment(\.bubbleBarConfiguration) { config in
            config.animation = animation
        }
    }
    
    /// Controls whether labels are shown for selected tabs.
    /// - Parameter show: Whether to show labels
    /// - Returns: A view with the modified label visibility
    func showBubbleBarLabels(_ show: Bool) -> some View {
        transformEnvironment(\.bubbleBarConfiguration) { config in
            config.showLabels = show
        }
    }
    
    /// Sets the size of the bubble bar.
    /// - Parameter size: The desired size of the bubble bar
    /// - Returns: A view with the modified bubble bar size
    func bubbleBarSize(_ size: CGSize) -> some View {
        transformEnvironment(\.bubbleBarConfiguration) { config in
            config.size = size
        }
    }
    
    /// Sets the shape of the bubble bar container.
    /// - Parameter shape: The shape to apply to the container
    /// - Returns: A view with the modified bubble bar container shape
    func bubbleBarShape<S: Shape>(_ shape: S) -> some View {
        transformEnvironment(\.bubbleBarConfiguration) { config in
            config.shape = AnyShape(shape)
        }
    }
    
    /// Sets the shape of the bubble bar items.
    /// - Parameter shape: The shape to apply to the selected item background
    /// - Returns: A view with the modified bubble bar item shape
    func bubbleBarItemShape<S: Shape>(_ shape: S) -> some View {
        transformEnvironment(\.bubbleBarConfiguration) { config in
            config.itemShape = AnyShape(shape)
        }
    }
    
    /// Sets the padding around the bubble bar.
    /// - Parameter padding: The padding to apply
    /// - Returns: A view with the modified bubble bar padding
    func bubbleBarPadding(_ padding: EdgeInsets) -> some View {
        transformEnvironment(\.bubbleBarConfiguration) { config in
            config.padding = padding
        }
    }
    
    /// Configures the shadow for the bubble bar.
    /// - Parameters:
    ///   - radius: The blur radius of the shadow
    ///   - color: The color of the shadow
    ///   - offset: The offset of the shadow
    /// - Returns: A view with the modified bubble bar shadow
    func bubbleBarShadow(
        radius: CGFloat = 1,
        color: Color = .black.opacity(0.2),
        offset: CGPoint = .zero
    ) -> some View {
        transformEnvironment(\.bubbleBarConfiguration) { config in
            config.shadowRadius = radius
            config.style = .copying(config.style) { colors in
                var colors = colors
                colors.barShadowColor = color
                return colors
            }
            config.shadowOffset = offset
        }
    }
    
    /// Makes all bubble bar items equal in size.
    /// - Parameter enabled: Whether to enable equal sizing for all items
    /// - Returns: A view with the modified bubble bar item sizing
    func bubbleBarItemEqualSizing(_ enabled: Bool) -> some View {
        transformEnvironment(\.bubbleBarConfiguration) { config in
            config.equalItemSizing = enabled
        }
    }
    
    /// Applies a glass morphism effect to the bubble bar.
    /// - Parameters:
    ///   - enabled: Whether to enable the glass effect
    /// - Returns: A view with the modified glass effect
    func bubbleBarGlass(
        _ enabled: Bool = true
    ) -> some View {
        transformEnvironment(\.bubbleBarConfiguration) { config in
            config.isGlass = enabled
        }
    }
    
    /// Controls the visibility of the bubble bar.
    /// - Parameter isVisible: Whether the bubble bar should be visible
    /// - Returns: A view with the modified bubble bar visibility
    func showsBubbleBar(_ isVisible: Bool) -> some View {
        transformEnvironment(\.bubbleBarConfiguration) { config in
            config.isVisible = isVisible
        }
    }
    
    /// Wraps the view in a bubble bar with the specified selected tab.
    /// - Parameter selectedTab: A binding to the currently selected tab index
    /// - Returns: A view wrapped in a bubble bar
    func bubbleBar(selectedTab: Binding<Int>) -> some View {
        BubbleBarView(selectedTab: selectedTab) {
            self
        }
    }
}

// MARK: - Deprecated
public extension View {
    @available(*, deprecated, message: "View transitions are no longer supported to maintain view state")
    func bubbleBarViewTransition(_ transition: AnyTransition) -> some View {
        self
    }
    
    @available(*, deprecated, message: "View transitions are no longer supported to maintain view state")
    func bubbleBarViewTransitionAnimation(_ animation: Animation) -> some View {
        self
    }
}
