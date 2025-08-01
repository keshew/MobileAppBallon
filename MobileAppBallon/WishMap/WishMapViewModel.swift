import Foundation
import Combine

final class WishMapViewModel: ObservableObject {
    @Published var ballons: [BallonModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    func loadBallons(userId: String) {
        isLoading = true
        errorMessage = nil
        
        NetworkManager.shared.getBallonsByUser(userId: userId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let ballons):
                    self?.ballons = ballons
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.ballons = []
                }
            }
        }
    }
    func deleteBallon(id: String) {
         isLoading = true
         errorMessage = nil
         
         NetworkManager.shared.deleteBallon(id: id) { [weak self] result in
             DispatchQueue.main.async {
                 self?.isLoading = false

                 switch result {
                 case .success(_):
                     self?.ballons.removeAll { $0.id == id }
                     self?.loadBallons(userId: "\(UserDefaultsManager().getUserId() ?? "" )")
                 case .failure(let error):
                     self?.errorMessage = error.localizedDescription
                 }
             }
         }
     }
}
