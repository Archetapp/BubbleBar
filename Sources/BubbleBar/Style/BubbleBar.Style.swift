// Created By Jared Davidson

import SwiftUI

extension BubbleBar {
    /// A style configuration for the bubble bar that defines its visual appearance.
    /// The style includes a theme that specifies colors for various UI elements.
    @frozen public struct Style: Sendable {
        public let theme: BubbleBar.Theme
        
        /// Creates a new style with the specified theme.
        /// - Parameter theme: The theme to apply to the bubble bar
        public init(theme: BubbleBar.Theme) {
            self.theme = theme
        }
        
        /// A dark theme with blue accents, suitable for dark mode interfaces.
        public static var dark: Style {
            Style(theme: BubbleBar.Theme(colors: .init(
                cardBackground: .init(color: Color(red: 0.1, green: 0.1, blue: 0.15)),
                primary: Color.blue,
                textSecondary: Color(.secondarySystemFill),
                shadow: Color.black
            )))
        }
        
        /// A warm desert theme with orange and beige tones.
        public static var desert: Style {
            Style(theme: BubbleBar.Theme(colors: .init(
                cardBackground: .init(color: Color(red: 0.95, green: 0.9, blue: 0.85)),
                primary: Color(red: 0.8, green: 0.4, blue: 0.2),
                textSecondary: Color(red: 0.5, green: 0.4, blue: 0.3),
                shadow: Color(red: 0.8, green: 0.4, blue: 0.2)
            )))
        }
        
        /// A natural forest theme with green tones.
        public static var forest: Style {
            Style(theme: BubbleBar.Theme(colors: .init(
                cardBackground: .init(color: Color(red: 0.9, green: 0.95, blue: 0.9)),
                primary: Color(red: 0.2, green: 0.6, blue: 0.3),
                textSecondary: Color(red: 0.4, green: 0.5, blue: 0.4),
                shadow: Color(red: 0.2, green: 0.6, blue: 0.3)
            )))
        }
        
        /// A dark blue theme optimized for night-time use.
        public static var nightOwl: Style {
            Style(theme: BubbleBar.Theme(colors: .init(
                cardBackground: .init(color: Color(red: 0.2, green: 0.2, blue: 0.25)),
                primary: Color(red: 0.2, green: 0.4, blue: 0.8),
                textSecondary: Color(red: 0.7, green: 0.7, blue: 0.8),
                shadow: Color.black
            )))
        }
        
        /// A high contrast theme optimized for accessibility.
        public static var highContrast: Style {
            Style(theme: BubbleBar.Theme(colors: .init(
                cardBackground: .init(color: .white),
                primary: .black,
                textSecondary: Color(red: 0.4, green: 0.4, blue: 0.4),
                shadow: Color.clear
            )))
        }
        
        /// A cool ocean theme with blue tones.
        public static var ocean: Style {
            Style(theme: BubbleBar.Theme(colors: .init(
                cardBackground: .init(color: .white),
                primary: Color(red: 0.0, green: 0.5, blue: 0.8),
                textSecondary: Color(red: 0.3, green: 0.4, blue: 0.5),
                shadow: Color(red: 0.0, green: 0.5, blue: 0.8)
            )))
        }
        
        /// A modern glass morphism theme with blur effects and transparency.
        public static var glass: Style {
            Style(theme: .glass) // Goes well if .bubbleBarGlass() is enabled.
        }
    }
} 
