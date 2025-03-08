//
//  LunchCalendarView.swift
//  GustoLunchMenu
//
//  Created by Nicolas Rios on 3/7/25.
//
import SwiftUI

struct LunchCalendarView: View {
    @StateObject var viewModel: LunchMenuViewModel
    @State private var selectedDate: Date = Date()

    var body: some View {
        NavigationView {
            VStack(spacing: 12) {
                DatePicker("Pick a Date", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                            .shadow(radius: 3)
                    )

                if let meal = viewModel.mealForDate(selectedDate) {
                    LunchDetailCard(date: selectedDate, meal: meal, calendarManager: viewModel.calendarManager)
                } else {
                    Text("No meal available for this date")
                        .foregroundColor(.gray)
                        .padding()
                }

                Spacer()
            }
            .padding()
            .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
            .navigationTitle("Lunch Calendar")
            .toolbar {
                // ✅ Ensured only one toolbar button exists
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: addMealToCalendar) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(viewModel.mealForDate(selectedDate) == nil ? .gray : .blue)
                    }
                    .disabled(viewModel.mealForDate(selectedDate) == nil)
                }
            }
            .onAppear {
                viewModel.fetchLunchMenu()
            }
        }
    }

    /// Adds selected meal to calendar if available
    private func addMealToCalendar() {
        guard let meal = viewModel.mealForDate(selectedDate) else { return }
        viewModel.syncWithCalendar(for: selectedDate)
    }
}
