// Created By Jared Davidson

import SwiftUIX

/// A customizable tab bar view that provides a modern, animated interface for navigation.
/// The tab bar features a bubble effect that moves between selected items and supports both icon and label display.
///
/// Example usage:
/// ```swift
/// BubbleBarView(selectedTab: $selectedTab) {
///     Text("Home View")
///         .tabBarItem {
///             Label("Home", systemImage: "house.fill")
///         }
///     Text("Settings View")
///         .tabBarItem {
///             Label("Settings", systemImage: "gear")
///         }
/// }
/// .bubbleBarStyle(.dark)
/// ```
///
/// The view automatically adds bottom padding to content to prevent it from being obscured by the tab bar.
/// You can customize this padding using the `bubbleBarContentPadding(_:)` modifier:
///
/// ```swift
/// BubbleBarView(selectedTab: $selectedTab) {
///     // Your tab views here
/// }
/// .bubbleBarContentPadding(80) // Custom padding
/// ```
public struct BubbleBarView<Content: View>: View {
    @Environment(\.bubbleBarConfiguration) private var configuration
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    @Environment(\.colorSchemeContrast) private var colorSchemeContrast
    @Environment(\.colorScheme) private var colorScheme
    @Namespace private var namespace
    @Binding var selectedTab: Int
    @State private var commonScaleFactor: CGFloat = 1.0
    @State private var dragOffset: CGFloat = 0
    @State private var isDragging: Bool = false
    @State private var initialTab: Int = 0
    private let content: Content
    @State private var tabBarHeight: CGFloat = 0
    
    /// Creates a new bubble bar view.
    /// - Parameters:
    ///   - selectedTab: A binding to the currently selected tab index
    ///   - content: A view builder that creates the content for each tab
    public init(selectedTab: Binding<Int>, @ViewBuilder content: () -> Content) {
        self._selectedTab = selectedTab
        self.content = content()
    }
    
    public var body: some View {
        let forceHighContrast = ProcessInfo.processInfo.arguments.contains("ENABLE_HIGH_CONTRAST")
        
        let _ = configuration.updateForAccessibility(
            dynamicTypeSize: dynamicTypeSize,
            reduceMotion: reduceMotion,
            reduceTransparency: reduceTransparency,
            increasedContrast: colorSchemeContrast == .increased || forceHighContrast
        )
        
        let contentPadding = configuration.contentBottomPadding
        
        return ZStack(alignment: .bottom) {
            contentView(contentPadding: contentPadding)
            tabBarView()
        }
        .ignoresSafeArea(.keyboard)
        .onPreferenceChange(TabBarSizePreferenceKey.self) { height in
            tabBarHeight = height
        }
    }
    
