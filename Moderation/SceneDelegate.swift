import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: - UIWindowSceneDelegate

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        let mainView = MainView()
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: mainView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // If the scene entered background more than one day ago,
        // we need to refresh the data manager to shift the calendar forward to the present day.
        if let date = dateSceneEnteredBackground, date.daysFromNow < 0 {
            DataManager.shared.refresh()
        }
        dateSceneEnteredBackground = nil
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        dateSceneEnteredBackground = Date()
    }

    // MARK: - Private

    /// Date value that is stored when the scene enters background.
    private var dateSceneEnteredBackground: Date?
}
