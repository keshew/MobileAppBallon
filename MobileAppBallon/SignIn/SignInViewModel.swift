import Foundation

class SignInViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var alertMessage: String?
    @Published var showAlert = false
    
    func login(email: String, password: String, completion: @escaping (Bool) -> Void) {
        guard !email.isEmpty, !password.isEmpty else {
            alertMessage = "All fields must be filled"
            showAlert = true
            completion(false)
            return
        }
        
        isLoading = true
        
        let params: [String: Any] = [
            "action": "login",
            "email": email,
            "password": password
        ]
        
        guard let url = URL(string: "https://ballondream.space/app.php") else {
            self.isLoading = false
            alertMessage = "Invalid server URL"
            showAlert = true
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            self.isLoading = false
            alertMessage = "Failed to serialize request data"
            showAlert = true
            completion(false)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.alertMessage = "Network error: \(error.localizedDescription)"
                    self.showAlert = true
                    completion(false)
                    return
                }
                guard let data = data else {
                    self.alertMessage = "No data received from server"
                    self.showAlert = true
                    completion(false)
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let errorMsg = json["error"] as? String {
                            self.alertMessage = errorMsg
                            self.showAlert = true
                            completion(false)
                            return
                        }
                        if let userId = json["id"] as? String,
                           let name = json["name"] as? String,
                           let emailFromResponse = json["email"] as? String {
                            UserDefaultsManager.shared.saveUserId(userId)
                            UserDefaultsManager.shared.saveName(name)
                            UserDefaultsManager.shared.saveEmail(emailFromResponse)
                            UserDefaultsManager.shared.saveLoginStatus(true)
                            
                            completion(true)
                        } else {
                            self.alertMessage = "Invalid response data"
                            self.showAlert = true
                            completion(false)
                        }
                    } else {
                        self.alertMessage = "Unable to parse server response"
                        self.showAlert = true
                        completion(false)
                    }
                } catch {
                    self.alertMessage = "JSON parsing error: \(error.localizedDescription)"
                    self.showAlert = true
                    completion(false)
                }
            }
        }.resume()
    }
}
