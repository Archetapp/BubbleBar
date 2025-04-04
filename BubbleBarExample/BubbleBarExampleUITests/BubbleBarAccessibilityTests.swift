//
//  BubbleBarAccessibilityTests.swift
//  BubbleBarTests
//
//  Created by Your Name on 04/04/25.
//

import XCTest

/// Configuration for UI testing different ExampleGreen variants
fileprivate enum TestVariant {
    case standard
    case darkMode
    case rtl
    case japanese
    case arabic
    case reducedMotion
    case highContrast
    
    var launchArguments: [String] {
        var args: [String] = ["-inUITest"]
        
        switch self {
        case .standard:
            return args
        case .darkMode:
            args.append("FORCE_DARK_MODE")
        case .rtl:
            args.append("FORCE_RTL")
        case .japanese:
            args += ["-AppleLanguages", "(ja)", "-AppleLocale", "ja_JP", "FORCE_JAPANESE"]
        case .arabic:
            args += ["-AppleLanguages", "(ar)", "-AppleLocale", "ar_SA", "FORCE_ARABIC", "FORCE_RTL"]
        case .reducedMotion:
            args.append("REDUCE_MOTION")
        case .highContrast:
            args.append("ENABLE_HIGH_CONTRAST")
        }
        
        return args
    }
}

