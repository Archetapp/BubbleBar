// Created By Jared Davidson

import SwiftUI

internal struct ExampleComplex: View {
    @State private var selectedTab = 0
    @State var isShowingTabBar: Bool = true
    
    var body: some View {
        BubbleBarView(selectedTab: $selectedTab) {
            Button {
                self.isShowingTabBar.toggle()
            } label: {
                Text(isShowingTabBar ? "Hide Tab Bar" : "Show Tab Bar")

            }
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
        }
        .bubbleBarStyle(
            .init(
                selectedItemColor: Color.black,
                unselectedItemColor: Color.white,
                bubbleBackgroundColor: Color.white,
                bubbleStrokeColor: Color.black,
                barBackgroundColor: Color.black,
                barStrokeColor: Color.clear,
                barShadowColor: Color.black
            )
        )
        .bubbleBarAnimation(.bouncy)
        .bubbleBarStyle(.desert)
        .showBubbleBarLabels(true)
        .bubbleBarSize(CGSize(width: 350, height: 54)) // Default Height 54
        .bubbleBarShape(RoundedRectangle(cornerRadius: 15))
        .bubbleBarItemShape(RoundedRectangle(cornerRadius: 11))
        .bubbleBarItemEqualSizing(true)
        .bubbleBarPadding(.zero)
        .showsBubbleBar(self.isShowingTabBar)
        .bubbleBarGlass()
    }
}

#Preview {
    ExampleComplex()
}
