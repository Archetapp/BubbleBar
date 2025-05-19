// Created By Jared Davidson

import SwiftUI

// MARK: - Style Modifier
public struct BubbleBarStyleModifier: ViewModifier {
    let style: BubbleBar.Style
    
    public func body(content: Content) -> some View {
        content.transformEnvironment(\.bubbleBarConfiguration) { config in
            if config.increasedContrastEnabled {
                config.originalStyle = style
            } else {
                config.style = style
                config.originalStyle = style
            }
        }
    }
}

// MARK: - Animation Modifier
public struct BubbleBarAnimationModifier: ViewModifier {
    let animation: Animation
    
    public func body(content: Content) -> some View {
        content.transformEnvironment(\.bubbleBarConfiguration) { config in
            config.animation = animation
        }
    }
}

// MARK: - Show Labels Modifier
public struct ShowBubbleBarLabelsModifier: ViewModifier {
    let show: Bool
    
    public func body(content: Content) -> some View {
        content.transformEnvironment(\.bubbleBarConfiguration) { config in
            config.showLabels = show
        }
    }
}

// MARK: - Size Modifier
public struct BubbleBarSizeModifier: ViewModifier {
    let size: CGSize
    
    public func body(content: Content) -> some View {
        content.transformEnvironment(\.bubbleBarConfiguration) { config in
            config.size = size
        }
    }
}

// MARK: - Adaptive Items Width Modifier
public struct BubbleBarAdaptiveItemsWidthModifier: ViewModifier {
    let enabled: Bool
    
    public func body(content: Content) -> some View {
        content.transformEnvironment(\.bubbleBarConfiguration) { config in
            config.adaptiveItemsWidth = enabled
        }
    }
}

// MARK: - Shape Modifier
public struct BubbleBarShapeModifier<S: Shape>: ViewModifier {
    let shape: S
    
    public func body(content: Content) -> some View {
        content.transformEnvironment(\.bubbleBarConfiguration) { config in
            config.shape = AnyShape(shape)
        }
    }
}

// MARK: - Item Shape Modifier
public struct BubbleBarItemShapeModifier<S: Shape>: ViewModifier {
    let shape: S
    
    public func body(content: Content) -> some View {
        content.transformEnvironment(\.bubbleBarConfiguration) { config in
            config.itemShape = AnyShape(shape)
        }
    }
}

// MARK: - Padding Modifier
public struct BubbleBarPaddingModifier: ViewModifier {
    let padding: EdgeInsets
    
    public func body(content: Content) -> some View {
        content.transformEnvironment(\.bubbleBarConfiguration) { config in
            config.padding = padding
        }
    }
}

// MARK: - Inner Padding Modifier
public struct BubbleBarInnerPaddingModifier: ViewModifier {
    let padding: EdgeInsets
    
    public func body(content: Content) -> some View {
        content.transformEnvironment(\.bubbleBarConfiguration) { config in
            config.innerPadding = padding
        }
    }
}

// MARK: - Shadow Modifier
public struct BubbleBarShadowModifier: ViewModifier {
    let radius: CGFloat
    let color: Color
    let offset: CGPoint
    
    public func body(content: Content) -> some View {
        content.transformEnvironment(\.bubbleBarConfiguration) { config in
            config.shadowRadius = radius
            config.style = .copying(config.style) { colors in
                var colors = colors
                colors.barShadowColor = color
                return colors
            }
            config.shadowOffset = offset
        }
    }
}

// MARK: - Item Equal Sizing Modifier
public struct BubbleBarItemEqualSizingModifier: ViewModifier {
    let enabled: Bool
    
    public func body(content: Content) -> some View {
        content.transformEnvironment(\.bubbleBarConfiguration) { config in
            config.equalItemSizing = enabled
        }
    }
}

// MARK: - Glass Modifier
public struct BubbleBarGlassModifier: ViewModifier {
    let enabled: Bool
    let material: Material?
    
    public func body(content: Content) -> some View {
        content.transformEnvironment(\.bubbleBarConfiguration) { config in
            config.isGlass = enabled
            config.glassMaterial = material
        }
    }
}

