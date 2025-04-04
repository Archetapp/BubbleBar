//
//  BubbleBarAccessibilityTests.swift
//  BubbleBarTests
//
//  Created by Your Name on 04/04/25.
//

import XCTest

/// This class runs all UI test code on the main actor,
//  which eliminates "call to main actor-isolated method in nonisolated context" errors.
@MainActor
fileprivate class UIActions {

    /// Example: test color contrast
    func runColorContrastTest() {
        let app = XCUIApplication()
        app.launch()

        let tabBar = app.tabBars.firstMatch
        let tabBarExists = tabBar.waitForExistence(timeout: 5)
        XCTAssertTrue(tabBarExists, "Tab bar should exist within 5 seconds")

        if #available(iOS 17.0, *) {
            do {
                // synchronous variant of performAccessibilityAudit
                try app.performAccessibilityAudit(for: .contrast)
            } catch {
                XCTFail("Color contrast accessibility audit failed: \(error.localizedDescription)")
            }
        }

        app.terminate()
    }

    /// Example: test touch targets
    func runTouchTargetsTest() {
        let app = XCUIApplication()
        app.launch()

        let tabBar = app.tabBars.firstMatch
        let tabBarExists = tabBar.waitForExistence(timeout: 5)
        XCTAssertTrue(tabBarExists, "Tab bar should exist within 5 seconds")

        if #available(iOS 17.0, *) {
            do {
                try app.performAccessibilityAudit(for: .hitRegion)
            } catch {
                XCTFail("Touch target accessibility audit failed: \(error.localizedDescription)")
            }
        }

        app.terminate()
    }

    /// Example: test dynamic type support
    func runDynamicTypeTest() {
        let app = XCUIApplication()
        app.launch()

        let tabBar = app.tabBars.firstMatch
        let tabBarExists = tabBar.waitForExistence(timeout: 5)
        XCTAssertTrue(tabBarExists, "Tab bar should exist within 5 seconds")

        if #available(iOS 17.0, *) {
            do {
                try app.performAccessibilityAudit(for: .dynamicType)
            } catch {
                XCTFail("Dynamic type accessibility audit failed: \(error.localizedDescription)")
            }
        }

        app.terminate()
    }

    /// Example: test element descriptions
    func runElementDescriptionsTest() {
        let app = XCUIApplication()
        app.launch()

        let tabBar = app.tabBars.firstMatch
        let tabBarExists = tabBar.waitForExistence(timeout: 5)
        XCTAssertTrue(tabBarExists, "Tab bar should exist within 5 seconds")

        if #available(iOS 17.0, *) {
            do {
                try app.performAccessibilityAudit(for: .sufficientElementDescription)
            } catch {
                XCTFail("Element descriptions audit failed: \(error.localizedDescription)")
            }
        }

        app.terminate()
    }

    /// Example: test VoiceOver traits
    func runVoiceOverTraitsTest() {
        let app = XCUIApplication()
        app.launch()

        let tabBar = app.tabBars.firstMatch
        let tabBarExists = tabBar.waitForExistence(timeout: 5)
        XCTAssertTrue(tabBarExists, "Tab bar should exist within 5 seconds")

        if #available(iOS 17.0, *) {
            do {
                try app.performAccessibilityAudit(for: .trait)
            } catch {
                XCTFail("VoiceOver traits accessibility audit failed: \(error.localizedDescription)")
            }
        }

        app.terminate()
    }

    /// Combined tab bar accessibility test
    func runTabBarAccessibilityTest() {
        let app = XCUIApplication()
        app.launch()

        let tabBar = app.tabBars.firstMatch
        let tabBarExists = tabBar.waitForExistence(timeout: 5)
        XCTAssertTrue(tabBarExists, "Tab bar should exist within 5 seconds")

        // Verify tab items exist and have proper labels
        for label in ["Home Is where th", "Focus", "Something Ama", "Eraser", "Grid"] {
            let tabItem = tabBar.buttons[label]
            XCTAssertTrue(tabItem.exists, "Tab item '\(label)' should exist")
            XCTAssertFalse(tabItem.label.isEmpty, "Tab item '\(label)' should have a non-empty label")
        }

        // If iOS 17+ is available, run an audit ignoring contrast or clipped text issues
        if #available(iOS 17.0, *) {
            do {
                try app.performAccessibilityAudit { issue in
                    let shouldIgnore = (issue.auditType == .contrast || issue.auditType == .textClipped)
                    print("Found issue: \(issue.description) (\(issue.auditType))")
                    return shouldIgnore
                }
            } catch {
                XCTFail("Accessibility audit failed: \(error.localizedDescription)")
            }
        }

        app.terminate()
    }
}

/// This is the actual test class that Xcode sees in the Test Navigator.
final class BubbleBarAccessibilityTests: XCTestCase {

    /// Our main-actor bridge instance
    private let ui = UIActions()

    // Each test method just calls into the bridging code
    // so we don't directly touch main-actor APIs here.

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
    
    @MainActor
    func testElementDescriptions() {
        ui.runElementDescriptionsTest()
    }
    
    @MainActor
    func testVoiceOverTraits() {
        ui.runVoiceOverTraitsTest()
    }
    
    @MainActor
    func testTabBarAccessibility() {
        ui.runTabBarAccessibilityTest()
    }
}
