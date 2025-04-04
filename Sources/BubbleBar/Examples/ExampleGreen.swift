// Created By Jared Davidson

import SwiftUI

public struct ExampleGreen: View {
    @State private var selectedTab = 0
    
    public init() {
        self.selectedTab = selectedTab
    }
    
    public var body: some View {
        BubbleBarView(selectedTab: $selectedTab) {
            view
                .edgesIgnoringSafeArea(.all)
                .tabBarItem {
                    Label("Home Is where th", systemImage: "house.fill")
                }
            
            view
                .edgesIgnoringSafeArea(.all)
                .tabBarItem {
                    Label("Focus", systemImage: "timer")
                }
            view
                .edgesIgnoringSafeArea(.all)
                .tabBarItem {
                    Label("Something Ama", systemImage: "mail.stack")
                }
            
            view
                .edgesIgnoringSafeArea(.all)
                .tabBarItem {
                    Label("Eraser", systemImage: "eraser")
                }
            
            
            view
                .edgesIgnoringSafeArea(.all)
                .tabBarItem {
                    Label("Grid", systemImage: "grid")
                }
        }
    }
    
    var view: some View {
        ScrollView {
            LazyVGrid(columns: [.flexible(), .flexible(), .flexible(), .flexible()]) {
                ForEach(0 ..< 300) { i in
                    Text("Hello World")
                        .bold()
                        .font(.body.dynamic)
                        .foregroundColor(.primary)
                        .padding(8)
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color(.systemBackground)))
                        .dynamicTypeSize(...DynamicTypeSize.accessibility5)
                }
            }
            .padding()
            .edgesIgnoringSafeArea(.all)
        }
        .background(Color(.systemBackground))
    }
}

#Preview {
    ExampleGreen()
//        .preferredColorScheme(.dark)
}
