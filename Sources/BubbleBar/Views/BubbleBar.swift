//// Created By Jared Davidson
//
import SwiftUIX

///// A SwiftUI package that provides a customizable, animated tab bar with a bubble effect.
public enum BubbleBar {}

public struct ScaleFactorPreferenceKey: PreferenceKey {
    public static var defaultValue: CGFloat = 1.0
    
    public static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = min(value, nextValue())
    }
}
