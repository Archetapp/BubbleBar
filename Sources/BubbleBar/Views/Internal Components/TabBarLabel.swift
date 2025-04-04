// Created By Jared Davidson

import SwiftUIX

/// Represents a tab bar item's label and accessibility information
public struct TabBarItemInfo {
    /// The visual representation of the tab item
    public let label: AnyView
    
    /// The accessibility label used by VoiceOver
    public let accessibilityLabel: String
    
    /// The accessibility hint used by VoiceOver
    public let accessibilityHint: String
    
    public init(
        label: AnyView,
        accessibilityLabel: String,
        accessibilityHint: String = "Double tap to switch to this tab"
    ) {
        self.label = label
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityHint = accessibilityHint
    }
}

// MARK: - Internal Implementation
internal struct TabBarLabelKey: _ViewTraitKey {
    @inlinable
    static var defaultValue: TabBarItemInfo? {
        nil
    }
}

extension _ViewTraitKeys {
    internal var tabBarLabel: TabBarLabelKey.Type {
        TabBarLabelKey.self
    }
}

extension View {
    /// Adds a tab bar item with accessibility support
    /// - Parameters:
    ///   - label: The visual label for the tab
    ///   - accessibilityLabel: The label read by VoiceOver (defaults to the tab's title if not provided)
    ///   - accessibilityHint: Additional hint for VoiceOver users
    /// - Returns: A view with tab bar item and accessibility information
    public func tabBarItem<V: View>(
        @ViewBuilder label: @escaping () -> V,
        accessibilityLabel: String? = nil,
        accessibilityHint: String = "Double tap to switch to this tab"
    ) -> some View {
        let labelView = label()
        // Try to extract title from Label if no accessibility label is provided
        let derivedLabel: String
        if let providedLabel = accessibilityLabel {
            derivedLabel = providedLabel
        } else {
            // Attempt to get the title from a Label view
            let mirror = Mirror(reflecting: labelView)
            derivedLabel = mirror.children
                .first { $0.label == "title" }
                .flatMap { $0.value as? String } ?? "Tab"
        }
        
        return _trait(
            \.tabBarLabel,
            TabBarItemInfo(
                label: AnyView(labelView),
                accessibilityLabel: derivedLabel,
                accessibilityHint: accessibilityHint
            )
        )
    }
} 