// MARK: - Shows Bubble Bar Modifier
public struct ShowsBubbleBarModifier: ViewModifier {
    let isVisible: Bool
    
    public func body(content: Content) -> some View {
        content.transformEnvironment(\.bubbleBarConfiguration) { config in
            config.isVisible = isVisible
        }
    }
}

// MARK: - Bubble Bar Modifier
public struct BubbleBarModifier: ViewModifier {
    let selectedTab: Binding<Int>
    
    public func body(content: Content) -> some View {
        BubbleBarView(selectedTab: selectedTab) {
            content
        }
    }
}

// MARK: - Content Padding Modifier
public struct BubbleBarContentPaddingModifier: ViewModifier {
    let padding: CGFloat
    
    public func body(content: Content) -> some View {
        content.transformEnvironment(\.bubbleBarConfiguration) { config in
            config.contentBottomPadding = padding
        }
    }
}

// MARK: - Item Position Modifier
public struct BubbleBarItemPositionModifier: ViewModifier {
    let position: BubbleBar.ItemBarPosition
    
    public func body(content: Content) -> some View {
        content.transformEnvironment(\.bubbleBarConfiguration) { config in
            config.itemBarPosition = position
        }
    }
}

// MARK: - Item Bar Size Modifier
public struct BubbleBarItemBarSizeModifier: ViewModifier {
    let width: CGFloat?
    let height: CGFloat?
    
    public func body(content: Content) -> some View {
        content.transformEnvironment(\.bubbleBarConfiguration) { config in
            config.itemBarWidth = width
            config.itemBarHeight = height
        }
    }
}

// MARK: - Item Size Modifier
public struct BubbleBarItemSizeModifier: ViewModifier {
    let width: CGFloat?
    let height: CGFloat?
    
    public func body(content: Content) -> some View {
        content.transformEnvironment(\.bubbleBarConfiguration) { config in
            config.itemWidth = width
            config.itemHeight = height
        }
    }
}

// MARK: - Item Spacing Modifier
public struct BubbleBarItemSpacingModifier: ViewModifier {
    let regular: CGFloat
    let accessibility: CGFloat
    
    public func body(content: Content) -> some View {
        content.transformEnvironment(\.bubbleBarConfiguration) { config in
            config.bubbleBarItemSpacing = (isAccessibilitySize: accessibility, regular: regular)
        }
    }
}

// MARK: - Label Position Modifier
public struct BubbleBarLabelPositionModifier: ViewModifier {
    let position: BubbleBar.LabelPosition
    
    public func body(content: Content) -> some View {
        content.transformEnvironment(\.bubbleBarConfiguration) { config in
            config.labelPosition = position
        }
    }
}

// MARK: - Labels Visible Modifier
public struct BubbleBarLabelsVisibleModifier: ViewModifier {
    let visible: Bool
    
    public func body(content: Content) -> some View {
        content.transformEnvironment(\.bubbleBarConfiguration) { config in
            config.labelsVisible = visible
        }
    }
}

// MARK: - Font Sizes Modifier
public struct BubbleBarFontSizesModifier: ViewModifier {
    let iconStyle: Font.TextStyle
    let labelStyle: Font.TextStyle
    
    public func body(content: Content) -> some View {
        content.transformEnvironment(\.bubbleBarConfiguration) { config in
            config.iconTextStyle = iconStyle
            config.labelTextStyle = labelStyle
        }
    }
}

// MARK: - Consistent Sizing Modifier
public struct BubbleBarConsistentSizingModifier: ViewModifier {
    let enabled: Bool
    
    public func body(content: Content) -> some View {
        content.transformEnvironment(\.bubbleBarConfiguration) { config in
            config.useConsistentSizing = enabled
        }
    }
}

// MARK: - Can Swipe Between Views Modifier
public struct BubbleBarCanSwipeBetweenViewsModifier: ViewModifier {
    let behavior: BubbleBar.SwipeBehavior
    
    public func body(content: Content) -> some View {
        content.transformEnvironment(\.bubbleBarConfiguration) { config in
            config.swipeBehavior = behavior
        }
    }
}
