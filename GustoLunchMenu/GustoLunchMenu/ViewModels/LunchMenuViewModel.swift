//
//  LunchMenuViewModel.swift
//  GustoLunchMenu
//
//  Created by Nicolas Rios on 3/7/25.
//

import Foundation
import SwiftUI
import EventKit

protocol CalendarManaging {
    func fetchLunchEvents() -> [EKEvent]
    func addEventToCalendar(date: Date, meal: String)
}

final class LunchMenuViewModel: ObservableObject {
    @Published var menuItems: [LunchMenu] = []
    @Published var isLoading = true
    @Published var calendarEvents: [EKEvent] = []

    let calendarManager: CalendarManaging
    private let service: LunchMenuService

    init(service: LunchMenuService, calendarManager: CalendarManaging = CalendarManager()) {
        self.service = service
        self.calendarManager = calendarManager
        fetchLunchMenu()
    }

    /// Fetches the lunch menu and maps meals to correct days.
    func fetchLunchMenu() {
        Task {
            do {
                let menu = await service.fetchLunchMenu()
                DispatchQueue.main.async {
                    let weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
                    var date = Date()
                    self.menuItems = menu.enumerated().flatMap { (weekIndex, meals) in
                        meals.enumerated().compactMap { (dayIndex, meal) in
                            while Calendar.current.isDateInWeekend(date) {
                                date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
                            }
                            let day = weekdays[dayIndex]
                            print("📅 Loaded meal: \(meal) on \(date)")
                            let lunchMenu = LunchMenu(day: day, date: date, meal: meal)
                            date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
                            return lunchMenu
                        }
                    }
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                    print("❌ Failed to fetch lunch menu: \(error.localizedDescription)")
                }
            }
        }
    }

    /// Adds a selected meal to the calendar.
    func syncWithCalendar(for date: Date) {
        guard let meal = mealForDate(date) else {
            print("⚠️ No meal found for selected date!")
            return
        }
        calendarManager.addEventToCalendar(date: date, meal: meal)
        fetchCalendarEvents()
        print("✅ Added \(meal) to calendar for \(date)")
    }

    /// Fetches lunch events from the calendar.
    func fetchCalendarEvents() {
        DispatchQueue.main.async {
            self.calendarEvents = self.calendarManager.fetchLunchEvents()
            print("📆 Calendar Events Loaded: \(self.calendarEvents.count)")
        }
    }

    /// Retrieves the meal for a selected date.
    func mealForDate(_ date: Date) -> String? {
        return menuItems.first(where: {
            Calendar.current.isDate($0.date, equalTo: date, toGranularity: .day)
        })?.meal
    }
}
