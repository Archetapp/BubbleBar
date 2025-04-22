// Created By Jared Davidson

import SwiftUIX

/// A SwiftUI package that provides a customizable, animated tab bar with a bubble effect.
public enum BubbleBar {}

// Import the ScaleFactorPreferenceKey from TabBarContainer
private typealias ScaleFactorPreferenceKey = BubbleBar.ScaleFactorPreferenceKey

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
///
/// The view automatically adds bottom padding to content to prevent it from being obscured by the tab bar.
/// You can customize this padding using the `bubbleBarContentPadding(_:)` modifier:
///
/// ```swift
/// BubbleBarView(selectedTab: $selectedTab) {
///     // Your tab views here
/// }
/// .bubbleBarContentPadding(80) // Custom padding
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
    @State private var commonScaleFactor: CGFloat = 1.0
    private let content: Content
    @State private var tabBarHeight: CGFloat = 0
    
    /// Creates a new bubble bar view.
    /// - Parameters:
    ///   - selectedTab: A binding to the currently selected tab index
    ///   - content: A view builder that creates the content for each tab
    public init(selectedTab: Binding<Int>, @ViewBuilder content: () -> Content) {
        self._selectedTab = selectedTab
        self.content = content()
    }
    
    public var body: some View {
        let forceHighContrast = ProcessInfo.processInfo.arguments.contains("ENABLE_HIGH_CONTRAST")
        
        let _ = configuration.updateForAccessibility(
            dynamicTypeSize: dynamicTypeSize,
            reduceMotion: reduceMotion,
            reduceTransparency: reduceTransparency,
            increasedContrast: colorSchemeContrast == .increased || forceHighContrast
        )
        
        let contentPadding = configuration.contentBottomPadding
        
        return ZStack(alignment: .bottom) {
            contentView(contentPadding: contentPadding)
            tabBarView()
        }
        .ignoresSafeArea(.keyboard)
        .onPreferenceChange(TabBarSizePreferenceKey.self) { height in
            tabBarHeight = height
        }
    }
    
    @ViewBuilder
    private func contentView(contentPadding: CGFloat) -> some View {
        _VariadicViewAdapter(content) { content in
            ZStack {
                ForEach(content.children.indices, id: \.self) { index in
                    content.children[index]
                        .transition(configuration.viewTransition)
                        .opacity(index == selectedTab ? 1 : 0)
                        .if(contentPadding > 0) { view in
                            view.padding(.bottom, contentPadding)
                        }
                }
            }
            .animation(reduceMotion ? .default : configuration.viewTransitionAnimation, value: selectedTab)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    private func tabBarView() -> some View {
        BubbleBar._TabBarContainer {
            _VariadicViewAdapter(content) { content in
                let spacing = dynamicTypeSize.isAccessibilitySize ?
                    configuration.bubbleBarItemSpacing.isAccessibilitySize :
                    configuration.bubbleBarItemSpacing.regular
                
                HStack(spacing: spacing) {
                    ForEach(content.children.indices, id: \.self) { index in
                        if let itemInfo = content.children[index].traits.tabBarLabel {
                            tabBarButton(for: index, itemInfo: itemInfo)
                            
                            if index != content.children.indices.last && !configuration.equalItemSizing {
                                Spacer(minLength: dynamicTypeSize.isAccessibilitySize ? 1 : 0)
                            }
                        }
                    }
                }
                .frame(maxHeight: max(
                    (configuration.size?.height ?? 80) + (configuration.padding.top + configuration.padding.bottom),
                    (configuration.itemHeight ?? 80) + (configuration.padding.top + configuration.padding.bottom)
                ))
            }
        }
        .frame(width: Screen.width)
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
    }
    
    @ViewBuilder
    private func tabBarButton(for index: Int, itemInfo: TabBarItemInfo) -> some View {
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
            },
            commonScaleFactor: $commonScaleFactor
        )
        .accessibilityLabel(itemInfo.accessibilityLabel)
        .accessibilityHint(itemInfo.accessibilityHint)
        .onPreferenceChange(ScaleFactorPreferenceKey.self) { newValue in
            withAnimation {
                commonScaleFactor = min(commonScaleFactor, newValue)
            }
        }
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
    
    /// adaptively adjust the bubble bar width of the bubble bar items's width
    /// - Parameter enabled: Whether to enable equal width for all items's total width
    /// - Returns: A view with the modified bubble bar item width
    func bubbleBarAdaptiveItemsWidth(_ enabled: Bool) -> some View {
        transformEnvironment(\.bubbleBarConfiguration) { config in
            config.adaptiveItemsWidth = enabled
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
    
    /// Sets the inner padding of the bubble bar content.
    /// - Parameter padding: The inner padding to apply
    /// - Returns: A view with the modified bubble bar inner padding
    func bubbleBarInnerPadding(_ padding: EdgeInsets) -> some View {
        transformEnvironment(\.bubbleBarConfiguration) { config in
            config.innerPadding = padding
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
    ///   - material: Optional Material to use for the glass effect. If provided, this will override the custom shader.
    /// - Returns: A view with the modified glass effect
    func bubbleBarGlass(
        _ enabled: Bool = true,
        material: Material? = nil
    ) -> some View {
        transformEnvironment(\.bubbleBarConfiguration) { config in
            config.isGlass = enabled
            config.glassMaterial = material
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
    
    /// Sets the bottom padding for content to avoid overlap with the bubble bar.
    /// - Parameter padding: The amount of bottom padding to apply to content
    /// - Returns: A view with the specified bottom padding to avoid the bubble bar
    ///
    /// By default, no extra padding is added (padding = 0). With padding = 0,
    /// the content will respect the system's safe area insets and the tab bar will
    /// appear within the safe area. To add explicit spacing between content and
    /// the tab bar, set this to a positive value.
    func bubbleBarContentPadding(_ padding: CGFloat) -> some View {
        transformEnvironment(\.bubbleBarConfiguration) { config in
            config.contentBottomPadding = padding
        }
    }
    
    /// Sets the position of the item bar indicator.
    /// - Parameter position: The position of the item bar (.center, .top, or .bottom)
    /// - Returns: A view with the modified item bar position
    func bubbleBarItemPosition(_ position: BubbleBar.ItemBarPosition) -> some View {
        transformEnvironment(\.bubbleBarConfiguration) { config in
            config.itemBarPosition = position
        }
    }
    
    /// Sets the size of the item bar indicator.
    /// - Parameter size: The size to apply to the item bar
    /// - Returns: A view with the modified item bar size
    func bubbleBarItemBarSize(_ width: CGFloat? = nil, height: CGFloat? = nil) -> some View {
        transformEnvironment(\.bubbleBarConfiguration) { config in
            config.itemBarWidth = width
            config.itemBarHeight = height
        }
    }
    
    /// Sets the size of the item bar indicator.
    /// - Parameter size: The size to apply to the item bar
    /// - Returns: A view with the modified item bar size
    func bubbleBarItemSize(_ width: CGFloat? = nil, height: CGFloat? = nil) -> some View {
        transformEnvironment(\.bubbleBarConfiguration) { config in
            config.itemWidth = width
            config.itemHeight = height
        }
    }
    
    /// Sets the spacing between items in the bubble bar.
    /// - Parameters:
    ///   - regular: The spacing to use for regular dynamic type sizes
    ///   - accessibility: The spacing to use when in accessibility sizes
    /// - Returns: A view with the modified item spacing
    func bubbleBarItemSpacing(_ regular: CGFloat = 4, accessibility: CGFloat = 8) -> some View {
        transformEnvironment(\.bubbleBarConfiguration) { config in
            config.bubbleBarItemSpacing = (isAccessibilitySize: accessibility, regular: regular)
        }
    }
    
    /// Sets the position of labels in the bubble bar.
    /// - Parameter position: The position of the labels (.top, .bottom, .left, or .right)
    /// - Returns: A view with the modified label position
    func bubbleBarLabelPosition(_ position: BubbleBar.LabelPosition) -> some View {
        transformEnvironment(\.bubbleBarConfiguration) { config in
            config.labelPosition = position
        }
    }
    
    /// Controls whether labels are visible in the bubble bar.
    /// - Parameter visible: Whether labels should be visible
    /// - Returns: A view with the modified label visibility
    func bubbleBarLabelsVisible(_ visible: Bool) -> some View {
        transformEnvironment(\.bubbleBarConfiguration) { config in
            config.labelsVisible = visible
        }
    }
    
    /// Sets the font sizes for the bubble bar items
    /// - Parameters:
    ///   - iconStyle: The text style for icons (e.g. .title, .body)
    ///   - labelStyle: The text style for labels (e.g. .caption, .body)
    /// - Returns: A view with the modified font styles
    func bubbleBarFontSizes(icon iconStyle: Font.TextStyle = .title2, label labelStyle: Font.TextStyle = .caption) -> some View {
        transformEnvironment(\.bubbleBarConfiguration) { config in
            config.iconTextStyle = iconStyle
            config.labelTextStyle = labelStyle
        }
    }
    
    /// Controls whether the bubble bar should maintain consistent sizing across all items
    /// - Parameter enabled: Whether to enable consistent sizing
    /// - Returns: A view with the modified sizing behavior
    func bubbleBarConsistentSizing(_ enabled: Bool) -> some View {
        transformEnvironment(\.bubbleBarConfiguration) { config in
            config.useConsistentSizing = enabled
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
