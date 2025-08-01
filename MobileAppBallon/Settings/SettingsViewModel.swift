import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var executedBallons: [BallonModel] = []
    
    func loadExecutedBallons(userId: String) {


        NetworkManager.shared.getBallonsByUser(userId: userId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let ballons):
                    self?.executedBallons = ballons.filter { $0.status == "Executed!" }
                case .failure(let error):
                    self?.executedBallons = []
                }
            }
        }
    }
    
    func deleteAccount(userId: String, completion: @escaping (Bool) -> Void) {
           let params: [String: Any] = [
               "action": "delete_user",
               "data": ["id": userId]
           ]

           guard let url = URL(string: "https://ballondream.space/app.php") else {
               completion(false)
               return
           }

           var request = URLRequest(url: url)
           request.httpMethod = "POST"
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")

           do {
               request.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
           } catch {
               completion(false)
               return
           }

           URLSession.shared.dataTask(with: request) { data, _, error in
               if let error = error {
                   print("Network error: \(error.localizedDescription)")
                   completion(false)
                   return
               }

               guard let data = data else {
                   completion(false)
                   return
               }

               do {
                   if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                       if json["success"] != nil {
                           completion(true)
                       } else if let _error = json["error"] as? String {
                           print("Server error: \(_error)")
                           completion(false)
                       } else {
                           completion(false)
                       }
                   } else {
                       completion(false)
                   }
               } catch {
                   print("JSON parsing error: \(error.localizedDescription)")
                   completion(false)
               }
           }.resume()
       }

}
