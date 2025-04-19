// Created By Jared Davidson

import SwiftUIX

extension BubbleBar {
    public enum ItemBarPosition {
        case center
        case top
        case bottom
    }
    
    @MainActor
    public final class Configuration: ObservableObject, Sendable {
        public var style: Style
        internal var originalStyle: Style
        public var animation: Animation
        public var viewTransitionAnimation: Animation
        public var viewTransition: AnyTransition
        public var showLabels: Bool
        public var size: CGSize?
        public var adaptiveItemsWidth: Bool
        public var shape: AnyShape
        public var itemShape: AnyShape
        public var padding: EdgeInsets
        public var bubbleBarItemPadding: EdgeInsets
        public var equalItemSizing: Bool
        
        // Item spacing
        public var bubbleBarItemSpacing: (isAccessibilitySize: CGFloat, regular: CGFloat)
        
        // Item bar position and size
        public var itemBarPosition: ItemBarPosition
        public var itemBarSize: CGSize?
        
        // Shadow properties
        public var shadowRadius: CGFloat
        public var shadowOffset: CGPoint
        
        // Glass effect properties
        public var isGlass: Bool
        public var glassBlurRadius: CGFloat
        public var glassOpacity: Double
        public var glassTint: Color
        public var glassMaterial: Material?
        public var isVisible: Bool
        
        // Content spacing properties
        public var contentBottomPadding: CGFloat
        
        // Accessibility properties
        public var minimumTouchTargetSize: CGSize
        public var accessibilitySpacing: EdgeInsets
        public var useReducedMotion: Bool
        public var increasedContrastEnabled: Bool
        
