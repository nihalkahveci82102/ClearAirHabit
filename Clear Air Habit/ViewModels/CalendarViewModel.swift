import Foundation
import Combine

class CalendarViewModel: ObservableObject {
    @Published var currentMonth = Date()
    @Published var selectedDate = Date()
    @Published var habits: [Habit] = []
    @Published var smokingFreeDays: [Date] = []
    
    private let dataManager = DataManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadData()
        setupObservers()
    }
    
    private func setupObservers() {
        dataManager.$habits
            .sink { [weak self] in self?.habits = $0 }
            .store(in: &cancellables)
        
        dataManager.$smokingFreeDays
            .sink { [weak self] in self?.smokingFreeDays = $0 }
            .store(in: &cancellables)
    }
    
    func loadData() {
        habits = dataManager.habits
        smokingFreeDays = dataManager.smokingFreeDays
    }
    
    func isSmokingFree(on date: Date) -> Bool {
        dataManager.isSmokingFree(on: date)
    }
    
    func toggleSmokingFreeDay(_ date: Date) {
        dataManager.toggleSmokingFreeDay(date)
    }
    
    func getDaysInMonth() -> [Date?] {
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
    
    func moveMonth(by value: Int) {
        let calendar = Calendar.current
        if let newMonth = calendar.date(byAdding: .month, value: value, to: currentMonth) {
            currentMonth = newMonth
        }
    }
    
    func monthYearString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy"
        return formatter.string(from: currentMonth).capitalized
    }
    
    func refresh() {
        loadData()
    }
}

