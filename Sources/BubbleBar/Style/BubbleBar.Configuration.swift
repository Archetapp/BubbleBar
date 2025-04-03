// Created By Jared Davidson

import SwiftUI

extension BubbleBar {
    @MainActor
    public final class Configuration: ObservableObject, Sendable {
        public var style: Style
        public var animation: Animation
        public var viewTransitionAnimation: Animation
        public var viewTransition: AnyTransition
        public var showLabels: Bool
        public var size: CGSize?
        public var shape: AnyShape
        public var itemShape: AnyShape
        public var padding: EdgeInsets
        public var equalItemSizing: Bool
        public var shadowRadius: CGFloat
        public var shadowColor: Color
        public var shadowOffset: CGPoint
        public var isGlass: Bool
        public var glassBlurRadius: CGFloat
        public var glassOpacity: Double
        public var glassTint: Color
        public var isVisible: Bool
        
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
            shadowRadius: CGFloat = 8,
            shadowColor: Color = .black.opacity(0.1),
            shadowOffset: CGPoint = .zero,
            isGlass: Bool = false,
            glassBlurRadius: CGFloat = 10,
            glassOpacity: Double = 0.2,
            glassTint: Color = .white,
            isVisible: Bool = true
        ) {
            self.style = style
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
            self.shadowColor = shadowColor
            self.shadowOffset = shadowOffset
            self.isGlass = isGlass
            self.glassBlurRadius = glassBlurRadius
            self.glassOpacity = glassOpacity
            self.glassTint = glassTint
            self.isVisible = isVisible
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
