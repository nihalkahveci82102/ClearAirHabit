import Foundation
import Combine
import StoreKit

class ProfileViewModel: ObservableObject {
    @Published var name = ""
    @Published var gender: Gender?
    @Published var age = ""
    @Published var selectedTheme = AppTheme.system
    
    private let dataManager = DataManager.shared
    private var isSaving = false
    
    init() {
        loadProfile()
    }
    
    func loadProfile() {
        guard !isSaving else { return }
        name = dataManager.userProfile.name
        gender = dataManager.userProfile.gender
        age = dataManager.userProfile.age.map { String($0) } ?? ""
        selectedTheme = dataManager.userProfile.theme
    }
    
    func saveProfile() {
        isSaving = true
        var updatedProfile = dataManager.userProfile
        updatedProfile.name = name
        updatedProfile.gender = gender
        updatedProfile.age = Int(age)
        updatedProfile.theme = selectedTheme
        dataManager.userProfile = updatedProfile
        dataManager.saveUserProfile()
        isSaving = false
    }
    
    func requestAppReview() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        
        if #available(iOS 18.0, *) {
            AppStore.requestReview(in: windowScene)
        } else {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
}

