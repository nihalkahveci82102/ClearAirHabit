import Foundation

struct BreathingExercise: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let duration: Int
    let steps: [String]
    let icon: String
    
    static let exercises: [BreathingExercise] = [
        BreathingExercise(
            title: "4-7-8 Breathing",
            description: "Technique for quick calming and stress relief",
            duration: 60,
            steps: [
                "Exhale completely through your mouth with a whooshing sound",
                "Close your mouth and inhale through your nose, counting to 4",
                "Hold your breath for 7 seconds",
                "Exhale through your mouth for 8 seconds",
                "Repeat the cycle 3-4 times"
            ],
            icon: "wind"
        ),
        BreathingExercise(
            title: "Box Breathing",
            description: "Helps focus and reduce anxiety",
            duration: 80,
            steps: [
                "Inhale through your nose for 4 counts",
                "Hold your breath for 4 counts",
                "Exhale through your mouth for 4 counts",
                "Hold your breath for 4 counts",
                "Repeat 5 cycles"
            ],
            icon: "square"
        ),
        BreathingExercise(
            title: "Diaphragmatic Breathing",
            description: "Deep belly breathing for relaxation",
            duration: 120,
            steps: [
                "Place one hand on your chest, the other on your belly",
                "Slowly inhale through your nose, expanding your belly",
                "Your chest should remain still",
                "Slowly exhale through your mouth",
                "Continue for 5-10 minutes"
            ],
            icon: "lungs"
        ),
        BreathingExercise(
            title: "Alternate Nostril Breathing",
            description: "Balances emotions and calms the mind",
            duration: 90,
            steps: [
                "Close your right nostril with your thumb",
                "Inhale through your left nostril",
                "Close your left nostril, open your right",
                "Exhale through your right nostril",
                "Inhale through right, exhale through left",
                "Repeat 5-10 cycles"
            ],
            icon: "arrow.left.arrow.right"
        )
    ]
}
