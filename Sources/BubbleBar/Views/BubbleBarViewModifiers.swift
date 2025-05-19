// Created By Jared Davidson

import SwiftUI

public extension View {
    /// Applies a custom style to the bubble bar.
    /// - Parameter style: The style to apply
    /// - Returns: A view with the modified bubble bar style
    func bubbleBarStyle(_ style: BubbleBar.Style) -> ModifiedContent<Self, BubbleBarStyleModifier> {
        modifier(BubbleBarStyleModifier(style: style))
    }
    
    /// Sets the animation used for tab transitions and bubble movement.
    /// - Parameter animation: The animation to apply
    /// - Returns: A view with the modified bubble bar animation
    func bubbleBarAnimation(_ animation: Animation) -> ModifiedContent<Self, BubbleBarAnimationModifier> {
        modifier(BubbleBarAnimationModifier(animation: animation))
    }
    
    /// Controls whether labels are shown for selected tabs.
    /// - Parameter show: Whether to show labels
    /// - Returns: A view with the modified label visibility
    func showBubbleBarLabels(_ show: Bool) -> ModifiedContent<Self, ShowBubbleBarLabelsModifier> {
        modifier(ShowBubbleBarLabelsModifier(show: show))
    }
    
    /// Sets the size of the bubble bar.
    /// - Parameter size: The desired size of the bubble bar
    /// - Returns: A view with the modified bubble bar size
    func bubbleBarSize(_ size: CGSize) -> ModifiedContent<Self, BubbleBarSizeModifier> {
        modifier(BubbleBarSizeModifier(size: size))
    }
    
    /// adaptively adjust the bubble bar width of the bubble bar items's width
    /// - Parameter enabled: Whether to enable equal width for all items's total width
    /// - Returns: A view with the modified bubble bar item width
    func bubbleBarAdaptiveItemsWidth(_ enabled: Bool) -> ModifiedContent<Self, BubbleBarAdaptiveItemsWidthModifier> {
        modifier(BubbleBarAdaptiveItemsWidthModifier(enabled: enabled))
    }
    
    /// Sets the shape of the bubble bar container.
    /// - Parameter shape: The shape to apply to the container
    /// - Returns: A view with the modified bubble bar container shape
    func bubbleBarShape<S: Shape>(_ shape: S) -> ModifiedContent<Self, BubbleBarShapeModifier<S>> {
        modifier(BubbleBarShapeModifier(shape: shape))
    }
    
    /// Sets the shape of the bubble bar items.
    /// - Parameter shape: The shape to apply to the selected item background
    /// - Returns: A view with the modified bubble bar item shape
    func bubbleBarItemShape<S: Shape>(_ shape: S) -> ModifiedContent<Self, BubbleBarItemShapeModifier<S>> {
        modifier(BubbleBarItemShapeModifier(shape: shape))
    }
    
    /// Sets the padding around the bubble bar.
    /// - Parameter padding: The padding to apply
    /// - Returns: A view with the modified bubble bar padding
    func bubbleBarPadding(_ padding: EdgeInsets) -> ModifiedContent<Self, BubbleBarPaddingModifier> {
        modifier(BubbleBarPaddingModifier(padding: padding))
    }
    
    /// Sets the inner padding of the bubble bar content.
    /// - Parameter padding: The inner padding to apply
    /// - Returns: A view with the modified bubble bar inner padding
    func bubbleBarInnerPadding(_ padding: EdgeInsets) -> ModifiedContent<Self, BubbleBarInnerPaddingModifier> {
        modifier(BubbleBarInnerPaddingModifier(padding: padding))
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
    ) -> ModifiedContent<Self, BubbleBarShadowModifier> {
        modifier(BubbleBarShadowModifier(radius: radius, color: color, offset: offset))
    }
    
    /// Makes all bubble bar items equal in size.
    /// - Parameter enabled: Whether to enable equal sizing for all items
    /// - Returns: A view with the modified bubble bar item sizing
    func bubbleBarItemEqualSizing(_ enabled: Bool) -> ModifiedContent<Self, BubbleBarItemEqualSizingModifier> {
        modifier(BubbleBarItemEqualSizingModifier(enabled: enabled))
    }
    
    /// Applies a glass morphism effect to the bubble bar.
    /// - Parameters:
    ///   - enabled: Whether to enable the glass effect
    ///   - material: Optional Material to use for the glass effect. If provided, this will override the custom shader.
    /// - Returns: A view with the modified glass effect
    func bubbleBarGlass(
        _ enabled: Bool = true,
        material: Material? = nil
    ) -> ModifiedContent<Self, BubbleBarGlassModifier> {
        modifier(BubbleBarGlassModifier(enabled: enabled, material: material))
    }
    
    /// Controls the visibility of the bubble bar.
    /// - Parameter isVisible: Whether the bubble bar should be visible
    /// - Returns: A view with the modified bubble bar visibility
    func showsBubbleBar(_ isVisible: Bool) -> ModifiedContent<Self, ShowsBubbleBarModifier> {
        modifier(ShowsBubbleBarModifier(isVisible: isVisible))
    }
    
