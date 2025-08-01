import SwiftUI

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private let lastVisitDateKey = "lastVisitDate"
    private let consecutiveDaysKey = "consecutiveDays"
    
    func enterAsGuest() {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "guest")
    }
   
    func saveName(_ name: String) {
        let defaults = UserDefaults.standard
        defaults.set(name, forKey: "name")
    }
    
    func getName() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: "name")
    }
    
    func saveEmail(_ email: String) {
        let defaults = UserDefaults.standard
        defaults.set(email, forKey: "email")
    }
    
    func getEmail() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: "email")
    }
    
    func savePassword(_ email: String) {
        let defaults = UserDefaults.standard
        defaults.set(email, forKey: "password")
    }
    
    func getPassword() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: "password")
    }
    
    func saveUserId(_ userId: String) {
        let defaults = UserDefaults.standard
        defaults.set(userId, forKey: "userId")
    }
    
    func getUserId() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: "userId")
    }
    
    func isGuest() -> Bool {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: "guest")
    }
    
    func quitQuest() {
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: "guest")
    }
    
    func checkLogin() -> Bool {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: "isLoggedIn")
    }
    
    func saveLoginStatus(_ isLoggedIn: Bool) {
        let defaults = UserDefaults.standard
        defaults.set(isLoggedIn, forKey: "isLoggedIn")
    }

}

extension UserDefaultsManager {
    func resetAllData() {
        let defaults = UserDefaults.standard
        
        defaults.removeObject(forKey: "guest")
        defaults.removeObject(forKey: "name")
        defaults.removeObject(forKey: "isLoggedIn")
        defaults.removeObject(forKey: "email")
        defaults.removeObject(forKey: "userId")
        defaults.removeObject(forKey: "lastVisitDate")
        defaults.removeObject(forKey: "consecutiveDays")
        defaults.removeObject(forKey: "coin")
        defaults.removeObject(forKey: "exploredCount")
        defaults.removeObject(forKey: "lastBonusDate")
        
        defaults.synchronize()
    }
}
