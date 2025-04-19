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
        .bubbleBarItemPosition(.bottom)
        .bubbleBarInnerPadding(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
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
