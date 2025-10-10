import Foundation

struct HealthFact: Identifiable {
    let id = UUID()
    let daysRequired: Int
    let title: String
    let description: String
    let icon: String
    
    static let facts: [HealthFact] = [
        HealthFact(daysRequired: 0, title: "Starting Point", description: "You made an important decision! Your body is already beginning to recover.", icon: "🎯"),
        HealthFact(daysRequired: 1, title: "1 Day", description: "Carbon monoxide levels in blood decrease. Breathing becomes easier.", icon: "🫁"),
        HealthFact(daysRequired: 2, title: "2 Days", description: "Sense of smell and taste improve. Food tastes better!", icon: "👃"),
        HealthFact(daysRequired: 3, title: "3 Days", description: "Breathing becomes easier, lung capacity increases.", icon: "🌬️"),
        HealthFact(daysRequired: 7, title: "1 Week", description: "Your lungs begin to clear. Complexion improves.", icon: "✨"),
        HealthFact(daysRequired: 14, title: "2 Weeks", description: "Blood circulation improves. Physical exercise becomes easier.", icon: "💪"),
        HealthFact(daysRequired: 30, title: "1 Month", description: "Lung function improves by 30%. Risk of infections decreases significantly.", icon: "🏆"),
        HealthFact(daysRequired: 90, title: "3 Months", description: "Almost complete recovery of circulation and lung function.", icon: "🎉"),
        HealthFact(daysRequired: 180, title: "6 Months", description: "Stress decreases, sleep and overall well-being improve.", icon: "😊"),
        HealthFact(daysRequired: 365, title: "1 Year", description: "Risk of heart disease is cut in half!", icon: "🎊")
    ]
}
