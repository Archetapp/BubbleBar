#include <metal_stdlib>
using namespace metal;

#include <SwiftUI/SwiftUI_Metal.h>

// Helper function for Gaussian distribution
inline half gaussian(half distance, half sigma) {
    const half gaussianExponent = -(distance * distance) / (2.0h * sigma * sigma);
    return (1.0h / (2.0h * M_PI_H * sigma * sigma)) * exp(gaussianExponent);
}

// Single-axis Gaussian blur
half4 gaussianBlur1D(float2 position, SwiftUI::Layer layer, half radius, bool isVertical) {
    const half maxSamples = 5.0h; // Balance between quality and performance
    const half interval = max(1.0h, radius / maxSamples);
    
    half4 weightedColorSum = layer.sample(position);
    half totalWeight = 1.0h;
    
    if (interval <= radius) {
        for (half distance = interval; distance <= radius; distance += interval) {
            const half2 offset = isVertical ? half2(0, distance) : half2(distance, 0);
            const half weight = gaussian(distance, radius / 2.0h);
            totalWeight += weight * 2.0h;
            
            weightedColorSum += layer.sample(float2(half2(position) + offset)) * weight;
            weightedColorSum += layer.sample(float2(half2(position) - offset)) * weight;
        }
    }
    
    return weightedColorSum / totalWeight;
}

[[ stitchable ]] half4 glassEffect(float2 position,
                                  half4 color,
                                  float2 size,
                                  half4 tint,
                                  float blur,
                                  float isVertical,
                                  SwiftUI::Layer layer) {
    // Sample the background
    half4 background = layer.sample(position);
    
    // Calculate UV coordinates (0 to 1)
    const float2 uv = float2(position.x / size.x, position.y / size.y);
    
    // Calculate distance from center (0 at center, 1 at edges)
    const float2 center = float2(0.5, 0.5);
    const float dist = length(uv - center) * 2.0;
    
    // Create edge-weighted blur
    const half edgeBlur = half(blur) * half(dist) * 1.5h;
    
    // Apply single-axis blur based on isVertical parameter
    half4 blurred = gaussianBlur1D(position, layer, edgeBlur, bool(isVertical));
    
    // Mix background with blur based on distance from center
    half4 result = mix(background, blurred, half(smoothstep(0.3, 1.0, dist)));
    
    // Create a stronger tint effect at the edges
    half4 tintColor = half4(tint.rgb * 1.2h, tint.a);
    const half edgeIntensity = half(smoothstep(0.2, 1.0, dist));
    result = mix(result, tintColor, edgeIntensity * 0.4h);
    
    // Add a brighter highlight at edges
    const half highlight = pow(1.0h - half(dist), 3.0h) * 0.3h;
    result += half4(highlight, highlight, highlight, 0.0h);
    
    // Add a subtle inner glow using the tint color
    const half innerGlow = pow(1.0h - half(dist), 2.0h) * 0.15h;
    result += half4(tint.rgb * innerGlow, 0.0h);
    
    // Ensure proper transparency for the glass effect
    result.a = mix(0.6h, 0.85h, half(dist));
    
    return result;
} 