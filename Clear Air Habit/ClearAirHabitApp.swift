import SwiftUI
import CoreData
import Combine

@main
struct ClearAirHabitApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
                .preferredColorScheme(appState.colorScheme)
        }
    }
}

class AppState: ObservableObject {
    @Published var isLoading = true
    @Published var showSmokingScreen = false
    @Published var contentPath: String?
    @Published var colorScheme: ColorScheme?
    
    private let storage = StorageService.shared
    private let network = NetworkService.shared
    private let dataManager = DataManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        updateColorScheme()
        setupThemeObserver()
        OrientationManager.shared.lockToPortrait()
        checkInitialState()
    }
    
    private func setupThemeObserver() {
        dataManager.$userProfile
            .map { profile in
                switch profile.theme {
                case .light:
                    return .light
                case .dark:
                    return .dark
                case .system:
                    return nil
                }
            }
            .assign(to: &$colorScheme)
    }
    
    private func updateColorScheme() {
        switch dataManager.userProfile.theme {
        case .light:
            colorScheme = .light
        case .dark:
            colorScheme = .dark
        case .system:
            colorScheme = nil
        }
    }
    
    private func checkInitialState() {
        if storage.hasValidSession, let path = storage.savedContentPath {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                OrientationManager.shared.unlockAllOrientations()
            }
            DispatchQueue.main.async {
                self.contentPath = path
                self.showSmokingScreen = true
                self.isLoading = false
            }
        } else {
            performServerCheck()
        }
    }
    
    private func performServerCheck() {
        network.checkServerAccess { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if response.hasValidContent {
                        self?.storage.saveServerResponse(response)
                        self?.contentPath = response.contentPath
                        self?.showSmokingScreen = true
                        OrientationManager.shared.unlockAllOrientations()
                    }
                case .failure:
                    break
                }
                self?.isLoading = false
            }
        }
    }
}

struct RootView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var dataManager = DataManager.shared
    
    var body: some View {
        Group {
            if appState.isLoading {
                LoadingScreen()
            } else if appState.showSmokingScreen, let path = appState.contentPath {
                SmokingScreen(contentPath: path)
            } else {
                MainTabView()
                    .environmentObject(dataManager)
            }
        }
    }
}
