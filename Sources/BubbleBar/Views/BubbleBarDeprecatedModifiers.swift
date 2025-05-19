// Created By Jared Davidson

import SwiftUI

public extension View {
    @available(*, deprecated, message: "View transitions are no longer supported to maintain view state")
    func bubbleBarViewTransition(_ transition: AnyTransition) -> some View {
        self
    }
    
    @available(*, deprecated, message: "View transitions are no longer supported to maintain view state")
    func bubbleBarViewTransitionAnimation(_ animation: Animation) -> some View {
        self
    }
} 