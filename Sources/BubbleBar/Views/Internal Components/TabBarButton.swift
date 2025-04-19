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
                return configuration.itemBarHeight ?? (dynamicTypeSize.isAccessibilitySize ? 36 : 24)
            } else {
                return configuration.itemBarHeight ?? 4
            }
        }
        
        private var itemBarWidth: CGFloat? {
            return configuration.itemBarWidth
        }
        
        private var iconView: some View {
            label
                .labelStyle(.iconOnly)
                .font(.title3.weight(.regular).leading(.loose))
                .minimumScaleFactor(0.05)
                .frame(width: configuration.itemBarPosition == .center ? itemBarWidth : nil,
                       height: configuration.itemBarPosition == .center ? itemBarHeight : nil)
                .foregroundColor(isSelected ? theme.resolveColors(for: colorScheme).selectedItemColor : theme.resolveColors(for: colorScheme).unselectedItemColor)
                .if(!reduceMotion) { view in
                    view.matchedGeometryEffect(id: "ICON_\(index)", in: namespace)
                }
                .accessibility(label: Text(accessibilityLabel))
        }
        
        private var labelView: some View {
            Group {
                if (showLabel && isSelected) || configuration.labelsVisible {
                    label
                        .labelStyle(.titleOnly)
                        .font(.body.weight(.medium).leading(.loose))
                        .minimumScaleFactor(0.01) // Reduced from 0.05 to allow for more aggressive scaling
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .frame(maxWidth: dynamicTypeSize.isAccessibilitySize ? 120 : 100)
                        .fixedSize(horizontal: false, vertical: true) // Force the label to shrink rather than expand
                        .foregroundColor(isSelected ? theme.resolveColors(for: colorScheme).selectedItemColor : theme.resolveColors(for: colorScheme).unselectedItemColor)
                        .if(!reduceMotion) { view in
                            view.matchedGeometryEffect(id: "LABEL_\(index)", in: namespace)
                        }
                        .transition(.opacity)
                }
            }
        }
        
        var body: some View {
            Button(action: action) {
                VStack(spacing: 0) {
                    upperline
                    Group {
                        switch configuration.labelPosition {
                        case .top:
                            VStack(spacing: 4) {
                                labelView
                                iconView
                            }
                        case .bottom:
                            VStack(spacing: 4) {
                                iconView
                                labelView
                            }
                        case .left:
                            HStack(spacing: 4) {
                                labelView
                                iconView
                            }
                        case .right:
                            HStack(spacing: 4) {
                                iconView
                                labelView
                            }
                        }
                    }
                    .frame(minWidth: 20, maxWidth: isSelected ? (dynamicTypeSize.isAccessibilitySize ? 180 : 150) : nil)
                    .padding(configuration.bubbleBarItemPadding)
                    .fixedSize(horizontal: configuration.equalItemSizing ? false : true, vertical: false)
                    .background {
                        switch configuration.itemBarPosition {
                            case .center:
                                if isSelected {
                                    ZStack {
                                        configuration.itemShape
                                            .fill(theme.resolveColors(for: colorScheme).bubbleBackgroundColor)
                                        configuration.itemShape
                                            .stroke(theme.resolveColors(for: colorScheme).bubbleStrokeColor, lineWidth: 0.5)
                                    }
                                    .if(!reduceMotion) { view in
                                        view.matchedGeometryEffect(id: "BUBBLE", in: namespace)
                                    }
                                }
                            default:
                                EmptyView()
                        }
                    }
                    underline
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
        
        var upperline: some View {
            Group {
                switch configuration.itemBarPosition {
                    case .top:
                        if isSelected {
                            configuration.itemShape
                                .fill(theme.resolveColors(for: colorScheme).selectedItemColor)
                                .frame(
                                    maxWidth: itemBarWidth ?? .infinity,
                                    maxHeight: itemBarHeight
                                )
                                .padding(.horizontal, configuration.bubbleBarItemPadding.leading)
                                .if(!reduceMotion) { view in
                                    view.matchedGeometryEffect(id: "UPPERLINE", in: namespace)
                                }
                        } else {
                            Color.clear
                                .frame(
                                    maxWidth: itemBarWidth ?? .infinity,
                                    maxHeight: itemBarHeight
                                )
                                .padding(.horizontal, configuration.bubbleBarItemPadding.leading)
                        }
                    default:
                        EmptyView()
                }
            }
        }
        
        
        var underline: some View {
            Group {
                switch configuration.itemBarPosition {
                    case .bottom:
                        if isSelected {
                            configuration.itemShape
                                .fill(theme.resolveColors(for: colorScheme).selectedItemColor)
                                .frame(
                                    maxWidth: itemBarWidth ?? .infinity,
                                    maxHeight: itemBarHeight
                                )
                                .padding(.horizontal, configuration.bubbleBarItemPadding.leading)
                                .if(!reduceMotion) { view in
                                    view.matchedGeometryEffect(id: "UNDERLINE", in: namespace)
                                }
                        } else {
                            Color.clear
                                .frame(
                                    maxWidth: itemBarWidth ?? .infinity,
                                    maxHeight: itemBarHeight
                                )
                                .padding(.horizontal, configuration.bubbleBarItemPadding.leading)
                        }
                    default:
                        EmptyView()
                }
            }
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
