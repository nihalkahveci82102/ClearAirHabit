import SwiftUI

struct HabitDetailView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: HabitsViewModel
    let habitId: UUID
    
    @State private var currentMonth: Date = Date()
    @State private var selectedDate: Date = Date()
    
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    let weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    private var habit: Habit? {
        viewModel.habits.first(where: { $0.id == habitId })
    }
    
    var body: some View {
        Group {
            if let habit = habit {
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(spacing: 15) {
                            Image(systemName: "flame.fill")
                                .font(.system(size: 60))
                                .foregroundColor(habit.currentStreak > 0 ? .orange : .gray)
                                .symbolEffect(.bounce, value: habit.currentStreak)
                            
                            Text("\(habit.currentStreak)")
                                .font(.system(size: 72, weight: .bold, design: .rounded))
                                .contentTransition(.numericText())
                            
                            Text(daysText(habit.currentStreak))
                                .font(.title2)
                                .foregroundColor(.secondary)
                            
                            Text("days in a row!")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(.secondarySystemBackground))
                        )
                        .padding(.horizontal)
                        
                        if !habit.description.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Description")
                                    .font(.headline)
                                Text(habit.description)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color(.secondarySystemBackground))
                            )
                            .padding(.horizontal)
                        }
                
                        HStack {
                    Button(action: {
                        withAnimation {
                            moveMonth(by: -1)
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.accentColor)
                    }
                    
                    Spacer()
                    
                    Text(monthYearString())
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            moveMonth(by: 1)
                        }
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.title2)
                            .foregroundColor(.accentColor)
                    }
                        }
                        .padding(.horizontal)
                        
                        LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(weekdays, id: \.self) { day in
                        Text(day)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                    }
                        }
                        .padding(.horizontal)
                        
                        LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(Array(getDaysInMonth().enumerated()), id: \.offset) { _, date in
                        if let date = date {
                            HabitDayCell(
                                date: date,
                                isCompleted: habit.isCompleted(on: date),
                                isSelected: Calendar.current.isDate(date, inSameDayAs: selectedDate)
                            )
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedDate = date
                                    viewModel.toggleHabitCompletion(habit: habit, date: date)
                                }
                            }
                        } else {
                            Color.clear
                                .frame(height: 50)
                        }
                    }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
                .navigationTitle(habit.title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
            } else {
                Text("Habit not found")
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private func getDaysInMonth() -> [Date?] {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: currentMonth)
        
        guard let firstDayOfMonth = calendar.date(from: components),
              let range = calendar.range(of: .day, in: .month, for: firstDayOfMonth) else {
            return []
        }
        
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        let numberOfDays = range.count
        
        var days: [Date?] = Array(repeating: nil, count: firstWeekday - 1)
        
        for day in 1...numberOfDays {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth) {
                days.append(date)
            }
        }
        
        return days
    }
    
    private func moveMonth(by value: Int) {
        let calendar = Calendar.current
        if let newMonth = calendar.date(byAdding: .month, value: value, to: currentMonth) {
            currentMonth = newMonth
        }
    }
    
    private func monthYearString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy"
        return formatter.string(from: currentMonth).capitalized
    }
    
    private func daysText(_ days: Int) -> String {
        days == 1 ? "\(days) day" : "\(days) days"
    }
}

struct HabitDayCell: View {
    let date: Date
    let isCompleted: Bool
    let isSelected: Bool
    
    var body: some View {
        VStack {
            Text("\(Calendar.current.component(.day, from: date))")
                .font(.system(size: 16, weight: isSelected ? .bold : .regular))
                .foregroundColor(isSelected ? .white : .primary)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(isCompleted ? Color.orange.opacity(0.8) : Color.clear)
                )
                .overlay(
                    Circle()
                        .stroke(isSelected ? Color.accentColor : Color.clear, lineWidth: 2)
                )
                .scaleEffect(isSelected ? 1.1 : 1.0)
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isCompleted)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

