// Created By Jared Davidson

import SwiftUIX

#if canImport(UIKit)
internal struct ExampleAccessibility: View {
    @State private var selectedTab = 0
    @State private var isHighContrastEnabled = false
    @State private var isReducedMotionEnabled = false
    @State private var isReducedTransparencyEnabled = false
    @State private var isVoiceOverEnabled = UIAccessibility.isVoiceOverRunning
    @State private var selectedFontSize: DynamicTypeSize = .large
    
    // Available font sizes for testing
    private let availableFontSizes: [DynamicTypeSize] = [
        .xSmall, .small, .medium, .large, .xLarge, .xxLarge, .xxxLarge,
        .accessibility1, .accessibility2, .accessibility3, .accessibility4, .accessibility5
    ]
    
    var body: some View {
        BubbleBarView(selectedTab: $selectedTab) {
            // Home View with Accessibility Controls
            NavigationView {
                List {
                    Section(header: Text("Accessibility Controls")) {
                        Toggle("High Contrast Mode", isOn: $isHighContrastEnabled)
                            .accessibilityLabel("Toggle high contrast mode")
                        
                        Toggle("Reduce Motion", isOn: $isReducedMotionEnabled) // This works outside of the SwiftUI Preview.
                            .accessibilityLabel("Toggle reduced motion")
                        
                        Toggle("Reduce Transparency", isOn: $isReducedTransparencyEnabled)
                            .accessibilityLabel("Toggle reduced transparency")
                        
                        Picker("Font Size", selection: $selectedFontSize) {
                            ForEach(availableFontSizes, id: \.self) { size in
                                Text(fontSizeName(for: size))
                                    .tag(size)
                            }
                        }
                        .accessibilityLabel("Select font size")
                        
                        // VoiceOver status (read-only as it's system controlled)
                        HStack {
                            Text("VoiceOver Status")
                            Spacer()
                            Text(isVoiceOverEnabled ? "Enabled" : "Disabled")
                                .foregroundColor(.secondary)
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("VoiceOver is \(isVoiceOverEnabled ? "enabled" : "disabled")")
                    }
                    
                    Section(header: Text("Feature Preview")) {
                        Text("Sample Text")
                            .font(.body)
                            .foregroundColor(isHighContrastEnabled ? .primary : .secondary)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.blue.opacity(isReducedTransparencyEnabled ? 1.0 : 0.3))
                            .frame(height: 50)
                            .accessibilityLabel("Preview rectangle")
                    }
                }
                .navigationTitle("Accessibility Demo")
            }
            .tabBarItem {
                Label("Controls", systemImage: "slider.horizontal.3")
                    .accessibilityLabel("Accessibility controls tab")
                    .accessibilityHint("Adjust accessibility settings")
            }
            
            NavigationView {
                List {
                    Text("Visual Preview Content")
                        .font(.body)
                    
                    ForEach(0..<5) { index in
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(isHighContrastEnabled ? .primary : .yellow)
                            Text("Item \(index + 1)")
                                .foregroundColor(isHighContrastEnabled ? .primary : .secondary)
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("Preview item \(index + 1)")
                    }
                }
                .navigationTitle("Preview")
            }
            .tabBarItem {
                Label("Preview", systemImage: "eye")
                    .accessibilityLabel("Visual preview tab")
                    .accessibilityHint("View accessibility features in action")
            }
            
            NavigationView {
                List {
                    Section(header: Text("Current Settings")) {
                        InfoRow(title: "High Contrast", value: isHighContrastEnabled)
                        InfoRow(title: "Reduced Motion", value: isReducedMotionEnabled)
                        InfoRow(title: "Reduced Transparency", value: isReducedTransparencyEnabled)
                        InfoRow(title: "Font Size", value: fontSizeName(for: selectedFontSize))
                        InfoRow(title: "VoiceOver", value: isVoiceOverEnabled)
                    }
                    
                    Section(header: Text("About")) {
                        Text("This example demonstrates various accessibility features available in BubbleBar. Use the controls tab to experiment with different settings.")
                            .font(.body)
                            .accessibilityLabel("About section explanation")
                    }
                }
                .navigationTitle("Information")
            }
            .tabBarItem {
                Label("Info", systemImage: "info.circle")
                    .accessibilityLabel("Information tab")
                    .accessibilityHint("View current accessibility settings")
            }
        }
        .bubbleBarStyle(isHighContrastEnabled ? .highContrast : .forest)
        .bubbleBarAnimation(isReducedMotionEnabled ? .default : .spring(response: 0.3, dampingFraction: 0.7))
        .bubbleBarSize(CGSize(
            width: Screen.main.bounds.width - 32,
            height: max(54, selectedFontSize.isAccessibilitySize ? 64 : 54)
        ))
        .bubbleBarPadding(EdgeInsets(
            top: 0,
            leading: selectedFontSize.isAccessibilitySize ? 24 : 16,
            bottom: 0,
            trailing: selectedFontSize.isAccessibilitySize ? 24 : 16
        ))
        .showBubbleBarLabels(true)
        .bubbleBarGlass(!isReducedTransparencyEnabled)
        .environment(\.dynamicTypeSize, selectedFontSize)
        .task {
            let notificationCenter = NotificationCenter.default
            let voiceOverNotification = UIAccessibility.voiceOverStatusDidChangeNotification
            
            for await _ in notificationCenter.notifications(named: voiceOverNotification).map({ _ in }) {
                isVoiceOverEnabled = UIAccessibility.isVoiceOverRunning
            }
        }
    }
    
    private var animationOffset: CGFloat {
        isReducedMotionEnabled ? 0 : 100
    }
    
    private func fontSizeName(for size: DynamicTypeSize) -> String {
        switch size {
        case .xSmall: return "XS"
        case .small: return "S"
        case .medium: return "M"
        case .large: return "L"
        case .xLarge: return "XL"
        case .xxLarge: return "XXL"
        case .xxxLarge: return "XXXL"
        case .accessibility1: return "A1"
        case .accessibility2: return "A2"
        case .accessibility3: return "A3"
        case .accessibility4: return "A4"
        case .accessibility5: return "A5"
        @unknown default: return "Unknown"
        }
    }
}

/// Helper view for displaying information rows
private struct InfoRow: View {
    let title: String
    let value: Any
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text("\(String(describing: value))")
                .foregroundColor(.secondary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title) is \(String(describing: value))")
    }
}

#Preview {
    ExampleAccessibility()
}

#endif