    /// Wraps the view in a bubble bar with the specified selected tab.
    /// - Parameter selectedTab: A binding to the currently selected tab index
    /// - Returns: A view wrapped in a bubble bar
    func bubbleBar(selectedTab: Binding<Int>) -> ModifiedContent<Self, BubbleBarModifier> {
        modifier(BubbleBarModifier(selectedTab: selectedTab))
    }
    
    /// Sets the bottom padding for content to avoid overlap with the bubble bar.
    /// - Parameter padding: The amount of bottom padding to apply to content
    /// - Returns: A view with the specified bottom padding to avoid the bubble bar
    ///
    /// By default, no extra padding is added (padding = 0). With padding = 0,
    /// the content will respect the system's safe area insets and the tab bar will
    /// appear within the safe area. To add explicit spacing between content and
    /// the tab bar, set this to a positive value.
    func bubbleBarContentPadding(_ padding: CGFloat) -> ModifiedContent<Self, BubbleBarContentPaddingModifier> {
        modifier(BubbleBarContentPaddingModifier(padding: padding))
    }
    
    /// Sets the position of the item bar indicator.
    /// - Parameter position: The position of the item bar (.center, .top, or .bottom)
    /// - Returns: A view with the modified item bar position
    func bubbleBarItemPosition(_ position: BubbleBar.ItemBarPosition) -> ModifiedContent<Self, BubbleBarItemPositionModifier> {
        modifier(BubbleBarItemPositionModifier(position: position))
    }
    
    /// Sets the size of the item bar indicator.
    /// - Parameter size: The size to apply to the item bar
    /// - Returns: A view with the modified item bar size
    func bubbleBarItemBarSize(_ width: CGFloat? = nil, height: CGFloat? = nil) -> ModifiedContent<Self, BubbleBarItemBarSizeModifier> {
        modifier(BubbleBarItemBarSizeModifier(width: width, height: height))
    }
    
    /// Sets the size of the item bar indicator.
    /// - Parameter size: The size to apply to the item bar
    /// - Returns: A view with the modified item bar size
    func bubbleBarItemSize(_ width: CGFloat? = nil, height: CGFloat? = nil) -> ModifiedContent<Self, BubbleBarItemSizeModifier> {
        modifier(BubbleBarItemSizeModifier(width: width, height: height))
    }
    
    /// Sets the spacing between items in the bubble bar.
    /// - Parameters:
    ///   - regular: The spacing to use for regular dynamic type sizes
    ///   - accessibility: The spacing to use when in accessibility sizes
    /// - Returns: A view with the modified item spacing
    func bubbleBarItemSpacing(_ regular: CGFloat = 4, accessibility: CGFloat = 8) -> ModifiedContent<Self, BubbleBarItemSpacingModifier> {
        modifier(BubbleBarItemSpacingModifier(regular: regular, accessibility: accessibility))
    }
    
    /// Sets the position of labels in the bubble bar.
    /// - Parameter position: The position of the labels (.top, .bottom, .left, or .right)
    /// - Returns: A view with the modified label position
    func bubbleBarLabelPosition(_ position: BubbleBar.LabelPosition) -> ModifiedContent<Self, BubbleBarLabelPositionModifier> {
        modifier(BubbleBarLabelPositionModifier(position: position))
    }
    
    /// Controls whether labels are visible in the bubble bar.
    /// - Parameter visible: Whether labels should be visible
    /// - Returns: A view with the modified label visibility
    func bubbleBarLabelsVisible(_ visible: Bool) -> ModifiedContent<Self, BubbleBarLabelsVisibleModifier> {
        modifier(BubbleBarLabelsVisibleModifier(visible: visible))
    }
    
    /// Sets the font sizes for the bubble bar items
    /// - Parameters:
    ///   - iconStyle: The text style for icons (e.g. .title, .body)
    ///   - labelStyle: The text style for labels (e.g. .caption, .body)
    /// - Returns: A view with the modified font styles
    func bubbleBarFontSizes(icon iconStyle: Font.TextStyle = .title2, label labelStyle: Font.TextStyle = .caption) -> ModifiedContent<Self, BubbleBarFontSizesModifier> {
        modifier(BubbleBarFontSizesModifier(iconStyle: iconStyle, labelStyle: labelStyle))
    }
    
    /// Controls whether the bubble bar should maintain consistent sizing across all items
    /// - Parameter enabled: Whether to enable consistent sizing
    /// - Returns: A view with the modified sizing behavior
    func bubbleBarConsistentSizing(_ enabled: Bool) -> ModifiedContent<Self, BubbleBarConsistentSizingModifier> {
        modifier(BubbleBarConsistentSizingModifier(enabled: enabled))
    }
    
    /// Controls how users can swipe between views in the bubble bar.
    /// - Parameter behavior: The swipe behavior to use (.disabled, .edges, or .full)
    /// - Returns: A view with the modified swipe behavior
    func bubbleBarCanSwipeBetweenViews(_ behavior: BubbleBar.SwipeBehavior) -> ModifiedContent<Self, BubbleBarCanSwipeBetweenViewsModifier> {
        modifier(BubbleBarCanSwipeBetweenViewsModifier(behavior: behavior))
    }
} 
