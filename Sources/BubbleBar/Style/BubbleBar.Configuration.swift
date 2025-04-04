// Created By Jared Davidson

import SwiftUIX

extension BubbleBar {
    @MainActor
    public final class Configuration: ObservableObject, Sendable {
        public var style: Style
        internal var originalStyle: Style
        public var animation: Animation
        public var viewTransitionAnimation: Animation
        public var viewTransition: AnyTransition
        public var showLabels: Bool
        public var size: CGSize?
        public var shape: AnyShape
        public var itemShape: AnyShape
        public var padding: EdgeInsets
        public var equalItemSizing: Bool
        
        // Shadow properties
        public var shadowRadius: CGFloat
        public var shadowOffset: CGPoint
        
        // Glass effect properties
        public var isGlass: Bool
        public var glassBlurRadius: CGFloat
        public var glassOpacity: Double
        public var glassTint: Color
        public var isVisible: Bool
        
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
            shape: AnyShape = AnyShape(RoundedRectangle(cornerRadius: 25)),
            itemShape: AnyShape = AnyShape(RoundedRectangle(cornerRadius: 20)),
            padding: EdgeInsets = EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16),
            equalItemSizing: Bool = false,
            shadowRadius: CGFloat = 1,
            shadowOffset: CGPoint = .zero,
            isGlass: Bool = false,
            glassBlurRadius: CGFloat = 10,
            glassOpacity: Double = 0.2,
            glassTint: Color = .white,
            isVisible: Bool = true,
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
            self.shape = shape
            self.itemShape = itemShape
            self.padding = padding
            self.equalItemSizing = equalItemSizing
            self.shadowRadius = shadowRadius
            self.shadowOffset = shadowOffset
            self.isGlass = isGlass
            self.glassBlurRadius = glassBlurRadius
            self.glassOpacity = glassOpacity
            self.glassTint = glassTint
            self.isVisible = isVisible
            
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
            shape: AnyShape = AnyShape(RoundedRectangle(cornerRadius: 25)),
            itemShape: AnyShape = AnyShape(RoundedRectangle(cornerRadius: 20)),
            padding: EdgeInsets = EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16),
            equalItemSizing: Bool = false,
            shadowRadius: CGFloat = 8,
            shadowOffset: CGPoint = .zero,
            isGlass: Bool = false,
            glassBlurRadius: CGFloat = 10,
            glassOpacity: Double = 0.2,
            glassTint: Color = .white,
            isVisible: Bool = true
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
                shape: shape,
                itemShape: itemShape,
                padding: padding,
                equalItemSizing: equalItemSizing,
                shadowRadius: shadowRadius,
                shadowOffset: shadowOffset,
                isGlass: isGlass,
                glassBlurRadius: glassBlurRadius,
                glassOpacity: glassOpacity,
                glassTint: glassTint,
                isVisible: isVisible
            )
        }
        
        /// Updates the configuration based on the current accessibility settings
        public func updateForAccessibility(
            dynamicTypeSize: DynamicTypeSize,
            reduceMotion: Bool,
            reduceTransparency: Bool,
            increasedContrast: Bool
        ) {
            // Update motion settings
            useReducedMotion = reduceMotion
            if reduceMotion {
                animation = .default
                viewTransitionAnimation = .default
            }
            
            // Update transparency settings
            isGlass = !reduceTransparency
            
            // Update contrast settings
            increasedContrastEnabled = increasedContrast || dynamicTypeSize.isAccessibilitySize
            if increasedContrastEnabled {
                style = .highContrast
            } else {
                style = originalStyle  // Restore the original style when contrast is disabled
            }
            
            // Update spacing for accessibility sizes
            if dynamicTypeSize.isAccessibilitySize {
                padding = accessibilitySpacing
                size = CGSize(
                    width: size?.width ?? Screen.main.bounds.width - 32,
                    height: max(size?.height ?? 54, 64)
                )
            }
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
