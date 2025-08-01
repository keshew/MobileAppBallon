import SwiftUI

@main
struct MobileAppBallonApp: App {
    let userDefaults = UserDefaultsManager()
    var body: some Scene {
        WindowGroup {
            if userDefaults.checkLogin() {
                MainView()
            } else {
                RegistationView()
                    .onAppear() {
                        userDefaults.quitQuest()
                    }
            }
        }
    }
}
