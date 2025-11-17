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
    
    /// Optional custom tap action for this tab item
    public let customTapAction: (() -> Void)?
    
    public init(
        label: AnyView,
        accessibilityLabel: String,
        accessibilityHint: String = "Double tap to switch to this tab",
        customTapAction: (() -> Void)? = nil
    ) {
        self.label = label
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityHint = accessibilityHint
        self.customTapAction = customTapAction
    }
}

// MARK: - Internal Implementation
internal struct TabBarLabelKey: _ViewTraitKey {
    @inlinable
    static var defaultValue: TabBarItemInfo? {
        nil
    }
}

// Separate trait key to hold a custom tap action.
internal struct TabBarTapActionKey: _ViewTraitKey {
    @inlinable
    static var defaultValue: (() -> Void)? {
        nil
    }
}

extension _ViewTraitKeys {
    internal var tabBarLabel: TabBarLabelKey.Type {
        TabBarLabelKey.self
    }

    internal var tabBarTapAction: TabBarTapActionKey.Type {
        TabBarTapActionKey.self
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
    
    /// Adds a custom tap action to a tab bar item
    /// - Parameter action: The action to perform when this tab item is tapped
    /// - Returns: A view with custom tap behavior for this tab item
    public func onTabItemTap(_ action: @escaping () -> Void) -> some View {
        self.modifier(TabItemTapModifier(action: action))
    }
}

// MARK: - Tab Item Tap Modifier
private struct TabItemTapModifier: ViewModifier {
    let action: () -> Void
    
    func body(content: Content) -> some View {
        content
            // Store the tap action in a separate trait so we can
            // combine it with the label trait at consumption time.
            ._trait(\.tabBarTapAction, action)
    }
} 
