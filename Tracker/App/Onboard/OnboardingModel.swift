//
//  OnboardingPageModel.swift
//  Tracker
//
//  Created by Максим Лозебной on 22.02.2026.
//

import UIKit

struct OnboardingModel {
    let image: UIImage?
    let description: String
    
    static let models: [OnboardingModel] = [
        OnboardingModel(
            image: UIImage(named: "onboard_1"),
            description: L10n.onboard1Label
        ),
        OnboardingModel(
            image: UIImage(named: "onboard_2"),
            description: L10n.onboard2Label
        )
    ]
}
