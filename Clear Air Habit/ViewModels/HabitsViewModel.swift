import Foundation
import Combine

class HabitsViewModel: ObservableObject {
    @Published var habits: [Habit] = []
    
    private let dataManager = DataManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadHabits()
        setupObservers()
    }
    
    private func setupObservers() {
        dataManager.$habits
            .sink { [weak self] in self?.habits = $0 }
            .store(in: &cancellables)
    }
    
    func loadHabits() {
        habits = dataManager.habits
    }
    
    func addHabit(title: String, description: String) {
        let habit = Habit(title: title, description: description)
        dataManager.addHabit(habit)
    }
    
    func toggleHabitCompletion(habit: Habit, date: Date) {
        var updatedHabit = habit
        updatedHabit.toggleCompletion(for: date)
        dataManager.updateHabit(updatedHabit)
    }
    
    func deleteHabit(_ habit: Habit) {
        dataManager.deleteHabit(habit)
    }
    
    func refresh() {
        loadHabits()
    }
}

