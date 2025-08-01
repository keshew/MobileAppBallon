import Foundation

final class RealizedWishesViewModel: ObservableObject {
    @Published var executedBallons: [BallonModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    func loadExecutedBallons(userId: String) {
        isLoading = true
        errorMessage = nil

        NetworkManager.shared.getBallonsByUser(userId: userId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let ballons):
                    self?.executedBallons = ballons.filter { $0.status == "Executed!" }
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.executedBallons = []
                }
            }
        }
    }
}
