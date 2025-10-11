import SwiftUI

struct CalendarView: View {
    @StateObject private var viewModel = CalendarViewModel()
    @StateObject private var habitsViewModel = HabitsViewModel()
    
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    let weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        Button(action: {
                            withAnimation {
                                viewModel.moveMonth(by: -1)
                            }
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(.accentColor)
                        }
                        
                        Spacer()
                        
                        Text(viewModel.monthYearString())
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation {
                                viewModel.moveMonth(by: 1)
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
                        ForEach(Array(viewModel.getDaysInMonth().enumerated()), id: \.offset) { _, date in
                            if let date = date {
                                CalendarDayCell(
                                    date: date,
                                    isSmokingFree: viewModel.isSmokingFree(on: date),
                                    isSelected: Calendar.current.isDate(date, inSameDayAs: viewModel.selectedDate)
                                )
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        viewModel.selectedDate = date
                                        viewModel.toggleSmokingFreeDay(date)
                                    }
                                }
                            } else {
                                Color.clear
                                    .frame(height: 50)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    if !viewModel.habits.isEmpty {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("My Habits")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            ForEach(viewModel.habits) { habit in
                                NavigationLink(destination: HabitDetailView(viewModel: habitsViewModel, habitId: habit.id)) {
                                    HabitCalendarCard(habit: habit)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .transition(.asymmetric(
                                    insertion: .scale.combined(with: .opacity),
                                    removal: .opacity
                                ))
                            }
                            .padding(.horizontal)
                        }
                        .padding(.top, 10)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Calendar")
            .onAppear {
                viewModel.refresh()
            }
        }
    }
}

struct CalendarDayCell: View {
    let date: Date
    let isSmokingFree: Bool
    let isSelected: Bool
    
    var body: some View {
        VStack {
            Text("\(Calendar.current.component(.day, from: date))")
                .font(.system(size: 16, weight: isSelected ? .bold : .regular))
                .foregroundColor(isSelected ? .white : .primary)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(isSmokingFree ? Color.green.opacity(0.8) : Color.clear)
                )
                .overlay(
                    Circle()
                        .stroke(isSelected ? Color.accentColor : Color.clear, lineWidth: 2)
                )
                .scaleEffect(isSelected ? 1.1 : 1.0)
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSmokingFree)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

struct HabitCalendarCard: View {
    let habit: Habit
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(habit.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("Streak: \(habit.currentStreak) days")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "flame.fill")
                .font(.title2)
                .foregroundColor(habit.currentStreak > 0 ? .orange : .gray)
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