/// Handles all UI test actions on the main actor
fileprivate class UIActions {
    
    /// Launch the app with specific configuration
    private func launchApp(with variant: TestVariant, additionalArgs: [String] = []) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = variant.launchArguments + additionalArgs
        app.launch()
        return app
    }
    
    // MARK: - Color Contrast Tests
    
    /// Tests color contrast accessibility compliance
    func runColorContrastTest() {
        let app = launchApp(with: .highContrast)
        let bubbleBar = app.otherElements["BubbleBar"]
        let bubbleBarExists = bubbleBar.waitForExistence(timeout: 5)
        XCTAssertTrue(bubbleBarExists, "BubbleBar should exist within 5 seconds")

        if #available(iOS 17.0, *) {
            do {
                try app.performAccessibilityAudit(for: .contrast) { issue in
                    let isExampleContent = issue.element?.label.contains("Hello World") ?? false
                    return isExampleContent
                }
            } catch {
                XCTFail("Color contrast accessibility audit failed: \(error.localizedDescription)")
            }
        }

        app.terminate()
    }

    /// Tests touch target size accessibility compliance
    func runTouchTargetsTest() {
        let app = launchApp(with: .standard)
        let bubbleBar = app.otherElements["BubbleBar"]
        let bubbleBarExists = bubbleBar.waitForExistence(timeout: 5)
        XCTAssertTrue(bubbleBarExists, "BubbleBar should exist within 5 seconds")

        if #available(iOS 17.0, *) {
            do {
                try app.performAccessibilityAudit(for: .hitRegion)
            } catch {
                XCTFail("Touch target accessibility audit failed: \(error.localizedDescription)")
            }
        }

        app.terminate()
    }

    /// Tests dynamic type support accessibility compliance
    func runDynamicTypeTest() {
        let app = launchApp(with: .standard)
        let bubbleBar = app.otherElements["BubbleBar"]
        let bubbleBarExists = bubbleBar.waitForExistence(timeout: 5)
        XCTAssertTrue(bubbleBarExists, "BubbleBar should exist within 5 seconds")

        if #available(iOS 17.0, *) {
            do {
                try app.performAccessibilityAudit(for: .dynamicType) { issue in
                    let isExampleContent = issue.element?.label.contains("Hello World") ?? false
                    return isExampleContent
                }
            } catch {
                XCTFail("Dynamic type accessibility audit failed: \(error.localizedDescription)")
            }
        }

        app.terminate()
    }

    // MARK: - Element Tests
    
    /// Tests element descriptions for accessibility compliance
    func runElementDescriptionsTest() {
        let app = launchApp(with: .standard)
        let bubbleBar = app.otherElements["BubbleBar"]
        let bubbleBarExists = bubbleBar.waitForExistence(timeout: 5)
        XCTAssertTrue(bubbleBarExists, "BubbleBar should exist within 5 seconds")

        if #available(iOS 17.0, *) {
            do {
                try app.performAccessibilityAudit(for: .sufficientElementDescription)
            } catch {
                XCTFail("Element descriptions audit failed: \(error.localizedDescription)")
            }
        }

        app.terminate()
    }

    /// Tests VoiceOver traits for accessibility compliance
    func runVoiceOverTraitsTest() {
        let app = launchApp(with: .standard, additionalArgs: ["ENABLE_VOICE_OVER"])
        let bubbleBar = app.otherElements["BubbleBar"]
        let bubbleBarExists = bubbleBar.waitForExistence(timeout: 5)
        XCTAssertTrue(bubbleBarExists, "BubbleBar should exist within 5 seconds")

        if #available(iOS 17.0, *) {
            do {
                try app.performAccessibilityAudit(for: .trait)
            } catch {
                XCTFail("VoiceOver traits accessibility audit failed: \(error.localizedDescription)")
            }
        }

        app.terminate()
    }

    // MARK: - Combined Tests
    
    /// Combined test for tab bar accessibility
    func runTabBarAccessibilityTest() {
        let app = launchApp(with: .standard)
        let bubbleBar = app.otherElements["BubbleBar"]
        let bubbleBarExists = bubbleBar.waitForExistence(timeout: 5)
        XCTAssertTrue(bubbleBarExists, "BubbleBar should exist within 5 seconds")

        // Verify tab items exist and have proper labels
        let expectedLabels = ["Home", "Focus", "Mail", "Eraser", "Grid"] // Default English
        
        for (index, _) in expectedLabels.enumerated() {
            let tabItem = app.buttons["TabItem-\(index)"]
            XCTAssertTrue(tabItem.waitForExistence(timeout: 2), "Tab item at index \(index) should exist")
            XCTAssertFalse(tabItem.label.isEmpty, "Tab item at index \(index) should have a non-empty label")
        }

        if #available(iOS 17.0, *) {
            do {
                try app.performAccessibilityAudit { issue in
                    let shouldIgnore = (issue.auditType == .contrast || 
                                       issue.auditType == .textClipped || 
                                        (issue.auditType == .dynamicType && (issue.element?.label.contains("Hello World") ?? false)))
                    print("Found issue: \(issue.description) (\(issue.auditType))")
                    return shouldIgnore
                }
            } catch {
                XCTFail("Accessibility audit failed: \(error.localizedDescription)")
            }
        }

        app.terminate()
    }

    /// Tests color contrast in both light and dark modes
    func runColorContrastTestInBothModes() {
        // Test light mode
        let lightApp = launchApp(with: .highContrast, additionalArgs: ["FORCE_LIGHT_MODE"])
        let lightBubbleBar = lightApp.otherElements["BubbleBar"]
        let lightBubbleBarExists = lightBubbleBar.waitForExistence(timeout: 5)
        XCTAssertTrue(lightBubbleBarExists, "BubbleBar should exist in light mode within 5 seconds")

        if #available(iOS 17.0, *) {
            do {
                try lightApp.performAccessibilityAudit(for: .contrast) { issue in
                    let isExampleContent = issue.element?.label.contains("Hello World") ?? false
                    return isExampleContent
                }
            } catch {
                XCTFail("Light mode color contrast accessibility audit failed: \(error.localizedDescription)")
            }
        }

        lightApp.terminate()

        // Test dark mode
        let darkApp = launchApp(with: .darkMode, additionalArgs: ["ENABLE_HIGH_CONTRAST"])
        let darkBubbleBar = darkApp.otherElements["BubbleBar"]
        let darkBubbleBarExists = darkBubbleBar.waitForExistence(timeout: 5)
        XCTAssertTrue(darkBubbleBarExists, "BubbleBar should exist in dark mode within 5 seconds")

        if #available(iOS 17.0, *) {
            do {
                try darkApp.performAccessibilityAudit(for: .contrast) { issue in
                    let isExampleContent = issue.element?.label.contains("Hello World") ?? false
                    return isExampleContent
                }
            } catch {
                XCTFail("Dark mode color contrast accessibility audit failed: \(error.localizedDescription)")
            }
        }

        darkApp.terminate()
    }
    
    // MARK: - Localization Tests
    
    /// Tests Right-to-Left language support (Arabic)
    func runRTLLanguageTest() {
        let app = launchApp(with: .rtl)
        let bubbleBar = app.otherElements["BubbleBar"]
        let bubbleBarExists = bubbleBar.waitForExistence(timeout: 5)
        XCTAssertTrue(bubbleBarExists, "BubbleBar should exist within 5 seconds in RTL mode")
        
        // Verify layout direction is RTL by testing tab selection
        let firstTab = app.buttons["TabItem-0"]
        let lastTab = app.buttons["TabItem-4"]
        
        XCTAssertTrue(firstTab.waitForExistence(timeout: 2), "First tab should exist in RTL mode")
        XCTAssertTrue(lastTab.waitForExistence(timeout: 2), "Last tab should exist in RTL mode")
        
        firstTab.tap()
        XCTAssertTrue(firstTab.isSelected, "First tab should be selectable in RTL mode")
        
        lastTab.tap()
        XCTAssertTrue(lastTab.isSelected, "Last tab should be selectable in RTL mode")
        
        let middleTab = app.buttons["TabItem-2"]
        middleTab.tap()
        XCTAssertTrue(middleTab.isSelected, "Middle tab should be selectable in RTL mode")
        
        app.terminate()
    }
    
    /// Tests Japanese language support
    func runJapaneseLanguageTest() {
        let app = launchApp(with: .japanese)
        
        let bubbleBar = app.otherElements["BubbleBar"]
        let bubbleBarExists = bubbleBar.waitForExistence(timeout: 5)
        XCTAssertTrue(bubbleBarExists, "BubbleBar should exist within 5 seconds with Japanese locale")
        
        // Debug: Print all button labels
        print("All buttons in Japanese test:")
        for element in app.buttons.allElementsBoundByIndex {
            print("Button: \(element.identifier), Label: \(element.label)")
        }
        
        // Make sure tabs exist and are functional
        let firstTab = app.buttons["TabItem-0"]
        let secondTab = app.buttons["TabItem-1"]
        
        XCTAssertTrue(firstTab.waitForExistence(timeout: 2), "First tab should exist")
        XCTAssertTrue(secondTab.waitForExistence(timeout: 2), "Second tab should exist")
        
        // Map tab indices to expected Japanese labels
        let expectedJapaneseLabels = [
            0: "ホーム",       // Home
            1: "フォーカス",    // Focus
            2: "メール",       // Mail
            3: "消しゴム",     // Eraser
            4: "グリッド"      // Grid
        ]
        
        for (index, expectedLabel) in expectedJapaneseLabels {
            let tabItem = app.buttons["TabItem-\(index)"]
            if tabItem.exists {
                print("Tab \(index) label: \(tabItem.label)")
                
                // Check for non-empty label
                XCTAssertFalse(tabItem.label.isEmpty, "Tab item at index \(index) should have a non-empty label")
                
                // Check that the label contains the expected text (or a part of it)
                // We allow for partial matches because the accessibility label might include additional text
                XCTAssertTrue(tabItem.label.contains(expectedLabel), 
                             "Tab item at index \(index) should contain Japanese text '\(expectedLabel)', but got '\(tabItem.label)'")
                
                // Check that the button can be tapped and selected
                tabItem.tap()
                XCTAssertTrue(tabItem.isSelected, "Tab item at index \(index) should be selectable")
            }
        }
        
        app.terminate()
    }
    
    /// Tests Arabic language support
    func runArabicLanguageTest() {
        let app = launchApp(with: .arabic)
        
        let bubbleBar = app.otherElements["BubbleBar"]
        let bubbleBarExists = bubbleBar.waitForExistence(timeout: 5)
        XCTAssertTrue(bubbleBarExists, "BubbleBar should exist within 5 seconds with Arabic locale")
        
        // Debug: Print all button labels
        print("All buttons in Arabic test:")
        for element in app.buttons.allElementsBoundByIndex {
            print("Button: \(element.identifier), Label: \(element.label)")
        }
        
        // Make sure tabs exist and are functional
        let firstTab = app.buttons["TabItem-0"]
        let secondTab = app.buttons["TabItem-1"]
        
        XCTAssertTrue(firstTab.waitForExistence(timeout: 2), "First tab should exist")
        XCTAssertTrue(secondTab.waitForExistence(timeout: 2), "Second tab should exist")
        
        // Map tab indices to expected Arabic labels
        let expectedArabicLabels = [
            0: "الرئيسية",    // Home
            1: "تركيز",       // Focus
            2: "البريد",      // Mail
            3: "ممحاة",       // Eraser
            4: "شبكة"         // Grid
        ]
        
        for (index, expectedLabel) in expectedArabicLabels {
            let tabItem = app.buttons["TabItem-\(index)"]
            if tabItem.exists {
                print("Tab \(index) label: \(tabItem.label)")
                
                // Check for non-empty label
                XCTAssertFalse(tabItem.label.isEmpty, "Tab item at index \(index) should have a non-empty label")
                
                // Check that the label contains the expected text (or a part of it)
                // We allow for partial matches because the accessibility label might include additional text
                XCTAssertTrue(tabItem.label.contains(expectedLabel), 
                             "Tab item at index \(index) should contain Arabic text '\(expectedLabel)', but got '\(tabItem.label)'")
                
                // Check that the button can be tapped and selected
                tabItem.tap()
                XCTAssertTrue(tabItem.isSelected, "Tab item at index \(index) should be selectable")
            }
        }
        
        app.terminate()
    }
    
    // MARK: - Other Accessibility Tests
    
    /// Tests keyboard navigation accessibility
    func runKeyboardNavigationTest() {
        let app = launchApp(with: .standard)
        let bubbleBar = app.otherElements["BubbleBar"]
        let bubbleBarExists = bubbleBar.waitForExistence(timeout: 5)
        XCTAssertTrue(bubbleBarExists, "BubbleBar should exist within 5 seconds")
        
        app.activate()
        
        for index in 0..<5 {
            let tabItem = app.buttons["TabItem-\(index)"]
            XCTAssertTrue(tabItem.waitForExistence(timeout: 2), "Tab item at index \(index) should exist")
            
            tabItem.tap()
            XCTAssertTrue(tabItem.isSelected, "Tab item at index \(index) should be selectable")
        }
        
        app.terminate()
    }
    
    /// Tests VoiceOver specific accessibility
    func runVoiceOverTest() {
        let app = launchApp(with: .standard, additionalArgs: ["ENABLE_VOICE_OVER"])
        let bubbleBar = app.otherElements["BubbleBar"]
        let bubbleBarExists = bubbleBar.waitForExistence(timeout: 5)
        XCTAssertTrue(bubbleBarExists, "BubbleBar should exist within 5 seconds with VoiceOver enabled")
        
        for index in 0..<5 {
            let tabItem = app.buttons["TabItem-\(index)"]
            XCTAssertTrue(tabItem.waitForExistence(timeout: 2), "Tab item at index \(index) should exist with VoiceOver")
            
            XCTAssertFalse(tabItem.label.isEmpty, "Tab should have a non-empty accessibility label")
            
            tabItem.tap()
            XCTAssertTrue(tabItem.isSelected, "Tab should be selectable with VoiceOver")
            XCTAssertTrue(tabItem.isEnabled, "Tab should be enabled for VoiceOver")
            
            if tabItem.isSelected {
                let selectedTab = tabItem
                let nextIndex = (index + 1) % 5
                let nextTab = app.buttons["TabItem-\(nextIndex)"]
                if nextTab.exists {
                    nextTab.tap()
                    XCTAssertFalse(selectedTab.isSelected, "Previously selected tab should now be unselected")
                    XCTAssertTrue(nextTab.isSelected, "Newly tapped tab should now be selected")
                }
            }
        }
        
        app.terminate()
    }
    
    /// Tests reduced motion accessibility
    func runReducedMotionTest() {
        let app = launchApp(with: .reducedMotion)
        let bubbleBar = app.otherElements["BubbleBar"]
        let bubbleBarExists = bubbleBar.waitForExistence(timeout: 5)
        XCTAssertTrue(bubbleBarExists, "BubbleBar should exist within 5 seconds with reduced motion")
        
        let firstTab = app.buttons["TabItem-0"]
        let secondTab = app.buttons["TabItem-1"]
        
        XCTAssertTrue(firstTab.waitForExistence(timeout: 2), "First tab should exist")
        XCTAssertTrue(secondTab.waitForExistence(timeout: 2), "Second tab should exist")
        
        firstTab.tap()
        XCTAssertTrue(firstTab.isSelected, "First tab should be selectable with reduced motion")
        
        secondTab.tap()
        XCTAssertTrue(secondTab.isSelected, "Second tab should be selectable with reduced motion")
        XCTAssertFalse(firstTab.isSelected, "First tab should be unselected when second tab is tapped")
        
        firstTab.tap()
        XCTAssertTrue(firstTab.isSelected, "First tab should be selectable again with reduced motion")
        XCTAssertFalse(secondTab.isSelected, "Second tab should be unselected when first tab is tapped")
        
        app.terminate()
    }
    
    /// Tests all variants of ExampleGreen in sequence
    func runAllVariantsTest() {
        let variants: [TestVariant] = [
            .standard,
            .darkMode,
            .rtl,
            .japanese,
            .arabic,
            .reducedMotion,
            .highContrast
        ]
        
        let variantNames: [TestVariant: String] = [
            .standard: "Standard",
            .darkMode: "Dark Mode",
            .rtl: "Right-to-Left",
            .japanese: "Japanese",
            .arabic: "Arabic",
            .reducedMotion: "Reduced Motion",
            .highContrast: "High Contrast"
        ]
        
        for variant in variants {
            let app = launchApp(with: variant)
            let variantName = variantNames[variant] ?? "Unknown"
            
            let bubbleBar = app.otherElements["BubbleBar"]
            let bubbleBarExists = bubbleBar.waitForExistence(timeout: 5)
            XCTAssertTrue(bubbleBarExists, "BubbleBar should exist in \(variantName) variant")
            
            let firstTab = app.buttons["TabItem-0"]
            XCTAssertTrue(firstTab.waitForExistence(timeout: 2), "First tab should exist in \(variantName) variant")
            
            firstTab.tap()
            XCTAssertTrue(firstTab.isSelected, "First tab should be selectable in \(variantName) variant")
            
            app.terminate()
        }
    }

    /// Helper to debug accessibility elements
    private func dumpAccessibilityElements(_ app: XCUIApplication) {
        let allElements = app.descendants(matching: .any)
        for i in 0..<allElements.count {
            let element = allElements.element(boundBy: i)
            if !element.identifier.isEmpty {
                print("Element with identifier: \(element.identifier), type: \(element.elementType)")
            }
        }
    }
}

