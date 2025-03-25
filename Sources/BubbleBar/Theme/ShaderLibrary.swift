import SwiftUI

extension BubbleBar {
    enum ShaderLibrary {
        static let glassEffect = Shader(function: .init(library: .bundle(.module), name: "glassEffect"),
                                      arguments: [
                                          .float2(CGPoint.zero),    // position
                                          .color(.clear),           // color (background)
                                          .float2(CGSize.zero),     // size
                                          .color(.clear),           // tint
                                          .float(8.0),              // blur radius
                                          .float(0.0)               // isVertical
                                      ])
        
        static func glass(size: CGSize, tint: Color, blur: Float = 8.0) -> Shader {
            Shader(function: glassEffect.function, arguments: [
                .float2(CGPoint(x: size.width/2, y: size.height/2)),
                .color(.clear),
                .float2(size),
                .color(tint),
                .float(blur),
                .float(0.0)
            ])
        }
    }
}
