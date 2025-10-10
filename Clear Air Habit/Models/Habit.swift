import Foundation

struct Habit: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String
    var createdDate: Date
    var completedDates: [Date]
    
    var currentStreak: Int {
        calculateStreak()
    }
    
    init(id: UUID = UUID(), title: String, description: String = "", createdDate: Date = Date(), completedDates: [Date] = []) {
        self.id = id
        self.title = title
        self.description = description
        self.createdDate = createdDate
        self.completedDates = completedDates
    }
    
    mutating func toggleCompletion(for date: Date) {
        let calendar = Calendar.current
        let dateStart = calendar.startOfDay(for: date)
        
        if let index = completedDates.firstIndex(where: { calendar.isDate($0, inSameDayAs: dateStart) }) {
            completedDates.remove(at: index)
        } else {
            completedDates.append(dateStart)
        }
    }
    
    func isCompleted(on date: Date) -> Bool {
        let calendar = Calendar.current
        return completedDates.contains { calendar.isDate($0, inSameDayAs: date) }
    }
    
    private func calculateStreak() -> Int {
        guard !completedDates.isEmpty else { return 0 }
        
        let calendar = Calendar.current
        let sortedDates = completedDates.sorted(by: >)
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
}
