import SwiftUI

struct SettingsView: View {
    @StateObject var settingsModel =  SettingsViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State var edit = false
    @State var see = false
    @State var quit = false
    @State private var showDeleteAccountAlert = false

    
    var body: some View {
        ZStack {
            Image(.back)
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                    
                    Spacer()
                    
                    Text("Settings")
                        .Pro(size: 24)
                        .padding(.trailing, 15)
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                VStack {
                    Rectangle()
                        .fill(Color(red: 32/255, green: 145/255, blue: 216/255).opacity(0.25))
                        .overlay {
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color(red: 127/255, green: 228/255, blue: 245/255), lineWidth: 1.5)
                                .overlay {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 5) {
                                            Text(UserDefaultsManager().isGuest() ? "Guest" : "\(UserDefaultsManager().getName() ?? "")")
                                                .ProBold(size: 18)
                                            
                                            Text(UserDefaultsManager().isGuest() ? "Guest Email" : "\(UserDefaultsManager().getEmail() ?? "")")
                                                .Pro(size: 14, color: .white.opacity(0.75))
                                        }
                                        .padding(.leading, 5)
                                        
                                        Spacer()
                                        
                                        if !UserDefaultsManager().isGuest() {
                                            Button(action: {
                                                edit = true
                                            }) {
                                                Image("pencil")
                                                    .resizable()
                                                    .frame(width: 23, height: 23)
                                                    .padding(.trailing)
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                        }
                        .frame(height: 90)
                        .cornerRadius(25)
                        .padding(.horizontal)
                    
                    Rectangle()
                        .fill(Color(red: 32/255, green: 145/255, blue: 216/255).opacity(0.25))
                        .overlay {
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color(red: 127/255, green: 228/255, blue: 245/255), lineWidth: 1.5)
                                .overlay {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 5) {
                                            Text("Realized wishes")
                                                .ProBold(size: 18)
                                            
                                            Text("You've realized \(settingsModel.executedBallons.count) wishes")
                                                .Pro(size: 14, color: .white.opacity(0.75))
                                        }
                                        .padding(.leading, 5)
                                        
                                        Spacer()
                                        
                                        if !UserDefaultsManager().isGuest() {
                                            Button(action: {
                                                see = true
                                            }) {
                                                Image("eye")
                                                    .resizable()
                                                    .frame(width: 30, height: 20)
                                                    .padding(.trailing)
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                        }
                        .frame(height: 90)
                        .cornerRadius(25)
                        .padding(.horizontal)
                }
                .padding(.top)
                
                Spacer()
                
                VStack(spacing: 10) {
                    Button(action: {
                        UserDefaultsManager().saveLoginStatus(false)
                        UserDefaultsManager().resetAllData()
                        quit = true
                        
                        if UserDefaultsManager().isGuest() {
                            UserDefaultsManager().quitQuest()
                        }
                    }) {
                        Rectangle()
                            .fill(Color(red: 247/255, green: 213/255, blue: 44/255))
                            .overlay {
                                Text("Log out")
                                    .Pro(size: 19, color: .black)
                            }
                            .frame(height: 50)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                    
                    if !UserDefaultsManager().isGuest() {
                        Button(action: {
                            showDeleteAccountAlert = true
                        }) {
                            Rectangle()
                                .fill(.clear)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(.white, lineWidth: 2)
                                    
                                    Text("Delete account")
                                        .Pro(size: 19)
                                }
                                .frame(height: 50)
                                .cornerRadius(12)
                                .padding(.horizontal)
                        }
                    }
                }
            }
            .padding(.vertical)
        }
        .fullScreenCover(isPresented: $quit) {
            RegistationView()
        }
        .fullScreenCover(isPresented: $see) {
            RealizedWishesView()
        }
        .fullScreenCover(isPresented: $edit) {
            EditProfileView()
        }
        .alert("Are you sure you want to delete your account?", isPresented: $showDeleteAccountAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                deleteAccount()
            }
        }
        .onAppear() {
            settingsModel.loadExecutedBallons(userId: "\(UserDefaultsManager().getUserId() ?? "")")
        }
    }
    
    private func deleteAccount() {
        guard let userId = UserDefaultsManager.shared.getUserId() else {
            return
        }

        settingsModel.deleteAccount(userId: userId) { success in
            DispatchQueue.main.async {
                if success {
                    UserDefaultsManager().resetAllData()
                    UserDefaultsManager.shared.resetAllData()
                    UserDefaultsManager.shared.saveLoginStatus(false)
                    quit = true
                }
            }
        }
    }

}

#Preview {
    SettingsView()
}


