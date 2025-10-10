import SwiftUI

struct HabitsView: View {
    @StateObject private var viewModel = HabitsViewModel()
    @State private var showingAddHabit = false
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.habits.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "checkmark.circle")
                            .font(.system(size: 70))
                            .foregroundColor(.green)
                        
                        Text("Create a New Habit")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Add healthy habits to help you quit smoking")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        
                        Button(action: {
                            showingAddHabit = true
                        }) {
                            Label("Add Habit", systemImage: "plus.circle.fill")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.accentColor)
                                .cornerRadius(12)
                        }
                        .padding(.top)
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 15) {
                            ForEach(viewModel.habits) { habit in
                                HabitCard(habit: habit, viewModel: viewModel)
                                    .transition(.asymmetric(
                                        insertion: .move(edge: .trailing).combined(with: .opacity),
                                        removal: .move(edge: .leading).combined(with: .opacity)
                                    ))
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Habits")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddHabit = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title3)
                    }
                }
            }
            .sheet(isPresented: $showingAddHabit) {
                AddHabitView(viewModel: viewModel)
            }
            .onAppear {
                viewModel.refresh()
            }
        }
    }
}

struct HabitCard: View {
    let habit: Habit
    let viewModel: HabitsViewModel
    @State private var showingDetails = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(habit.title)
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    if !habit.description.isEmpty {
                        Text(habit.description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    showingDetails.toggle()
                }) {
                    Image(systemName: "chevron.down")
                        .rotationEffect(.degrees(showingDetails ? 180 : 0))
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: showingDetails)
                }
            }
            
            HStack(spacing: 10) {
                Image(systemName: "flame.fill")
                    .font(.title2)
                    .foregroundColor(habit.currentStreak > 0 ? .orange : .gray)
                    .symbolEffect(.bounce, value: habit.currentStreak)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(habit.currentStreak) days in a row")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .contentTransition(.numericText())
                    
                    Text("Current Streak")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        viewModel.toggleHabitCompletion(habit: habit, date: Date())
                    }
                }) {
                    Image(systemName: habit.isCompleted(on: Date()) ? "checkmark.circle.fill" : "circle")
                        .font(.title)
                        .foregroundColor(habit.isCompleted(on: Date()) ? .green : .gray)
                        .contentTransition(.symbolEffect(.replace))
                }
            }
            
            if showingDetails {
                VStack(alignment: .leading, spacing: 10) {
                    Divider()
                    
                    Text("Last 7 Days")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 8) {
                        ForEach(0..<7) { index in
                            let date = Calendar.current.date(byAdding: .day, value: -6 + index, to: Date()) ?? Date()
                            
                            VStack(spacing: 5) {
                                Text(dayName(for: date))
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                
                                Circle()
                                    .fill(habit.isCompleted(on: date) ? Color.green : Color.gray.opacity(0.3))
                                    .frame(width: 30, height: 30)
                                    .overlay(
                                        Image(systemName: habit.isCompleted(on: date) ? "checkmark" : "")
                                            .font(.caption)
                                            .foregroundColor(.white)
                                    )
                            }
                        }
                    }
                    
                    Button(role: .destructive, action: {
                        withAnimation {
                            viewModel.deleteHabit(habit)
                        }
                    }) {
                        Label("Delete Habit", systemImage: "trash")
                            .font(.subheadline)
                            .foregroundColor(.red)
                    }
                    .padding(.top, 5)
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .top).combined(with: .opacity),
                    removal: .move(edge: .top).combined(with: .opacity)
                ))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.secondarySystemBackground))
        )
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: habit.currentStreak)
    }
    
    private func dayName(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EE"
        return formatter.string(from: date).prefix(2).uppercased()
    }
}

struct AddHabitView: View {
    @Environment(\.dismiss) var dismiss
    let viewModel: HabitsViewModel
    
    @State private var title = ""
    @State private var description = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Habit Information")) {
                    TextField("Name", text: $title)
                    TextField("Description (optional)", text: $description, axis: .vertical)
                        .lineLimit(3...5)
                }
                
                Section {
                    Button(action: {
                        if !title.isEmpty {
                            withAnimation {
                                viewModel.addHabit(title: title, description: description)
                            }
                            dismiss()
                        }
                    }) {
                        Text("Add")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(title.isEmpty ? .gray : .accentColor)
                    }
                    .disabled(title.isEmpty)
                }
            }
            .navigationTitle("New Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

