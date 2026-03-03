//
//  L10n.swift
//  Tracker
//
//  Created by Максим Лозебной on 27.02.2026.
//
import Foundation

enum L10n {
    static let completeButton = NSLocalizedString("completeButton", comment: "")
    
    static let onboard1Label = NSLocalizedString("onboard_1_label", comment: "")
    static let onboard2Label = NSLocalizedString("onboard_2_label", comment: "")
    static let startButton = NSLocalizedString("startButton", comment: "")
    
    static let trackersScreenName = NSLocalizedString("trackers_screen_name", comment: "")
    static let trackersScreenPlaceholderText = NSLocalizedString("trackersScreen_placeholderText", comment: "")
    static let trackersScreenPlaceholderTextForNotFound = NSLocalizedString("trackersScreenPlaceholderTextForNotFound", comment: "")
    static let searchFieldPlaceholder = NSLocalizedString("searchField_placeholder", comment: "")
    static let filtresButton = NSLocalizedString("filtresButton", comment: "")
    
    static let filtersScreenName = NSLocalizedString("filters_screen_name", comment: "")
    static let allTrackers = NSLocalizedString("allTrackers", comment: "")
    static let todayTrackers = NSLocalizedString("todayTrackers", comment: "")
    static let completedTrackers = NSLocalizedString("completedTrackers", comment: "")
    static let notCompletedTrackers = NSLocalizedString("notCompletedTrackers", comment: "")
    
    static let newTrackerNavigationTitle = NSLocalizedString("newTracker_navigationTitle", comment: "")
    static let nameTrackerTextFieldPlaceholder = NSLocalizedString("nameTracker_textField_placeholder", comment: "")
    static let nameLimitLabel = NSLocalizedString("name_limitLabel", comment: "")
    static let categotyButton = NSLocalizedString("categotyButton", comment: "")
    static let scheduleButton = NSLocalizedString("scheduleButton", comment: "")
    static let emojiHeader = NSLocalizedString("emojiHeader", comment: "")
    static let colorHeader = NSLocalizedString("colorHeader", comment: "")
    static let cancelButton = NSLocalizedString("cancelButton", comment: "")
    static let createButton = NSLocalizedString("createButton", comment: "")
    static let subLableAllDay = NSLocalizedString("subLable_allDay", comment: "")
    
    static let categoryNavigationTitle = NSLocalizedString("category_navigationTitle", comment: "")
    static let caregoryScreenPlaceholderText = NSLocalizedString("caregoryScreen_placeholderText", comment: "")
    static let addCategoryButton = NSLocalizedString("addCategoryButton", comment: "")
    static let newCategoryNavigationTitle = NSLocalizedString("newCategory_navigationTitle", comment: "")
    static let nameCategoryTextFieldPlaceholder = NSLocalizedString("nameCategory_textField_placeholder", comment: "")
    
    static let scheduleNavigationTitle = NSLocalizedString("schedule_navigationTitle", comment: "")
    static let monday = NSLocalizedString("monday", comment: "")
    static let tuesday = NSLocalizedString("tuesday", comment: "")
    static let wednesday = NSLocalizedString("wednesday", comment: "")
    static let thursday = NSLocalizedString("thursday", comment: "")
    static let friday = NSLocalizedString("friday", comment: "")
    static let saturday = NSLocalizedString("saturday", comment: "")
    static let sunday = NSLocalizedString("sunday", comment: "")
    
    static let mon = NSLocalizedString("mon", comment: "")
    static let tue = NSLocalizedString("tue", comment: "")
    static let wed = NSLocalizedString("wed", comment: "")
    static let thu = NSLocalizedString("thu", comment: "")
    static let fri = NSLocalizedString("fri", comment: "")
    static let sat = NSLocalizedString("sat", comment: "")
    static let sun = NSLocalizedString("sun", comment: "")
    
    static let statsScreenName = NSLocalizedString("stats_screen_name", comment: "")
    static let statsScreenPlaceholderText = NSLocalizedString("statsScreen_placeholderText", comment: "")
    static let bestPeriod = NSLocalizedString("bestPeriod", comment: "")
    static let perfectDays = NSLocalizedString("perfectDays", comment: "")
    static let trackersCompleted = NSLocalizedString("trackersCompleted", comment: "")
    static let avgScore = NSLocalizedString("avgScore", comment: "")
    
    static let deleteAlertTitle = NSLocalizedString("delete_alert_title", comment: "")
    static let deleteActionTitle = NSLocalizedString("delete_action_title", comment: "")
    static let cancelDeleteActionTitle = NSLocalizedString("cancelDelete_action_title", comment: "")
    static let editActionTitle = NSLocalizedString("edit_action_title", comment: "")
    
    static let editScreenName = NSLocalizedString("edit_screen_name", comment: "")
    static let saveButtonTitle = NSLocalizedString("save_button_title", comment: "")
}

//MARK: Расширение с методом, который вызывается несколько раз
//перемещен из экранов редактирования трекера и ячейки трекера главного экрана
extension L10n {
    static func daysTitle(for count: Int) -> String {
        String.localizedStringWithFormat(NSLocalizedString("days", comment: ""), count)
    }
}
