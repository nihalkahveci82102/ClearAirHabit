import Foundation
import Combine

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @Published var userProfile: UserProfile
    @Published var habits: [Habit] = []
    @Published var smokingFreeDays: [Date] = []
    
    private let userProfileKey = "userProfile"
    private let habitsKey = "habits"
    private let smokingFreeDaysKey = "smokingFreeDays"
    
    private init() {
        userProfile = Self.loadUserProfile()
        habits = Self.loadHabits()
        smokingFreeDays = Self.loadSmokingFreeDays()
        
        if !smokingFreeDays.isEmpty && userProfile.maxStreak == 0 {
            updateMaxStreak()
        }
    }
    
    private static func loadUserProfile() -> UserProfile {
        guard let data = UserDefaults.standard.data(forKey: "userProfile"),
              let profile = try? JSONDecoder().decode(UserProfile.self, from: data) else {
            return UserProfile()
        }
        return profile
    }
    
    private static func loadHabits() -> [Habit] {
        guard let data = UserDefaults.standard.data(forKey: "habits"),
              let habits = try? JSONDecoder().decode([Habit].self, from: data) else {
            return []
        }
        return habits
    }
    
    private static func loadSmokingFreeDays() -> [Date] {
        guard let data = UserDefaults.standard.data(forKey: "smokingFreeDays"),
              let dates = try? JSONDecoder().decode([Date].self, from: data) else {
            return []
        }
        return dates
    }
    
    func saveUserProfile() {
        if let data = try? JSONEncoder().encode(userProfile) {
            UserDefaults.standard.set(data, forKey: userProfileKey)
        }
    }
    
    func saveHabits() {
        if let data = try? JSONEncoder().encode(habits) {
            UserDefaults.standard.set(data, forKey: habitsKey)
        }
    }
    
    func saveSmokingFreeDays() {
        if let data = try? JSONEncoder().encode(smokingFreeDays) {
            UserDefaults.standard.set(data, forKey: smokingFreeDaysKey)
        }
    }
    
    func addHabit(_ habit: Habit) {
        habits.append(habit)
        saveHabits()
    }
    
    func updateHabit(_ habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            habits[index] = habit
            saveHabits()
        }
    }
    
    func deleteHabit(_ habit: Habit) {
        habits.removeAll { $0.id == habit.id }
        saveHabits()
    }
    
    func toggleSmokingFreeDay(_ date: Date) {
        let calendar = Calendar.current
        let dateStart = calendar.startOfDay(for: date)
        
        if let index = smokingFreeDays.firstIndex(where: { calendar.isDate($0, inSameDayAs: dateStart) }) {
            smokingFreeDays.remove(at: index)
        } else {
            smokingFreeDays.append(dateStart)
        }
        saveSmokingFreeDays()
        updateMaxStreak()
    }
    
    func isSmokingFree(on date: Date) -> Bool {
        let calendar = Calendar.current
        return smokingFreeDays.contains { calendar.isDate($0, inSameDayAs: date) }
    }
    
    func calculateSmokingFreeStreak() -> Int {
        guard !smokingFreeDays.isEmpty else { return 0 }
        
        let calendar = Calendar.current
        let sortedDates = smokingFreeDays.sorted(by: >)
        let today = calendar.startOfDay(for: Date())
        
        var streak = 0
        var currentDate = today
        
        for date in sortedDates {
            let dateStart = calendar.startOfDay(for: date)
            
            if calendar.isDate(dateStart, inSameDayAs: currentDate) {
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            } else if dateStart < currentDate {
                break
            }
        }
        
        return streak
    }
    
    func calculateMaxStreak() -> Int {
        guard !smokingFreeDays.isEmpty else { return 0 }
        
        let calendar = Calendar.current
        let sortedDates = smokingFreeDays.map { calendar.startOfDay(for: $0) }.sorted()
        
        var maxStreak = 1
        var currentStreak = 1
        
        for i in 1..<sortedDates.count {
            let previousDate = sortedDates[i - 1]
            let currentDate = sortedDates[i]
            
            if let nextDay = calendar.date(byAdding: .day, value: 1, to: previousDate),
               calendar.isDate(nextDay, inSameDayAs: currentDate) {
                currentStreak += 1
                maxStreak = max(maxStreak, currentStreak)
            } else {
                currentStreak = 1
            }
        }
        
        return maxStreak
    }
    
    func updateMaxStreak() {
        let calculatedMaxStreak = calculateMaxStreak()
        if calculatedMaxStreak > userProfile.maxStreak {
            userProfile.maxStreak = calculatedMaxStreak
            saveUserProfile()
        }
    }
}
