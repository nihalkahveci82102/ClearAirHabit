import SwiftUI
import UIKit

class OrientationManager {
    static let shared = OrientationManager()
    
    weak var appDelegate: AppDelegate?
    
    private init() {}
    
    func lockToPortrait() {
        guard let delegate = appDelegate else { return }
        delegate.orientationLock = .portrait
        
        if #available(iOS 16.0, *) {
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))
        } else {
            UIViewController.attemptRotationToDeviceOrientation()
        }
    }
    
    func unlockAllOrientations() {
        guard let delegate = appDelegate else { return }
        delegate.orientationLock = .allButUpsideDown
        
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                return
            }
            
            if #available(iOS 16.0, *) {
                windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .allButUpsideDown)) { _ in }
            }
            
            windowScene.windows.first?.rootViewController?.setNeedsUpdateOfSupportedInterfaceOrientations()
            
            UIView.setAnimationsEnabled(false)
            windowScene.windows.forEach { window in
                window.rootViewController?.view.setNeedsLayout()
                window.rootViewController?.view.layoutIfNeeded()
            }
            UIView.setAnimationsEnabled(true)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    var orientationLock = UIInterfaceOrientationMask.portrait
    
    override init() {
        super.init()
        OrientationManager.shared.appDelegate = self
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return orientationLock
    }
}
