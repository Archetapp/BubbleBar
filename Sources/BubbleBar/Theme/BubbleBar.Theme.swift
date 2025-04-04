// Created By Jared Davidson

import SwiftUI

extension BubbleBar {
    @frozen
    public struct Theme: Sendable {
        public struct Colors: Sendable, Equatable {
            // Bar colors
            public var cardBackground: Color
            public var barStrokeColor: Color
            public var barShadowColor: Color
            
            // Item colors
            public var selectedItemColor: Color
            public var unselectedItemColor: Color
            
            // Bubble colors
            public var bubbleBackgroundColor: Color
            public var bubbleStrokeColor: Color
            
            public init(
                cardBackground: Color,
                barStrokeColor: Color,
                barShadowColor: Color = Color.clear,
                selectedItemColor: Color,
                unselectedItemColor: Color,
                bubbleBackgroundColor: Color = Color.clear,
                bubbleStrokeColor: Color = Color.clear
            ) {
                self.cardBackground = cardBackground
                self.barStrokeColor = barStrokeColor
                self.barShadowColor = barShadowColor
                self.selectedItemColor = selectedItemColor
                self.unselectedItemColor = unselectedItemColor
                self.bubbleBackgroundColor = bubbleBackgroundColor
                self.bubbleStrokeColor = bubbleStrokeColor
            }
            
            public static var `default`: Colors {
                Colors(
                    cardBackground: Color.green.opacity(0.1),
                    barStrokeColor: Color.green.opacity(0.2),
                    barShadowColor: Color.black,
                    selectedItemColor: Color.green,
                    unselectedItemColor: Color.gray,
                    bubbleBackgroundColor: Color.green.opacity(0.15),
                    bubbleStrokeColor: Color.green.opacity(0.4)
                )
            }
        }
        
        private let colorsProvider: @Sendable (ColorScheme) -> Colors
        
        public func colors(for colorScheme: ColorScheme) -> Colors {
            colorsProvider(colorScheme)
        }
        
        public init(colors: Colors) {
            self.colorsProvider = { _ in colors }
        }
        
        public init(colorsProvider: @escaping @Sendable (ColorScheme) -> Colors) {
            self.colorsProvider = colorsProvider
        }
        
        public static var `default`: Theme {
            Theme(colors: .default)
        }
        
        public func resolveColors(for colorScheme: ColorScheme) -> Colors {
            colorsProvider(colorScheme)
        }
    }
}

extension BubbleBar.Theme: Equatable {
    public static func == (lhs: BubbleBar.Theme, rhs: BubbleBar.Theme) -> Bool {
        // Since themes can have dynamic colors based on ColorScheme,
        // we need to compare their outputs for both light and dark modes
        let lhsLightColors = lhs.colorsProvider(.light)
        let rhsLightColors = rhs.colorsProvider(.light)
        let lhsDarkColors = lhs.colorsProvider(.dark)
        let rhsDarkColors = rhs.colorsProvider(.dark)
        
        return lhsLightColors == rhsLightColors && lhsDarkColors == rhsDarkColors
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

// MARK: - Deprecated
public extension BubbleBar.Theme.Colors {
    @available(*, deprecated, message: "Use the new initializer with explicit color parameters instead")
    init(
        cardBackground: Color,
        primary: Color,
        textSecondary: Color,
        shadow: Color
    ) {
        self.init(
            cardBackground: cardBackground,
            barStrokeColor: primary.opacity(0.2),
            barShadowColor: shadow,
            selectedItemColor: primary,
            unselectedItemColor: textSecondary,
            bubbleBackgroundColor: primary.opacity(0.15),
            bubbleStrokeColor: primary.opacity(0.4)
        )
    }
}
