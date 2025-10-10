import Foundation
import UIKit

class NetworkService {
    static let shared = NetworkService()
    
    private init() {}
    
    func checkServerAccess(completion: @escaping (Result<ServerResponse, Error>) -> Void) {
        guard var components = URLComponents(string: "https://wallen-eatery.space/ios-vdm-4/server.php") else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let osVersion = UIDevice.current.systemVersion
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        let preferredLanguage = Locale.preferredLanguages.first ?? "en"
        let component = preferredLanguage.components(separatedBy: "-")
        let languageCode = component.first ?? "en"
        let regionCode = component.count > 1 ? component[1] : "US"
        
        components.queryItems = [
            URLQueryItem(name: "p", value: "Bs2675kDjkb5Ga"),
            URLQueryItem(name: "os", value: osVersion),
            URLQueryItem(name: "lng", value: languageCode),
            URLQueryItem(name: "devicemodel", value: identifier),
            URLQueryItem(name: "country", value: regionCode)
        ]
        
        guard let requestPath = components.url else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        var request = URLRequest(url: requestPath)
        request.timeoutInterval = 30
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data,
                  let responseString = String(data: data, encoding: .utf8) else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            let serverResponse = ServerResponse(rawValue: responseString)
            completion(.success(serverResponse))
        }.resume()
    }
}

enum NetworkError: Error {
    case invalidRequest
    case invalidResponse
}

struct ServerResponse {
    let rawResponse: String
    let token: String?
    let contentPath: String?
    
    init(rawValue: String) {
        self.rawResponse = rawValue
        if rawValue.contains("#") {
            let components = rawValue.components(separatedBy: "#")
            self.token = components.first
            self.contentPath = components.count > 1 ? components[1] : nil
        } else {
            self.token = nil
            self.contentPath = nil
        }
    }
    
    var hasValidContent: Bool {
        return token != nil && contentPath != nil
    }
}

