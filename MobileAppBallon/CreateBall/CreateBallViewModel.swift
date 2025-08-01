import SwiftUI
import Combine

class CreateBallViewModel: ObservableObject {
    @Published var ballons: [BallonModel] = []
    @Published var back = false

    private var cancellables = Set<AnyCancellable>()
    
    func saveBallon(title: String, desc: String) {
        let array = ["createBall1", "createBall2", "createBall3", "createBall4"].randomElement()!
        NetworkManager.shared.createBallon(
            userId: "\(UserDefaultsManager().getUserId() ?? "" )",
            image: array,
            title: title,
            desc: desc,
            status: "thinking about it"
        ) { [weak self] result in
            switch result {
            case .success(let ballonResponse):
                if let id = ballonResponse.id {
                    let newBallon = BallonModel(
                        id: id,
                        userId: ballonResponse.userId ?? "",
                        image: ballonResponse.image ?? "",
                        title: ballonResponse.title ?? "",
                        desc: ballonResponse.desc ?? "",
                        status: ballonResponse.status ?? ""
                    )
                    DispatchQueue.main.async {
                        self?.ballons.append(newBallon)
                        self?.back = true
                    }
                }
            case .failure(let error):
                print("Ошибка сети при сохранении шарика: \(error.localizedDescription)")
            }
        }
    }
}
