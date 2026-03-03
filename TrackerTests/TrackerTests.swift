//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Максим Лозебной on 03.03.2026.
//

import XCTest
import SnapshotTesting
@testable import Tracker

//Тестировал на симуляторе Iphone 16e ios 18.5
final class TrackerSnapshotTests: XCTestCase {
    // MARK: - Light Theme test
    func testTrackerViewController_lightTheme() {
        let vc = setupMainViewController()
        assertSnapshot(
            of: vc,
            as: .image(
                size: CGSize(width: 390, height: 844),
                traits: .init(userInterfaceStyle: .light)
            )
        )
    }
    
    // MARK: - Dark Theme test
    func testTrackerViewController_darkTheme() {
        let vc = setupMainViewController()
        assertSnapshot(
            of: vc,
            as: .image(
                size: CGSize(width: 390, height: 844),
                traits: .init(userInterfaceStyle: .dark)
            )
        )
    }
        
    private func setupMainViewController() -> TabBarController {
        TabBarController()
    }
}
