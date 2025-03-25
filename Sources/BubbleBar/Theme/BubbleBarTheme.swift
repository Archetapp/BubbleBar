// Created By Jared Davidson

import SwiftUI

extension BubbleBar {
    @frozen
    public struct Theme: Sendable, Equatable {
        public struct Colors: Sendable, Equatable {
            public struct BackgroundStyle: Sendable, Equatable {
                public let color: Color
                public let blurRadius: CGFloat
                public let opacity: Double
                
                public init(color: Color, blurRadius: CGFloat = 0, opacity: Double = 1.0) {
                    self.color = color
                    self.blurRadius = blurRadius
                    self.opacity = opacity
                }
                
                public func background() -> some ShapeStyle {
                    color.opacity(opacity)
                }
            }
            
            public let cardBackground: BackgroundStyle
            public let primary: Color
            public let textSecondary: Color
            public let shadow: Color
            
            public init(
                cardBackground: BackgroundStyle,
                primary: Color,
                textSecondary: Color,
                shadow: Color
            ) {
                self.cardBackground = cardBackground
                self.primary = primary
                self.textSecondary = textSecondary
                self.shadow = shadow
            }
            
            public static var `default`: Colors {
                Colors(
                    cardBackground: BackgroundStyle(color: .green, opacity: 0.1),
                    primary: .green,
                    textSecondary: .gray,
                    shadow: .black
                )
            }
            
            public static var glass: Colors {
                Colors(
                    cardBackground: BackgroundStyle(color: .white, blurRadius: 10, opacity: 0.2),
                    primary: .white,
                    textSecondary: .white.opacity(0.7),
                    shadow: .black
                )
            }
        }
        
        public let colors: Colors
        
        public init(colors: Colors) {
            self.colors = colors
        }
        
        public static var `default`: Theme {
            Theme(colors: .default)
        }
        
        public static var glass: Theme {
            Theme(colors: .glass)
        }
    }
}

private struct ThemeKey: EnvironmentKey {
    static let defaultValue = BubbleBar.Theme.default
}

public extension EnvironmentValues {
    var theme: BubbleBar.Theme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
} 
