// Created By Jared Davidson

import SwiftUIX

extension BubbleBar {
    /// Internal container view for the tab bar
    internal struct _TabBarContainer<ContainerContent: View>: View {
        @Environment(\.theme) private var theme
        @Environment(\.colorScheme) private var colorScheme
        @Environment(\.bubbleBarConfiguration) private var configuration
        
        /// The content inside the container
        private let content: ContainerContent
        
        /// Creates a new container with the given content
        /// - Parameter content: The content to display inside the container
        internal init(@ViewBuilder content: () -> ContainerContent) {
            self.content = content()
        }
        
        var body: some View {
            content
                .padding(.horizontal, configuration.isGlass ? 10 : 8)
                .padding(.vertical, 6)
                .frame(
                    minWidth: configuration.size?.width,
                    maxWidth: configuration.size == nil ? nil : configuration.size?.width,
                    minHeight: configuration.size?.height,
                    maxHeight: configuration.size?.height ?? 64,
                    alignment: .center
                )
                .background {
                    if configuration.isGlass {
                        glassBackground
                    } else {
                        configuration.shape
                            .fill(theme.resolveColors(for: colorScheme).cardBackground)
                            .overlay {
                                configuration.shape
                                    .stroke(theme.resolveColors(for: colorScheme).barStrokeColor, lineWidth: 0.5)
                            }
                    }
                }
                .clipShape(configuration.shape)
                .padding(configuration.padding)
                .preference(key: TabBarSizePreferenceKey.self, value: calculateTotalHeight())
                .ignoresSafeArea(edges: .bottom)
        }
        
        /// Calculates the size of the container
        private var size: CGSize {
            let width = configuration.size?.width ?? Screen.main.bounds.width - 32
            let height = configuration.size?.height ?? 60
            return CGSize(width: width, height: height)
        }
        
        /// Calculates the total height including padding for content avoidance
        private func calculateTotalHeight() -> CGFloat {
            // Base height of the tab bar
            let baseHeight = configuration.size?.height ?? 60
            
            // Add vertical padding of the tab bar container
            let totalHeight = baseHeight + configuration.padding.top + configuration.padding.bottom
            
            // Only add extra margin if content padding is explicitly requested
            let safeExtraMargin: CGFloat = configuration.contentBottomPadding > 0 ? 10 : 0
            return totalHeight + safeExtraMargin
        }
        
        /// Creates a glass-like background effect
        private var glassBackground: some View {
            GeometryReader { geometry in
                let size = geometry.size
                let tintColor = theme.resolveColors(for: colorScheme).cardBackground
                
                configuration.shape
                    .fill(Material.ultraThinMaterial)
                    .background {
                        configuration.shape
                            .fill()
                            .visualEffect { content, _ in
                                content
                                    .layerEffect(
                                        ShaderLibrary.glass(
                                            size: size,
                                            tint: tintColor,
                                            blur: 12.0
                                        ),
                                        maxSampleOffset: CGSize(width: 12, height: 0)
                                    )
                                    .layerEffect(
                                        ShaderLibrary.glass(
                                            size: size,
                                            tint: tintColor,
                                            blur: 12.0
                                        ),
                                        maxSampleOffset: CGSize(width: 0, height: 12)
                                    )
                            }
                    }
                    .overlay {
                        configuration.shape
                            .fill(tintColor.opacity(0.1))
                            .blendMode(.plusLighter)
                    }
                    .overlay {
                        configuration.shape
                            .stroke(tintColor.opacity(0.3), lineWidth: 1)
                    }
                    .shadow(color: theme.resolveColors(for: colorScheme).barShadowColor.opacity(0.3), radius: 12)
            }
        }
    }
}

/// Preference key for the tab bar height
struct TabBarSizePreferenceKey: PreferenceKey, Sendable {
    static let defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
} 
