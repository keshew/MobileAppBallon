import Foundation

class EditProfileViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var alertMessage: String?
    @Published var showAlert = false

    func updateUser(userId: String, name: String, email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        isLoading = true

        let params: [String: Any] = [
            "action": "update_user",
            "data": [
                "id": userId,
                "name": name,
                "email": email,
                "password": password
            ]
        ]

        guard let url = URL(string: "https://ballondream.space/app.php") else {
            completion(false, "Invalid server URL")
            isLoading = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            completion(false, "Failed to serialize request data")
            isLoading = false
            return
        }

        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    completion(false, "Network error: \(error.localizedDescription)")
                    return
                }
                guard let data = data else {
                    completion(false, "No data received from server")
                    return
                }

                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {

                        if let errorMsg = json["error"] as? String {
                            completion(false, errorMsg)
                            return
                        }

                        if let successMsg = json["success"] as? String {
                            completion(true, nil)
                        } else {
                            completion(false, "Unexpected server response")
                        }
                    } else {
                        completion(false, "Unable to parse server response")
                    }
                } catch {
                    completion(false, "JSON parsing error: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
}
