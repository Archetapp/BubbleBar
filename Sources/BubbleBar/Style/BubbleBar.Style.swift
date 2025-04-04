// Created By Jared Davidson

import SwiftUI

extension BubbleBar {
    /// A style configuration for the bubble bar that defines its visual appearance.
    /// The style includes a theme that specifies colors for various UI elements.
    @frozen public struct Style: Sendable {
        public var theme: BubbleBar.Theme
        
        /// Creates a new style with the specified theme.
        /// - Parameter theme: The theme to apply to the bubble bar
        public init(theme: BubbleBar.Theme) {
            self.theme = theme
        }
        
        /// Creates a new style with fully customizable colors for all bubble bar elements.
        /// - Parameters:
        ///   - selectedItemColor: Color for selected tab items (text and icons)
        ///   - unselectedItemColor: Color for unselected tab items
        ///   - bubbleBackgroundColor: Background color for the selected item bubble
        ///   - bubbleStrokeColor: Border color for the selected item bubble
        ///   - barBackgroundColor: Background color of the entire bar
        ///   - barStrokeColor: Border color of the bar
        ///   - barShadowColor: Shadow color of the bar
        public init(
            selectedItemColor: Color,
            unselectedItemColor: Color,
            bubbleBackgroundColor: Color,
            bubbleStrokeColor: Color = Color.clear,
            barBackgroundColor: Color,
            barStrokeColor: Color = Color.clear,
            barShadowColor: Color = Color.clear
        ) {
            let colors = Theme.Colors(
                cardBackground: barBackgroundColor,
                barStrokeColor: barStrokeColor,
                barShadowColor: barShadowColor,
                selectedItemColor: selectedItemColor,
                unselectedItemColor: unselectedItemColor,
                bubbleBackgroundColor: bubbleBackgroundColor,
                bubbleStrokeColor: bubbleStrokeColor
            )
            
            self.init(theme: Theme(colors: colors))
        }
        
        /// Creates a new style by copying an existing style and modifying specific colors.
        /// - Parameters:
        ///   - style: The style to copy from
        ///   - modifyColors: A closure that takes the existing colors and returns modified colors
        /// - Returns: A new style with the modified colors
        public static func copying(
            _ style: Style,
            modifyColors: (Theme.Colors) -> Theme.Colors
        ) -> Style {
            let newColors = modifyColors(style.theme.colors(for: .light))  // Default to light scheme for modification
            return Style(theme: Theme(colors: newColors))
        }
        
        /// Creates a new style that adapts to the current color scheme.
        /// - Parameter styleProvider: A closure that takes a ColorScheme and returns a Style
        public init(_ styleProvider: @escaping @Sendable (ColorScheme) -> Style) {
            self.theme = Theme { colorScheme in
                styleProvider(colorScheme).theme.resolveColors(for: colorScheme)
            }
        }
        
        /// A dark theme with blue accents, suitable for dark mode interfaces.
        public static var dark: Style {
            Style(
                selectedItemColor: Color.blue,
                unselectedItemColor: Color(.secondarySystemFill),
                bubbleBackgroundColor: Color.blue.opacity(0.15),
                bubbleStrokeColor: Color.blue.opacity(0.4),
                barBackgroundColor: Color(red: 0.1, green: 0.1, blue: 0.15),
                barStrokeColor: Color.blue.opacity(0.2),
                barShadowColor: Color.black
            )
        }
        
        /// A warm desert theme with orange and beige tones.
        public static var desert: Style {
            Style { colorScheme in
                let primary = Color(red: 0.8, green: 0.4, blue: 0.2)
                let isDark = colorScheme == .dark
                
                return Style(
                    selectedItemColor: primary,
                    unselectedItemColor: isDark ? Color.white.opacity(0.6) : Color(red: 0.5, green: 0.4, blue: 0.3),
                    bubbleBackgroundColor: primary.opacity(0.15),
                    bubbleStrokeColor: primary.opacity(0.4),
                    barBackgroundColor: isDark ? Color(red: 0.2, green: 0.15, blue: 0.1) : Color(red: 0.95, green: 0.9, blue: 0.85),
                    barStrokeColor: primary.opacity(0.2),
                    barShadowColor: primary
                )
            }
        }
        
