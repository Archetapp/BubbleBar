// Created By Jared Davidson

import SwiftUI

public struct ExampleOrange: View {
    @State private var selectedTab = 0
    
    public init(selectedTab: Int = 0) {
        self.selectedTab = selectedTab
    }
    
    public var body: some View {
        BubbleBarView(selectedTab: $selectedTab) {
            Text("Home View")
                .tabBarItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            Text("Focus View")
                .tabBarItem {
                    Label("Focus", systemImage: "timer")
                }
            
            Text("Spatial View")
                .tabBarItem {
                    Label("Spatial", systemImage: "square.grid.2x2")
                }
            Text("Focus View")
                .tabBarItem {
                    Label("Focus", systemImage: "timer")
                }

        }
        .bubbleBarStyle(.forest)
//        .bubbleBarItemPosition(.bottom)
        .bubbleBarSize(.init(width: 200, height: 70))
//        .bubbleBarLabelPosition(.bottom)
        .bubbleBarLabelsVisible(false)
//        .bubbleBarItemSpacing(12)
//        .showBubbleBarLabels(true)
//        .bubbleBarShape(RoundedRectangle(cornerRadius: 10))
//        .bubbleBarContentPadding(5)
//        .bubbleBarItemEqualSizing(true)
//        .bubbleBarAdaptiveItemsWidth(true)
    }
}

#Preview {
    ExampleOrange()
}
