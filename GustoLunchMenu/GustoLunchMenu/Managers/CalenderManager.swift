//
//  CalanderManager.swift
//  GustoLunchMenu
//
//  Created by Nicolas Rios on 3/7/25.
//

import Foundation
import EventKit


final class CalendarManager: CalendarManaging {
    private let eventStore: EKEventStore
    
    // ✅ Dependency Injection - Allow external injection of `EKEventStore`
    init(eventStore: EKEventStore = EKEventStore()) {
        self.eventStore = eventStore
    }
    
    func requestCalendarAccess(completion: @escaping (Bool, Error?) -> Void) {
        eventStore.requestAccess(to: .event) { granted, error in
            DispatchQueue.main.async {
                completion(granted, error)
            }
        }
    }
    
    func fetchLunchEvents() -> [EKEvent] {
        let startDate = Date()
        let endDate = Calendar.current.date(byAdding: .month, value: 1, to: startDate)!
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
        return eventStore.events(matching: predicate)
    }
    
    func addEventToCalendar(date: Date, meal: String) {
        requestCalendarAccess { granted, error in
            guard granted else {
                print("❌ Calendar access denied: \(String(describing: error))")
                return
            }
            
            let event = EKEvent(eventStore: self.eventStore)
            event.title = "Lunch: \(meal)"
            event.startDate = date
            event.endDate = Calendar.current.date(byAdding: .hour, value: 1, to: date)
            event.calendar = self.eventStore.defaultCalendarForNewEvents
            
            do {
                try self.eventStore.save(event, span: .thisEvent)
                print("✅ Event added successfully!")
            } catch let error {
                print("❌ Error saving event: \(error)")
            }
        }
    }
}
