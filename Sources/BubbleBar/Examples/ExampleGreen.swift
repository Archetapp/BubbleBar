// Created By Jared Davidson

import SwiftUI

/// Supported languages for the example app
public enum Language {
    /// English language
    case english
    
    /// Japanese language
    case japanese
    
    /// Arabic language
    case arabic
    
    /// Returns tab labels based on the selected language
    var tabLabels: [String] {
        switch self {
        case .english:
            return ["Home", "Focus", "Mail", "Eraser", "Grid"]
        case .japanese:
            return ["ホーム", "フォーカス", "メール", "消しゴム", "グリッド"]
        case .arabic:
            return ["الرئيسية", "تركيز", "البريد", "ممحاة", "شبكة"]
        }
    }
    
    /// Returns greeting text based on the selected language
    var helloWorldText: String {
        switch self {
        case .english: return "Hello World"
        case .japanese: return "こんにちは世界"
        case .arabic: return "مرحبا بالعالم"
        }
    }
}

/// An example view that demonstrates BubbleBar with forest theme and localization support
public struct ExampleGreen: View {
    @State private var selectedTab = 0
    @Environment(\.layoutDirection) private var layoutDirection
    
    /// The language setting for the example
    private var language: Language
    
    /// Creates a new example with the specified language
    /// - Parameter language: The language to use (default: .english)
    public init(language: Language = .english) {
        self.language = language
    }
    
    public var body: some View {
        ZStack(alignment: .bottomTrailing) {
            BubbleBarView(selectedTab: $selectedTab) {
                view
                    .edgesIgnoringSafeArea(.all)
                    .tabBarItem(
                        label: { Label(language.tabLabels[0], systemImage: "house.fill") },
                        accessibilityLabel: language.tabLabels[0]
                    )
                
                view
                    .edgesIgnoringSafeArea(.all)
                    .tabBarItem(
                        label: { Label(language.tabLabels[1], systemImage: "timer") },
                        accessibilityLabel: language.tabLabels[1]
                    )
                
                view
                    .edgesIgnoringSafeArea(.all)
                    .tabBarItem(
                        label: { Label(language.tabLabels[2], systemImage: "mail.stack") },
                        accessibilityLabel: language.tabLabels[2]
                    )
                
                view
                    .edgesIgnoringSafeArea(.all)
                    .tabBarItem(
                        label: { Label(language.tabLabels[3], systemImage: "eraser") },
                        accessibilityLabel: language.tabLabels[3]
                    )
                
                view
                    .edgesIgnoringSafeArea(.all)
                    .tabBarItem(
                        label: { Label(language.tabLabels[4], systemImage: "grid") },
                        accessibilityLabel: language.tabLabels[4]
                    )
            }
            .bubbleBarStyle(.forest)
        }
    }
    
    /// Example content view for each tab
    private var view: some View {
        ScrollView {
            LazyVGrid(columns: [.flexible(), .flexible(), .flexible(), .flexible()]) {
                ForEach(0 ..< 3) { i in
                    Text(language.helloWorldText)
                        .bold()
                        .font(.body.dynamic())
                        .foregroundColor(.primary)
                        .padding(8)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color(.systemBackground)))
                        .dynamicTypeSize(DynamicTypeSize.xSmall...DynamicTypeSize.accessibility5)
                }
            }
            .padding()
            .edgesIgnoringSafeArea(.all)
        }
        .background(Color(.systemBackground))
    }
}

// MARK: - Preview
#Preview {
    ExampleGreen()
        .previewDisplayName("Light Mode")
    
    ExampleGreen()
        .preferredColorScheme(.dark)
        .previewDisplayName("Dark Mode")
    
    ExampleGreen(language: .arabic)
        .environment(\.layoutDirection, .rightToLeft)
        .previewDisplayName("RTL")
        
    ExampleGreen(language: .japanese)
        .previewDisplayName("Japanese")
}
