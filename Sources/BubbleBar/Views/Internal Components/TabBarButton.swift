// Created By Jared Davidson

import SwiftUIX

extension BubbleBar {
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
        
        var body: some View {
            Button(action: action) {
                HStack(spacing: dynamicTypeSize.isAccessibilitySize ? 8 : 4) {
                    label
                        .labelStyle(.iconOnly)
                        .font(.title3.weight(.regular))
                        .frame(width: dynamicTypeSize.isAccessibilitySize ? 32 : 24, 
                               height: dynamicTypeSize.isAccessibilitySize ? 32 : 24)
                        .foregroundColor(isSelected ? theme.resolveColors(for: colorScheme).selectedItemColor : theme.resolveColors(for: colorScheme).unselectedItemColor)
                        .if(!reduceMotion) { view in
                            view.matchedGeometryEffect(id: "ICON_\(index)", in: namespace)
                        }
                    
                    if isSelected && showLabel {
                        label
                            .labelStyle(.titleOnly)
                            .font(.body.weight(.medium))
                            .foregroundColor(theme.resolveColors(for: colorScheme).selectedItemColor)
                            .if(!reduceMotion) { view in
                                view.matchedGeometryEffect(id: "LABEL_\(index)", in: namespace)
                            }
                            .transition(reduceMotion ? .opacity : .opacity.combined(with: .move(edge: .leading)))
                    }
                }
                .frame(minWidth: 20, maxWidth: isSelected && configuration.equalItemSizing ? .infinity : nil)
                .padding(.horizontal, dynamicTypeSize.isAccessibilitySize ? 12 : 8)
                .padding(.vertical, dynamicTypeSize.isAccessibilitySize ? 12 : 8)
                .fixedSize(horizontal: configuration.equalItemSizing ? false : true, vertical: false)
                .background {
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
                }
            }
            .buttonStyle(.plain)
            .frame(maxWidth: configuration.equalItemSizing ? .infinity : nil)
            .animation(reduceMotion ? .easeOut(duration: 0.15) : .default, value: isSelected && showLabel)
            .accessibilityElement(children: .combine)
            .accessibilityLabel(accessibilityLabel)
            .accessibilityHint(accessibilityHint)
            .accessibilityValue(isSelected ? "Selected" : "")
            .accessibilityAddTraits(isSelected ? [.isSelected, .isButton] : .isButton)
        }
        
        private var accessibilityLabel: String {
            let mirror = Mirror(reflecting: label)
            let title = mirror.children
                .first { $0.label == "title" }?
                .value as? String ?? "Tab"
            return "\(title) tab"
        }
        
        private var accessibilityHint: String {
            isSelected ? "Currently selected" : "Double tap to switch to this tab"
        }
    }
}

extension Font {
    var dynamic: Font {
        self.leading(.loose)
    }
}

extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
    
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
