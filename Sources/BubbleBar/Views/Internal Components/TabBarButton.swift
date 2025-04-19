// Created By Jared Davidson

import SwiftUIX

extension BubbleBar {
    /// Internal implementation of the tab bar button
    internal struct _TabBarButton: View {
        @Environment(\.theme) private var theme
        @Environment(\.colorScheme) private var colorScheme
        @Environment(\.bubbleBarConfiguration) private var configuration
        @Environment(\.dynamicTypeSize) private var dynamicTypeSize
        @Environment(\.accessibilityReduceMotion) private var reduceMotion
        
        let label: AnyView
        let isSelected: Bool
        let index: Int
        var namespace: Namespace.ID
        let showLabel: Bool
        let action: () -> Void
        
        private var itemBarHeight: CGFloat {
            if configuration.itemBarPosition == .center {
                return configuration.itemBarSize?.height ?? (dynamicTypeSize.isAccessibilitySize ? 36 : 24)
            } else {
                return configuration.itemBarSize?.height ?? 4
            }
        }
        
        private var itemBarWidth: CGFloat? {
            return configuration.itemBarSize?.width
        }
        
        var body: some View {
            Button(action: action) {
                HStack(spacing: dynamicTypeSize.isAccessibilitySize ? 8 : 4) {
                    label
                        .labelStyle(.iconOnly)
                        .font(.title3.weight(.regular).leading(.loose))
                        .minimumScaleFactor(0.8)
                        .frame(width: configuration.itemBarPosition == .center ? itemBarWidth : nil,
                               height: configuration.itemBarPosition == .center ? itemBarHeight : nil)
                        .foregroundColor(isSelected ? theme.resolveColors(for: colorScheme).selectedItemColor : theme.resolveColors(for: colorScheme).unselectedItemColor)
                        .if(!reduceMotion) { view in
                            view.matchedGeometryEffect(id: "ICON_\(index)", in: namespace)
                        }
                        .accessibility(label: Text(accessibilityLabel))
                    
                    if isSelected && showLabel {
                        label
                            .labelStyle(.titleOnly)
                            .font(.body.weight(.medium).leading(.loose))
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .frame(maxWidth: dynamicTypeSize.isAccessibilitySize ? 120 : 100)
                            .foregroundColor(theme.resolveColors(for: colorScheme).selectedItemColor)
                            .if(!reduceMotion) { view in
                                view.matchedGeometryEffect(id: "LABEL_\(index)", in: namespace)
                            }
                            .transition(.opacity)
                    }
                }
                        .frame(minWidth: 20, maxWidth: isSelected ? (dynamicTypeSize.isAccessibilitySize ? 180 : 150) : nil)
                        .padding(configuration.bubbleBarItemPadding)
                        .fixedSize(horizontal: configuration.equalItemSizing ? false : true, vertical: false)
                        .background {
                            if isSelected {
                                switch configuration.itemBarPosition {
                                    case .center:
                                        ZStack {
                                            configuration.itemShape
                                                .fill(theme.resolveColors(for: colorScheme).bubbleBackgroundColor)
                                            configuration.itemShape
                                                .stroke(theme.resolveColors(for: colorScheme).bubbleStrokeColor, lineWidth: 0.5)
                                        }
                                        .if(!reduceMotion) { view in
                                            view.matchedGeometryEffect(id: "BUBBLE", in: namespace)
                                        }
                                    case .top:
                                        VStack(spacing: 0) {
                                            configuration.itemShape
                                                .fill(theme.resolveColors(for: colorScheme).selectedItemColor)
                                                .frame(
                                                    maxWidth: itemBarWidth ?? .infinity,
                                                    maxHeight: itemBarHeight
                                                )
                                                .padding(.horizontal, configuration.bubbleBarItemPadding.leading)
                                                .if(!reduceMotion) { view in
                                                    view.matchedGeometryEffect(id: "BUBBLE", in: namespace)
                                                }
                                            Spacer()
                                        }
                                    case .bottom:
                                        VStack(spacing: 0) {
                                            Spacer()
                                            configuration.itemShape
                                                .fill(theme.resolveColors(for: colorScheme).selectedItemColor)
                                                .frame(
                                                    maxWidth: itemBarWidth ?? .infinity,
                                                    maxHeight: itemBarHeight
                                                )
                                                .padding(.horizontal, configuration.bubbleBarItemPadding.leading)
                                                .if(!reduceMotion) { view in
                                                    view.matchedGeometryEffect(id: "BUBBLE", in: namespace)
                                                }
                                        }
                                }
                            }
                        }
            }
            .buttonStyle(.plain)
            .frame(maxWidth: configuration.equalItemSizing ? .infinity : nil)
            .animation(reduceMotion ? .easeOut(duration: 0.15) : configuration.animation, value: isSelected && showLabel)
            .accessibilityElement(children: .combine)
            .accessibilityLabel(accessibilityLabel)
            .accessibilityHint(accessibilityHint)
            .accessibilityValue(isSelected ? "Selected" : "")
            .accessibilityAddTraits(isSelected ? [.isSelected, .isButton, .isTabBar] : [.isButton, .isTabBar])
            .accessibilityIdentifier("TabItem-\(index)")
            .contentShape(Rectangle())
        }
        
        /// Gets the accessibility label from the label view using reflection
        private var accessibilityLabel: String {
            let mirror = Mirror(reflecting: label)
            let title = mirror.children
                .first { $0.label == "title" }?
                .value as? String ?? "Tab"
            return title
        }
        
        /// Gets the appropriate accessibility hint based on selection state
        private var accessibilityHint: String {
            isSelected ?
            NSLocalizedString("Currently selected", comment: "Accessibility hint for selected tab") :
            NSLocalizedString("Double tap to switch to this tab", comment: "Accessibility hint for unselected tab")
        }
    }
}

// MARK: - Utility Extensions

extension Font {
    /// Creates a font with loose leading for better readability
    func dynamic() -> Font {
        self.leading(.loose)
    }
}

extension View {
    /// Converts a view to AnyView for type erasure
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
    
    /// Conditional view modifier that applies a transform only when the condition is true
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
