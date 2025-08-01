import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    private let baseURL = URL(string: "https://ballondream.space/app.php")!

    // Универсальный тип ответа для простых сообщений успеха/ошибки
    struct BaseResponse: Decodable {
        let error: String?
        let success: String?
    }

    struct UserResponse: Decodable {
        let id: String?
        let name: String?
        let email: String?
        let error: String?
    }

    struct LoginResponse: Decodable {
        let id: String?
        let name: String?
        let email: String?
        let error: String?
        // Пароль в ответе не приходит — корректно
    }

    struct CreateBallonResponse: Decodable {
        let id: String?
        let userId: String?
        let image: String?
        let title: String?
        let desc: String?
        let status: String?
        let error: String?
    }

    // MARK: - Register user
    func register(name: String, email: String, password: String, completion: @escaping (Result<UserResponse, Error>) -> Void) {
        let params: [String: Any] = [
            "action": "register",
            "name": name,
            "email": email,
            "password": password
        ]
        performRequest(params: params, completion: completion)
    }

    // MARK: - Login user
    func login(email: String, password: String, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        let params: [String: Any] = [
            "action": "login",
            "email": email,
            "password": password
        ]
        performRequest(params: params, completion: completion)
    }

    // MARK: - Create ballon
    func createBallon(userId: String, image: String, title: String, desc: String, status: String, completion: @escaping (Result<CreateBallonResponse, Error>) -> Void) {
        let data: [String: Any] = [
            "userId": userId,
            "image": image,
            "title": title,
            "desc": desc,
            "status": status
        ]
        let params: [String: Any] = [
            "action": "create_ballon",
            "data": data
        ]
        performRequest(params: params, completion: completion)
    }

    // MARK: - Update ballon
    func updateBallon(id: String, image: String, title: String, desc: String, status: String, completion: @escaping (Result<BaseResponse, Error>) -> Void) {
        let data: [String: Any] = [
            "id": id,
            "image": image,
            "title": title,
            "desc": desc,
            "status": status
        ]
        let params: [String: Any] = [
            "action": "update_ballon",
            "data": data
        ]
        performRequest(params: params, completion: completion)
    }

    // MARK: - Delete ballon
    func deleteBallon(id: String, completion: @escaping (Result<BaseResponse, Error>) -> Void) {
        let params: [String: Any] = [
            "action": "delete_ballon",
            "data": ["id": id]
        ]
        performRequest(params: params, completion: completion)
    }

    // MARK: - Delete user
    func deleteUser(id: String, completion: @escaping (Result<BaseResponse, Error>) -> Void) {
        let params: [String: Any] = [
            "action": "delete_user",
            "data": ["id": id]
        ]
        performRequest(params: params, completion: completion)
    }

    // MARK: - Update user
    func updateUser(id: String, name: String?, email: String?, password: String?, completion: @escaping (Result<BaseResponse, Error>) -> Void) {
        var data: [String: Any] = ["id": id]
        if let name = name { data["name"] = name }
        if let email = email { data["email"] = email }
        if let password = password { data["password"] = password }

        let params: [String: Any] = [
            "action": "update_user",
            "data": data
        ]
        performRequest(params: params, completion: completion)
    }

    // MARK: - Функция для отправки POST запроса и декодирования ответа
    private func performRequest<T: Decodable>(params: [String: Any], completion: @escaping (Result<T, Error>) -> Void) {
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async { completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"]))) }
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async { completion(.success(decodedResponse)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }.resume()
    }
    func getBallonsByUser(userId: String, completion: @escaping (Result<[BallonModel], Error>) -> Void) {
         let params: [String: Any] = [
             "action": "get_ballons_by_user",
             "userId": userId
         ]
         performRequest(params: params, completion: completion)
     }
}

// MARK: - Пример моделей


struct UserResponse: Decodable {
    let id: String?
    let name: String?
    let email: String?
    let error: String?
    let success: String?
}

struct BallonModel: Codable, Identifiable {
    let id: String
    let userId: String
    let image: String
    let title: String
    let desc: String
    let status: String
}

struct MessageResponse: Decodable {
    let success: String?
    let error: String?
}
struct User: Codable {
    let id: String
    let name: String
    let email: String
}

// MARK: - Модель для регистрации и редактирования пользователя (запрос)
struct UserRequest: Codable {
    let name: String?
    let email: String?
    let password: String?
    
    // Все поля опциональны чтобы использовать для updateUser где меняют 1 или несколько полей
    // При регистрации обычно передают все 3
}

// MARK: - Модель для входа пользователя (запрос)
struct LoginRequest: Codable {
    let email: String
    let password: String
}

// MARK: - Модель создания шарика (запрос)
struct CreateBallonRequest: Codable {
    let userId: String
    let image: String
    let title: String
    let desc: String
    let status: String
}

// MARK: - Модель редактирования шарика (запрос)
struct UpdateBallonRequest: Codable {
    let id: String
    let image: String
    let title: String
    let desc: String
    let status: String
}

// MARK: - Модель удаления (запрос)
struct DeleteRequest: Codable {
    let id: String
}

// MARK: - Общая модель запроса с action, для удобства можно использовать в NetworkManager
struct APIRequest<T: Codable>: Codable {
    let action: String
    let data: T
}

// MARK: - Общая модель ответа (обычный ответ с сообщением успеха/ошибки либо сущностью)
struct APIResponse<T: Codable>: Codable {
    let success: String?
    let error: String?
    let id: String?
    let name: String?
    let email: String?
    let idDeleted: String? // если надо вернуть id удаленного
    let balloon: BallonModel?
    // Могут быть другие поля в ответе, в зависимости от метода; адаптируйте под нужды
}
