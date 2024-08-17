import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        let rootVC = isLoggedIn ? CryptoCollectionViewController() : AuthViewController()
        window.rootViewController = UINavigationController(rootViewController: rootVC)
        
        self.window = window
        window.makeKeyAndVisible()
    }
}


