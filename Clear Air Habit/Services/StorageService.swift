import Foundation

class StorageService {
    static let shared = StorageService()
    
    private let tokenKey = "app_access_token"
    private let contentPathKey = "app_content_path"
    
    private init() {}
    
    var savedToken: String? {
        get {
            UserDefaults.standard.string(forKey: tokenKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: tokenKey)
        }
    }
    
    var savedContentPath: String? {
        get {
            UserDefaults.standard.string(forKey: contentPathKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: contentPathKey)
        }
    }
    
    func saveServerResponse(_ response: ServerResponse) {
        savedToken = response.token
        savedContentPath = response.contentPath
    }
    
    func clearServerData() {
        savedToken = nil
        savedContentPath = nil
    }
    
    var hasValidSession: Bool {
        return savedToken != nil && savedContentPath != nil
    }
}

