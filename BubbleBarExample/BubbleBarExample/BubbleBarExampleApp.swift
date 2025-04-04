//
//  BubbleBarExampleApp.swift
//  BubbleBarExample
//
//  Created by Jared Davidson on 4/4/25.
//

import SwiftUI
import BubbleBar

@main
struct BubbleBarExampleApp: App {
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @State private var language: Language = .english
    
    init() {
    }
    
    var body: some Scene {
        WindowGroup {
            let _ = print(language)
            ExampleGreen(language: language)
                .onAppear {
                    setupTestEnvironment()
                }
        }
    }
    
    /// Process launch arguments for UI testing
    private func setupTestEnvironment() {
        let arguments = ProcessInfo.processInfo.arguments
        
        // Instead of directly setting these properties, just check if they are enabled
        // They will be controlled by the UI testing configuration
        
        // Set high contrast if needed for testing
        if arguments.contains("ENABLE_HIGH_CONTRAST") {
            // For testing, we'll just check if this argument exists
            // The actual UI tests will validate high contrast behavior
            print("High contrast testing enabled")
        }
        
        // Force light/dark mode for testing
        if arguments.contains("FORCE_LIGHT_MODE") {
            overrideUserInterfaceStyle(.light)
        } else if arguments.contains("FORCE_DARK_MODE") {
            overrideUserInterfaceStyle(.dark)
        }
        
        // Force RTL for testing
        if arguments.contains("FORCE_RTL") {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
        
        // Languages are now set at the system level via launch arguments
        // We'll use those settings plus our custom flags
        
        // Force Japanese locale for testing
        if arguments.contains("FORCE_JAPANESE") {
            language = .japanese
            print("Japanese language enabled for testing")
        }
        
        // Force Arabic locale for RTL testing 
        // This is separate from the FORCE_RTL which just changes the layout direction
        if arguments.contains("FORCE_ARABIC") {
            language = .arabic
            print("Arabic language enabled for testing")
        }
        
        // Check for UI Test mode
        if arguments.contains("-inUITest") {
            print("Running in UI Test mode")
        }
        
        // Enable VoiceOver for testing - we'll check for this argument instead
        if arguments.contains("ENABLE_VOICE_OVER") {
            // For testing, we'll check if VoiceOver behaviors work correctly
            // using XCUITest's accessibility features
            print("VoiceOver testing enabled")
        }
        
        // Enable reduce motion for testing - we'll check for this argument instead
        if arguments.contains("REDUCE_MOTION") {
            // For testing, we'll check if reduced motion behaviors work correctly
            print("Reduce motion testing enabled")
        }
    }
    
    /// Helper to override the app's appearance style
    private func overrideUserInterfaceStyle(_ style: UIUserInterfaceStyle) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.forEach { window in
                window.overrideUserInterfaceStyle = style
            }
        }
    }
}