    @ViewBuilder
    private func contentView(contentPadding: CGFloat) -> some View {
        _VariadicViewAdapter(content) { content in
            GeometryReader { geometry in
                let width = geometry.size.width
                let threshold: CGFloat = width * 0.3 // 30% of screen width threshold
                
                HStack(spacing: 0) {
                    ForEach(content.children.indices, id: \.self) { index in
                        content.children[index]
                            .frame(width: width)
                            .if(contentPadding > 0) { view in
                                view.padding(.bottom, contentPadding)
                            }
                    }
                }
                .offset(x: -CGFloat(initialTab) * width + dragOffset)
                .animation(reduceMotion ? .default : configuration.animation, value: selectedTab)
                .onChange(of: self.selectedTab) { _, newValue in
                    if initialTab != newValue,
                       !isDragging {
                        self.initialTab = newValue
                    }
                }
                .if(configuration.canSwipeBetweenViews) { view in
                    view.gesture(
                        DragGesture(minimumDistance: 20)
                            .onChanged { gesture in
                                // Only handle drags that start near the edges
                                let edgeThreshold: CGFloat = 50 // pixels from edge
                                let startLocation = gesture.startLocation.x
                                let isNearEdge = startLocation < edgeThreshold || startLocation > width - edgeThreshold
                                
                                if !isNearEdge {
                                    return
                                }
                                
                                if !isDragging {
                                    isDragging = true
                                    initialTab = selectedTab
                                }
                                
                                // Add drag resistance at edges
                                let resistance: CGFloat = 0.3 // 30% resistance
                                var newDragOffset = gesture.translation.width
                                
                                // Apply resistance when at first or last tab
                                if initialTab == 0 && newDragOffset > 0 {
                                    newDragOffset = newDragOffset * resistance
                                } else if initialTab == content.children.count - 1 && newDragOffset < 0 {
                                    newDragOffset = newDragOffset * resistance
                                }
                                
                                dragOffset = newDragOffset
                                
                                // Update selected tab if threshold is reached
                                let newIndex: Int
                                if gesture.translation.width > threshold {
                                    newIndex = max(0, initialTab - 1)
                                } else if gesture.translation.width < -threshold {
                                    newIndex = min(content.children.count - 1, initialTab + 1)
                                } else {
                                    return
                                }
                                
                                if newIndex != selectedTab {
                                    withAnimation(reduceMotion ? .default : configuration.animation) {
                                        selectedTab = newIndex
                                        dragOffset = 0
                                    }
                                }
                            }
                            .onEnded { gesture in
                                // Only handle drags that started near the edges
                                let edgeThreshold: CGFloat = 50
                                let startLocation = gesture.startLocation.x
                                let isNearEdge = startLocation < edgeThreshold || startLocation > width - edgeThreshold
                                
                                if !isNearEdge {
                                    return
                                }
                                
                                isDragging = false
                                let horizontalAmount = gesture.translation.width
                                let verticalAmount = gesture.translation.height
                                
                                if selectedTab != initialTab {
                                    withAnimation(reduceMotion ? .default : configuration.animation) {
                                        self.initialTab = self.selectedTab
                                    }
                                }
                                
                                // Only handle horizontal swipes that are more horizontal than vertical
                                if abs(horizontalAmount) > abs(verticalAmount) {
                                    let newIndex: Int
                                    if horizontalAmount > threshold {
                                        // Swipe right - go to previous tab
                                        newIndex = max(0, initialTab - 1)
                                    } else if horizontalAmount < -threshold {
                                        // Swipe left - go to next tab
                                        newIndex = min(content.children.count - 1, initialTab + 1)
                                    } else {
                                        // Reset to current tab
                                        withAnimation(reduceMotion ? .default : configuration.animation) {
                                            dragOffset = 0
                                        }
                                        return
                                    }
                                    
                                    if newIndex != selectedTab {
                                        withAnimation(reduceMotion ? .default : configuration.animation) {
                                            selectedTab = newIndex
                                            dragOffset = 0
                                        }
                                    } else {
                                        withAnimation(reduceMotion ? .default : configuration.animation) {
                                            dragOffset = 0
                                        }
                                    }
                                } else {
                                    withAnimation(reduceMotion ? .default : configuration.animation) {
                                        dragOffset = 0
                                    }
                                }
                            }
                    )
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipped()
    }
    
    @ViewBuilder
    private func tabBarView() -> some View {
        BubbleBar._TabBarContainer {
            _VariadicViewAdapter(content) { content in
                let spacing = dynamicTypeSize.isAccessibilitySize ?
                    configuration.bubbleBarItemSpacing.isAccessibilitySize :
                    configuration.bubbleBarItemSpacing.regular
                
                HStack(spacing: spacing) {
                    ForEach(content.children.indices, id: \.self) { index in
                        if let itemInfo = content.children[index].traits.tabBarLabel {
                            tabBarButton(for: index, itemInfo: itemInfo)
                            
                            if index != content.children.indices.last && !configuration.equalItemSizing {
                                Spacer(minLength: dynamicTypeSize.isAccessibilitySize ? 1 : 0)
                            }
                        }
                    }
                }
                .frame(maxHeight: max(
                    (configuration.size?.height ?? 80) + (configuration.padding.top + configuration.padding.bottom),
                    (configuration.itemHeight ?? 80) + (configuration.padding.top + configuration.padding.bottom)
                ))
            }
        }
        .frame(width: Screen.width)
        .animation(reduceMotion ? .default : configuration.animation, value: selectedTab)
        .environment(\.theme, configuration.style.theme)
        .compositingGroup()
        .shadow(
            color: configuration.style.theme.colors(for: colorScheme).barShadowColor,
            radius: configuration.shadowRadius,
            x: configuration.shadowOffset.x,
            y: configuration.shadowOffset.y
        )
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Navigation")
        .accessibilityHint("Tab bar for switching between different views")
        .accessibilityIdentifier("BubbleBar")
        .accessibilityAddTraits(.isTabBar)
        .offset(y: configuration.isVisible ? 0 : 100)
        .animation(reduceMotion ? .default : configuration.animation, value: configuration.isVisible)
    }
    
    @ViewBuilder
    private func tabBarButton(for index: Int, itemInfo: TabBarItemInfo) -> some View {
        BubbleBar._TabBarButton(
            label: itemInfo.label,
            isSelected: selectedTab == index,
            index: index,
            namespace: namespace,
            showLabel: configuration.showLabels,
            action: {
                withAnimation(reduceMotion ? .default : configuration.animation) {
                    selectedTab = index
#if canImport(UIKit)
                    UIAccessibility.post(
                        notification: .screenChanged,
                        argument: "Switched to \(itemInfo.accessibilityLabel)"
                    )
#endif
                }
            },
            commonScaleFactor: $commonScaleFactor
        )
        .accessibilityLabel(itemInfo.accessibilityLabel)
        .accessibilityHint(itemInfo.accessibilityHint)
        .onPreferenceChange(ScaleFactorPreferenceKey.self) { newValue in
            withAnimation {
                commonScaleFactor = min(commonScaleFactor, newValue)
            }
        }
    }
} 
