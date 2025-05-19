//// Created By Jared Davidson
//
import SwiftUIX

///// A SwiftUI package that provides a customizable, animated tab bar with a bubble effect.
public enum BubbleBar {
    /// Defines how the tab bar handles swipe gestures between views
    public enum SwipeBehavior {
        /// Swipe gestures are disabled
        case disabled
        /// Swipe gestures only work when starting from the edges of the screen
        case edges
        /// Swipe gestures work anywhere on the screen
        case full
    }
}

public struct ScaleFactorPreferenceKey: PreferenceKey {
    public static var defaultValue: CGFloat = 1.0
    
    public static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = min(value, nextValue())
    }
}