        public init(
            style: Style = .forest,
            animation: Animation = .spring(response: 0.3, dampingFraction: 0.7),
            viewTransitionAnimation: Animation = .smooth,
            viewTransition: AnyTransition = .opacity,
            showLabels: Bool = true,
            size: CGSize? = nil,
            adaptiveItemsWidth: Bool = false,
            shape: AnyShape = AnyShape(RoundedRectangle(cornerRadius: 28)),
            itemShape: AnyShape = AnyShape(RoundedRectangle(cornerRadius: 24)),
            padding: EdgeInsets = EdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6),
            bubbleBarItemPadding: EdgeInsets = EdgeInsets(top: 10, leading: 14, bottom: 10, trailing: 14),
            equalItemSizing: Bool = false,
            bubbleBarItemSpacing: (isAccessibilitySize: CGFloat, regular: CGFloat) = (8, 4),
            itemBarPosition: ItemBarPosition = .center,
            itemBarSize: CGSize? = nil,
            shadowRadius: CGFloat = 1,
            shadowOffset: CGPoint = .zero,
            isGlass: Bool = false,
            glassBlurRadius: CGFloat = 10,
            glassOpacity: Double = 0.2,
            glassTint: Color = .white,
            glassMaterial: Material? = nil,
            isVisible: Bool = true,
            contentBottomPadding: CGFloat = 0,
            minimumTouchTargetSize: CGSize = CGSize(width: 44, height: 44),
            accessibilitySpacing: EdgeInsets = EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24),
            useReducedMotion: Bool = false,
            increasedContrastEnabled: Bool = false
        ) {
            self.style = increasedContrastEnabled ? .highContrast : style
            self.originalStyle = style  // Store the original style
            self.animation = animation
            self.viewTransitionAnimation = viewTransitionAnimation
            self.viewTransition = viewTransition
            self.showLabels = showLabels
            self.size = size
            self.adaptiveItemsWidth = adaptiveItemsWidth
            self.shape = shape
            self.itemShape = itemShape
            self.padding = padding
            self.bubbleBarItemPadding = bubbleBarItemPadding
            self.equalItemSizing = equalItemSizing
            self.bubbleBarItemSpacing = bubbleBarItemSpacing
            self.itemBarPosition = itemBarPosition
            self.itemBarSize = itemBarSize
            self.shadowRadius = shadowRadius
            self.shadowOffset = shadowOffset
            self.isGlass = isGlass
            self.glassBlurRadius = glassBlurRadius
            self.glassOpacity = glassOpacity
            self.glassTint = glassTint
            self.glassMaterial = glassMaterial
            self.isVisible = isVisible
            self.contentBottomPadding = contentBottomPadding
            
            // Initialize accessibility properties
            self.minimumTouchTargetSize = minimumTouchTargetSize
            self.accessibilitySpacing = accessibilitySpacing
            self.useReducedMotion = useReducedMotion
            self.increasedContrastEnabled = increasedContrastEnabled
        }
        
        /// Convenience initializer for direct color customization
        public convenience init(
            selectedItemColor: Color,
            unselectedItemColor: Color,
            bubbleBackgroundColor: Color,
            bubbleStrokeColor: Color,
            barStrokeColor: Color,
            barShadowColor: Color,
            animation: Animation = .spring(response: 0.3, dampingFraction: 0.7),
            viewTransitionAnimation: Animation = .smooth,
            viewTransition: AnyTransition = .opacity,
            showLabels: Bool = true,
            size: CGSize? = nil,
            adaptiveItemsWidth: Bool = false,
            shape: AnyShape = AnyShape(RoundedRectangle(cornerRadius: 28)),
            itemShape: AnyShape = AnyShape(RoundedRectangle(cornerRadius: 24)),
            padding: EdgeInsets = EdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6),
            bubbleBarItemPadding: EdgeInsets = EdgeInsets(top: 10, leading: 14, bottom: 10, trailing: 14),
            equalItemSizing: Bool = false,
            bubbleBarItemSpacing: (isAccessibilitySize: CGFloat, regular: CGFloat) = (8, 4),
            itemBarPosition: ItemBarPosition = .center,
            itemBarSize: CGSize? = nil,
            shadowRadius: CGFloat = 8,
            shadowOffset: CGPoint = .zero,
            isGlass: Bool = false,
            glassBlurRadius: CGFloat = 10,
            glassOpacity: Double = 0.2,
            glassTint: Color = .white,
            glassMaterial: Material? = nil,
            isVisible: Bool = true,
            contentBottomPadding: CGFloat = 0
        ) {
            // Create a custom style with the provided colors
            let customStyle = Style(
                selectedItemColor: selectedItemColor,
                unselectedItemColor: unselectedItemColor,
                bubbleBackgroundColor: selectedItemColor.opacity(0.15),
                bubbleStrokeColor: selectedItemColor.opacity(0.4),
                barBackgroundColor: .clear, // We'll handle background separately
                barStrokeColor: selectedItemColor.opacity(0.2),
                barShadowColor: barShadowColor
            )
            
            self.init(
                style: customStyle,
                animation: animation,
                viewTransitionAnimation: viewTransitionAnimation,
                viewTransition: viewTransition,
                showLabels: showLabels,
                size: size,
                adaptiveItemsWidth: adaptiveItemsWidth,
                shape: shape,
                itemShape: itemShape,
                padding: padding,
                bubbleBarItemPadding: bubbleBarItemPadding,
                equalItemSizing: equalItemSizing,
                bubbleBarItemSpacing: bubbleBarItemSpacing,
                itemBarPosition: itemBarPosition,
                itemBarSize: itemBarSize,
                shadowRadius: shadowRadius,
                shadowOffset: shadowOffset,
                isGlass: isGlass,
                glassBlurRadius: glassBlurRadius,
                glassOpacity: glassOpacity,
                glassTint: glassTint,
                glassMaterial: glassMaterial,
                isVisible: isVisible,
                contentBottomPadding: contentBottomPadding
            )
        }
        
        /// Updates the configuration based on the current accessibility settings
        public func updateForAccessibility(
            dynamicTypeSize: DynamicTypeSize,
            reduceMotion: Bool,
            reduceTransparency: Bool,
            increasedContrast: Bool
        ) -> BubbleBar.Configuration {
            // Store the state
            self.useReducedMotion = reduceMotion
            self.increasedContrastEnabled = increasedContrast
            
            // Apply size adjustments for accessibility
            if dynamicTypeSize.isAccessibilitySize {
                // Limit the size to prevent overflow
                let height: CGFloat = max(54, min(64, 64))
                if let currentSize = self.size {
                    self.size = CGSize(width: currentSize.width, height: height)
                }
                
                // Adjust padding
                self.padding = EdgeInsets(
                    top: self.padding.top,
                    leading: max(6, self.padding.leading),
                    bottom: self.padding.bottom,
                    trailing: max(6, self.padding.trailing)
                )
                
                // Adjust item padding for accessibility
                self.bubbleBarItemPadding = EdgeInsets(
                    top: max(10, self.bubbleBarItemPadding.top),
                    leading: max(8, self.bubbleBarItemPadding.leading),
                    bottom: max(10, self.bubbleBarItemPadding.bottom),
                    trailing: max(8, self.bubbleBarItemPadding.trailing)
                )
            }
            
            // Apply high contrast if needed - first check system setting, then parameter
            #if canImport(UIKit)
            let isSystemHighContrastEnabled = UIAccessibility.isDarkerSystemColorsEnabled
            #else
            let isSystemHighContrastEnabled = false
            #endif
            
            let shouldUseHighContrast = isSystemHighContrastEnabled || increasedContrast
            
            if shouldUseHighContrast {
                self.style = .highContrast
            } else {
                self.style = self.originalStyle
            }
            
            // Simplify animations for reduced motion
            if reduceMotion {
                self.animation = .default
                self.viewTransitionAnimation = .default
                self.viewTransition = .opacity
            }
            
            // Disable glass effect for reduced transparency
            if reduceTransparency {
                self.isGlass = false
                
                // Also ensure sufficient contrast
                let newStyle = Style.copying(self.style) { colors in
                    var colors = colors
                    // Get the current bubble background opacity
                    let bubbleColorOpacity: Double = 0.9
                    
                    // Ensure solid backgrounds by setting explicit opacity
                    colors.bubbleBackgroundColor = colors.bubbleBackgroundColor.opacity(bubbleColorOpacity)
                    return colors
                }
                self.style = newStyle
            }
            
            return self
        }
    }
}

// MARK: - Environment Key
struct BubbleBarConfigurationKey: @preconcurrency EnvironmentKey {
    @MainActor
    static let defaultValue = BubbleBar.Configuration()
}

extension EnvironmentValues {
    var bubbleBarConfiguration: BubbleBar.Configuration {
        get { self[BubbleBarConfigurationKey.self] }
        set { self[BubbleBarConfigurationKey.self] = newValue }
    }
} 
