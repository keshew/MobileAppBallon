import Foundation
import Combine

final class EditViewModel: ObservableObject {

    func updateBallon(ballonId: String, image: String, title: String, desc: String, status: String, completion: @escaping (Bool) -> Void) {
        let params: [String: Any] = [
            "action": "update_ballon",
            "data": [
                "id": ballonId,
                "image": image,
                "title": title,
                "desc": desc,
                "status": status
            ]
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
            DispatchQueue.main.async {
                if let error = error {
                    print("Ошибка обновления шарика: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                guard let data = data else {
                    completion(false)
                    return
                }
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       json["success"] != nil {
                        completion(true)
                    } else {
                        completion(false)
                    }
                } catch {
                    completion(false)
                }
            }
        }.resume()
    }
}
