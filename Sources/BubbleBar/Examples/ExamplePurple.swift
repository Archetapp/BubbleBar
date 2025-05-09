// Created By Jared Davidson

import SwiftUI

#if os(iOS)
struct ExamplePurple: View {
    @State private var selectedTab = 0
    
    var body: some View {
        BubbleBarView(selectedTab: $selectedTab) {
            Text("Home View")
                .tabBarItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            Text("Focus View")
                .tabBarItem {
                    Label("Focus", systemImage: "timer")
                        .labelStyle(.iconOnly) // This produces a bug currently where we have 2 icons
                }
            
            Text("Spatial View")
                .tabBarItem {
                    Label("Spatial", systemImage: "square.grid.2x2")
                }
        }
        .bubbleBarStyle(.nightOwl)
    }
}

#Preview {
    ExamplePurple()
}
#endif
