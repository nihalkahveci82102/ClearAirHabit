import Foundation
import Combine

class StatisticsViewModel: ObservableObject {
    @Published var smokingFreeStreak = 0
    @Published var maxStreak = 0
    
    private let dataManager = DataManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        updateStreak()
        setupObservers()
    }
    
    private func setupObservers() {
        dataManager.$smokingFreeDays
            .sink { [weak self] _ in self?.updateStreak() }
            .store(in: &cancellables)
    }
    
    func updateStreak() {
        dataManager.updateMaxStreak()
        maxStreak = dataManager.userProfile.maxStreak
        smokingFreeStreak = dataManager.calculateSmokingFreeStreak()
    }
    
    func getRelevantFacts() -> [HealthFact] {
        HealthFact.facts.filter { $0.daysRequired <= smokingFreeStreak }
    }
    
    func getNextMilestone() -> HealthFact? {
        HealthFact.facts.first { $0.daysRequired > smokingFreeStreak }
    }
    
    func getDaysUntilNextMilestone() -> Int? {
        guard let milestone = getNextMilestone() else { return nil }
        return milestone.daysRequired - smokingFreeStreak
    }
}

