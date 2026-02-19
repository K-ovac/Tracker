//
//  TabBarController.swift
//  Tracker
//
//  Created by Максим Лозебной on 27.01.2026.
//

import UIKit

final class TabBarController: UITabBarController {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTabBar()
    }
    
    // MARK: - Setup
    private func setupView() {
        view.backgroundColor = Colors.background
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Colors.tabBarTint
        appearance.shadowColor = UIColor.separator
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = Colors.selectedItem
        tabBar.unselectedItemTintColor = Colors.unselectedItem
    }
    
    private func setupTabBar() {
        let trackerIcon = UIImage(named: "trackerTabBarItem")?
            .withRenderingMode(.alwaysTemplate)
        let statisticsIcon = UIImage(named: "statisticsTabBarItem")?
            .withRenderingMode(.alwaysTemplate)
        
        let trackerVC = TrackerViewController()
        let trackerNav = UINavigationController(rootViewController: trackerVC)
        let statisticsVC = StatisticsViewController()
        //let statisticsNav = NavigationController(rootViewController: statisticsVC)
        
        let trackerTabBarItem = UITabBarItem(
            title: "Трекеры",
            image: trackerIcon,
            selectedImage: nil
        )
        trackerTabBarItem.tag = 0
        trackerVC.tabBarItem = trackerTabBarItem
        
        let statisticsTabBarItem = UITabBarItem(
            title: "Статистика",
            image: statisticsIcon,
            selectedImage: nil
        )
        statisticsTabBarItem.tag = 1
        statisticsVC.tabBarItem = statisticsTabBarItem
        
        viewControllers = [
            trackerNav,
            statisticsVC
        ]
    }
}
