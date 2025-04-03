// Created By Jared Davidson

import SwiftUI

extension BubbleBar {
    internal struct _TabBarContainer<ContainerContent: View>: View {
        @Environment(\.theme) private var theme
        @Environment(\.bubbleBarConfiguration) private var configuration
        let content: ContainerContent
        
        init(@ViewBuilder content: () -> ContainerContent) {
            self.content = content()
        }
        
        var body: some View {
            content
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .frame(
                    minWidth: configuration.size?.width,
                    maxWidth: configuration.size == nil ? nil : configuration.size?.width,
                    minHeight: configuration.size?.height,
                    maxHeight: configuration.size == nil ? nil : configuration.size?.height
                )
                .background {
                    if configuration.isGlass {
                        glassBackground
                    } else {
                        configuration.shape
                            .fill(theme.colors.cardBackground)
                            .overlay {
                                configuration.shape
                                    .stroke(theme.colors.barStrokeColor, lineWidth: 0.5)
                            }
                    }
                }
                .clipShape(configuration.shape)
                .padding(configuration.padding)
        }
        
        private var size: CGSize {
            let width = configuration.size?.width ?? UIScreen.main.bounds.width - 32
            let height = configuration.size?.height ?? 60
            return CGSize(width: width, height: height)
        }
        
        private var glassBackground: some View {
            GeometryReader { geometry in
                let size = geometry.size
                let tintColor = theme.colors.cardBackground
                
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
                    .shadow(color: theme.colors.barShadowColor.opacity(0.3), radius: 12)
            }
        }
    }
} 
