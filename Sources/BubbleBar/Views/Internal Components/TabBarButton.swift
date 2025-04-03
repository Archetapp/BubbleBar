// Created By Jared Davidson

import SwiftUIX

extension BubbleBar {
    internal struct _TabBarButton: View {
        @Environment(\.theme) private var theme
        @Environment(\.bubbleBarConfiguration) private var configuration
        let label: AnyView
        let isSelected: Bool
        let index: Int
        var namespace: Namespace.ID
        let showLabel: Bool
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                HStack(spacing: 4) {
                    label
                        .labelStyle(.iconOnly)
                        .font(.system(size: 20, weight: .regular).dynamic)
                        .frame(width: 24, height: 24)
                        .foregroundColor(isSelected ? theme.colors.primary : theme.colors.textSecondary)
                        .matchedGeometryEffect(id: "ICON_\(index)", in: namespace)
                    
                    if isSelected && showLabel {
                        label
                            .labelStyle(.titleOnly)
                            .font(.system(size: 14, weight: .medium).dynamic)
                            .foregroundColor(theme.colors.primary)
                            .matchedGeometryEffect(id: "LABEL_\(index)", in: namespace)
                    }
                }
                .frame(minWidth: 20, maxWidth: isSelected && configuration.equalItemSizing ? .infinity : nil)
                .padding(.horizontal, 8)
                .padding(.vertical, 8)
                .fixedSize(horizontal: configuration.equalItemSizing ? false : true, vertical: false)
                .background {
                    if isSelected {
                        ZStack {
                            configuration.itemShape
                                .fill(theme.colors.primary.opacity(0.15))
                            configuration.itemShape
                                .stroke(theme.colors.primary.opacity(0.4), lineWidth: 0.5)
                        }
                        .matchedGeometryEffect(id: "BUBBLE", in: namespace)
                    }
                }
            }
            .buttonStyle(.plain)
            .frame(maxWidth: configuration.equalItemSizing ? .infinity : nil)
            .accessibilityElement(children: .combine)
            .accessibilityAddTraits(isSelected ? .isSelected : [])
            .accessibilityHint("Double tap to switch tab")
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
}
