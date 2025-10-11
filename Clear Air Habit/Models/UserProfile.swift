import Foundation

enum Gender: String, Codable, CaseIterable {
    case male = "Male"
    case female = "Female"
    case other = "Other"
}

enum AppTheme: String, Codable, CaseIterable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"
}

struct UserProfile: Codable {
    var name: String
    var gender: Gender?
    var age: Int?
    var quitDate: Date?
    var theme: AppTheme
    var maxStreak: Int
    
    init(name: String = "", gender: Gender? = nil, age: Int? = nil, quitDate: Date? = nil, theme: AppTheme = .system, maxStreak: Int = 0) {
        self.name = name
        self.gender = gender
        self.age = age
        self.quitDate = quitDate
        self.theme = theme
        self.maxStreak = maxStreak
    }
}