        /// A natural forest theme with green tones.
        public static var forest: Style {
            Style { colorScheme in
                let primary = Color(red: 0.2, green: 0.6, blue: 0.3)
                let isDark = colorScheme == .dark
                
                return Style(
                    selectedItemColor: primary,
                    unselectedItemColor: isDark ? Color.white.opacity(0.6) : Color(red: 0.4, green: 0.5, blue: 0.4),
                    bubbleBackgroundColor: primary.opacity(0.15),
                    bubbleStrokeColor: primary.opacity(0.4),
                    barBackgroundColor: isDark ? Color(red: 0.1, green: 0.15, blue: 0.1) : Color(red: 0.9, green: 0.95, blue: 0.9),
                    barStrokeColor: primary.opacity(0.2),
                    barShadowColor: primary
                )
            }
        }
        
        /// A dark blue theme optimized for night-time use.
        public static var nightOwl: Style {
            Style { colorScheme in
                let primary = Color(red: 0.2, green: 0.4, blue: 0.8)
                let isDark = colorScheme == .dark
                
                return Style(
                    selectedItemColor: primary,
                    unselectedItemColor: isDark ? Color.white.opacity(0.6) : Color(red: 0.7, green: 0.7, blue: 0.8),
                    bubbleBackgroundColor: primary.opacity(0.15),
                    bubbleStrokeColor: primary.opacity(0.4),
                    barBackgroundColor: isDark ? Color(red: 0.1, green: 0.1, blue: 0.15) : Color(red: 0.95, green: 0.95, blue: 1.0),
                    barStrokeColor: primary.opacity(0.2),
                    barShadowColor: Color.black
                )
            }
        }
        
        /// A high contrast theme optimized for accessibility.
        public static var highContrast: Style {
            Style { colorScheme in
                let isDark = colorScheme == .dark
                
                return Style(
                    selectedItemColor: isDark ? Color.white : Color.black,
                    unselectedItemColor: isDark ? Color.white.opacity(0.6) : Color(red: 0.4, green: 0.4, blue: 0.4),
                    bubbleBackgroundColor: (isDark ? Color.white : Color.black).opacity(0.15),
                    bubbleStrokeColor: (isDark ? Color.white : Color.black).opacity(0.4),
                    barBackgroundColor: isDark ? Color.black : Color.white,
                    barStrokeColor: (isDark ? Color.white : Color.black).opacity(0.2),
                    barShadowColor: Color.clear
                )
            }
        }
        
        /// A cool ocean theme with blue tones.
        public static var ocean: Style {
            Style { colorScheme in
                let primary = Color(red: 0.0, green: 0.5, blue: 0.8)
                let isDark = colorScheme == .dark
                
                return Style(
                    selectedItemColor: primary,
                    unselectedItemColor: isDark ? Color.white.opacity(0.6) : Color(red: 0.3, green: 0.4, blue: 0.5),
                    bubbleBackgroundColor: primary.opacity(0.15),
                    bubbleStrokeColor: primary.opacity(0.4),
                    barBackgroundColor: isDark ? Color(red: 0.1, green: 0.15, blue: 0.2) : Color.white,
                    barStrokeColor: primary.opacity(0.2),
                    barShadowColor: primary
                )
            }
        }
        
        /// A modern glass morphism theme with blur effects and transparency.
        public static var glass: Style {
            Style { colorScheme in
                let isDark = colorScheme == .dark
                
                return Style(
                    selectedItemColor: isDark ? Color.white : Color.black,
                    unselectedItemColor: isDark ? Color.white.opacity(0.7) : Color.black.opacity(0.7),
                    bubbleBackgroundColor: (isDark ? Color.white : Color.black).opacity(0.15),
                    bubbleStrokeColor: (isDark ? Color.white : Color.black).opacity(0.4),
                    barBackgroundColor: (isDark ? Color.white : Color.black).opacity(0.2),
                    barStrokeColor: (isDark ? Color.white : Color.black).opacity(0.2),
                    barShadowColor: isDark ? Color.black : Color.black.opacity(0.3)
                )
            }
        }
    }
} 

// MARK: - Deprecated
public extension BubbleBar.Style {
    @available(*, deprecated, message: "Use the new initializer with explicit color parameters instead")
    init(
        cardBackground: Color,
        primary: Color,
        textSecondary: Color,
        shadow: Color
    ) {
        self.theme = BubbleBar.Theme(colors: .init(
            cardBackground: cardBackground,
            primary: primary,
            textSecondary: textSecondary,
            shadow: shadow
        ))
    }
} 