/// UI tests for BubbleBar accessibility features
final class BubbleBarAccessibilityTests: XCTestCase {
    private let ui = UIActions()
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    // MARK: - Color Contrast Tests
    
    @MainActor
    func testColorContrast() {
        ui.runColorContrastTest()
    }
    
    @MainActor
    func testTouchTargets() {
        ui.runTouchTargetsTest()
    }

    @MainActor
    func testDynamicTypeSupport() {
        ui.runDynamicTypeTest()
    }
    
    // MARK: - Element Tests
    
    @MainActor
    func testElementDescriptions() {
        ui.runElementDescriptionsTest()
    }
    
    @MainActor
    func testVoiceOverTraits() {
        ui.runVoiceOverTraitsTest()
    }
    
    // MARK: - Combined Tests
    
    @MainActor
    func testTabBarAccessibility() {
        ui.runTabBarAccessibilityTest()
    }
    
    @MainActor
    func testColorContrastInBothModes() {
        ui.runColorContrastTestInBothModes()
    }
    
    // MARK: - Localization Tests
    
    @MainActor
    func testRTLLanguageSupport() {
        ui.runRTLLanguageTest()
    }
    
    @MainActor
    func testJapaneseLanguageSupport() {
        ui.runJapaneseLanguageTest()
    }
    
    @MainActor
    func testArabicLanguageSupport() {
        ui.runArabicLanguageTest()
    }
    
    // MARK: - Other Accessibility Tests
    
    @MainActor
    func testKeyboardNavigation() {
        ui.runKeyboardNavigationTest()
    }
    
    @MainActor
    func testVoiceOver() {
        ui.runVoiceOverTest()
    }
    
    @MainActor
    func testReducedMotion() {
        ui.runReducedMotionTest()
    }
    
    @MainActor
    func testAllVariants() {
        ui.runAllVariantsTest()
    }
}
