//
//  LunchCardView.swift
//  GustoLunchMenu
//
//  Created by Nicolas Rios on 3/7/25.
//

import SwiftUI
import EventKit

struct LunchDetailCard: View {
    let date: Date
    let meal: String
    let calendarManager: CalendarManaging 
    var body: some View {
        VStack(spacing: 10) {
            Text("Lunch on \(formattedDate(date))")
                .font(.title3)
                .fontWeight(.semibold)
            
            Text(meal)
                .font(.headline)
                .foregroundColor(.blue)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(radius: 3)
        )
        .padding(.top, 10)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: date)
    }
}
