// Created By Jared Davidson

import SwiftUIX

// MARK: - Scale Factor Preference Key
extension BubbleBar {
    internal struct ScaleFactorPreferenceKey: PreferenceKey {
        static var defaultValue: CGFloat = 1.0
        
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = min(value, nextValue())
        }
    }
}

private struct ScalableText: ViewModifier {
    let containerWidth: CGFloat
    @Binding var commonScaleFactor: CGFloat
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .fixedSize(horizontal: true, vertical: false)
                .measureSize { size in
                    if size.width > 0 {
                        let availableWidth = min(containerWidth, geometry.size.width)
                        let scaleFactor = min(1.0, max(0.7, availableWidth / size.width))
                        if scaleFactor < commonScaleFactor {
                            commonScaleFactor = scaleFactor
                        }
                    }
                }
                .scaleEffect(commonScaleFactor, anchor: .center)
                .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
                .preference(key: BubbleBar.ScaleFactorPreferenceKey.self, value: commonScaleFactor)
        }
    }
}

private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

private extension View {
    func measureSize(perform action: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometry in
                Color.clear.preference(key: SizePreferenceKey.self, value: geometry.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: action)
    }
}

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
        @Binding var commonScaleFactor: CGFloat
        
        private var itemWidth: CGFloat? {
            configuration.itemWidth
        }
        
        private var itemHeight: CGFloat? {
            configuration.itemHeight
        }
        
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
                .font(.system(configuration.iconTextStyle).weight(.regular))
                .minimumScaleFactor(0.05)
                .foregroundColor(isSelected ? theme.resolveColors(for: colorScheme).selectedItemColor : theme.resolveColors(for: colorScheme).unselectedItemColor)
                .frame(height: 24)
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
                        .font(.system(configuration.labelTextStyle).weight(.medium))
                        .foregroundColor(isSelected ? theme.resolveColors(for: colorScheme).selectedItemColor : theme.resolveColors(for: colorScheme).unselectedItemColor)
                        .lineLimit(1)
                        .if(configuration.labelPosition == .top || configuration.labelPosition == .bottom) { view in
                            view.modifier(ScalableText(
                                containerWidth: dynamicTypeSize.isAccessibilitySize ? 
                                    min(120, itemWidth ?? 120) : 
                                    min(100, itemWidth ?? 100),
                                commonScaleFactor: $commonScaleFactor
                            ))
                        }
                        .if(!reduceMotion) { view in
                            view.matchedGeometryEffect(id: "LABEL_\(index)", in: namespace)
                        }
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
                                    .fixedSize()
                                iconView
                            }
                        case .right:
                            HStack(spacing: 4) {
                                iconView
                                labelView
                                    .fixedSize()
                            }
                        }
                    }
                    .frame(width: itemWidth, height: itemHeight)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(configuration.bubbleBarItemPadding)
                    .fixedSize(horizontal: configuration.equalItemSizing ? false : true, vertical: true)
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
            .onPreferenceChange(BubbleBar.ScaleFactorPreferenceKey.self) { newValue in
                if newValue < commonScaleFactor {
                    commonScaleFactor = newValue
                }
            }
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

