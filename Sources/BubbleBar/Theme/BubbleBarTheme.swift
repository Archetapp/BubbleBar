// Created By Jared Davidson

import SwiftUI

extension BubbleBar {
    @frozen
    public struct Theme: Sendable, Equatable {
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
                    cardBackground: .green.opacity(0.1),
                    barStrokeColor: .green.opacity(0.2),
                    barShadowColor: .black,
                    selectedItemColor: .green,
                    unselectedItemColor: .gray,
                    bubbleBackgroundColor: .green.opacity(0.15),
                    bubbleStrokeColor: .green.opacity(0.4)
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
