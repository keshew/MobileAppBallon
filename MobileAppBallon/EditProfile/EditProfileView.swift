import SwiftUI

struct EditProfileView: View {
    @StateObject var editProfileModel =  EditProfileViewModel()
    @State var name = UserDefaultsManager.shared.getName() ?? ""
    @State var email = UserDefaultsManager.shared.getEmail() ?? ""
    @State var password = ""
    @State var next = false
    @State var back = false
    var body: some View {
        ZStack {
            Color(red: 0/255, green: 157/255, blue: 255/255)
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Edit settings")
                                .ProBold(size: 32)

                            Text("Change your data")
                                .Pro(size: 18, color: .white.opacity(0.75))
                        }

                        Spacer()
                    }
                    .padding(.horizontal)

                    Image(.signin)
                        .resizable()
                        .frame(height: 260)

                    VStack(spacing: 15) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("What's your name?")
                                .Pro(size: 16)
                                .padding(.horizontal)

                            CustomTextFiled(text: $name, placeholder: "Your name")
                        }

                        VStack(alignment: .leading, spacing: 5) {
                            Text("What's your new e-mail address?")
                                .Pro(size: 16)
                                .padding(.horizontal)

                            CustomTextFiled(text: $email, placeholder: "Your e-mail")
                        }
                    }

                    VStack(spacing: 10) {
                        Button(action: {
                            updateUser()
                        }) {
                            Rectangle()
                                .fill(Color(red: 247/255, green: 213/255, blue: 44/255))
                                .overlay {
                                    Text("Save")
                                        .Pro(size: 19, color: .black)
                                }
                                .frame(height: 50)
                                .cornerRadius(12)
                                .padding(.horizontal)
                        }
                        .disabled(editProfileModel.isLoading)
                        
                        Button(action: {
                            back = true
                        }) {
                            Rectangle()
                                .fill(.clear)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(.white, lineWidth: 2)
                                    
                                    Text("Back")
                                        .Pro(size: 19)
                                }
                                .frame(height: 50)
                                .cornerRadius(12)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.top)
                }
                .padding(.top)
            }
        }
        .fullScreenCover(isPresented: $next) {
            MainView()
        }
        
        .fullScreenCover(isPresented: $back) {
            MainView()
        }
        
        .alert(editProfileModel.alertMessage ?? "", isPresented: $editProfileModel.showAlert) {
            Button("OK", role: .cancel) {}
        }
        .overlay {
            if editProfileModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(2)
            }
        }
    }


    private func updateUser() {
        guard let userId = UserDefaultsManager.shared.getUserId() else {
            editProfileModel.alertMessage = "User ID not found"
            editProfileModel.showAlert = true
            return
        }
        
        let currentName = UserDefaultsManager.shared.getName() ?? ""
        let currentEmail = UserDefaultsManager.shared.getEmail() ?? ""
        
        let currentPassword = UserDefaultsManager.shared.getPassword() ?? ""
        
        let nameToUpdate = name.isEmpty ? currentName : name
        let emailToUpdate = email.isEmpty ? currentEmail : email
        
        let passwordToUpdate: String?
        if password.isEmpty {
            passwordToUpdate = currentPassword.isEmpty ? nil : currentPassword
        } else {
            passwordToUpdate = password
        }
        
        if nameToUpdate.isEmpty || emailToUpdate.isEmpty {
            editProfileModel.alertMessage = "Name and Email cannot be empty"
            editProfileModel.showAlert = true
            return
        }
        
        editProfileModel.updateUser(userId: userId, name: nameToUpdate, email: emailToUpdate, password: passwordToUpdate ?? "") { success, error in
            if success {
                UserDefaultsManager.shared.saveName(nameToUpdate)
                UserDefaultsManager.shared.saveEmail(emailToUpdate)
                
                next = true
            } else {
                editProfileModel.alertMessage = error ?? "Unknown error"
                editProfileModel.showAlert = true
            }
        }
    }

}

#Preview {
    EditProfileView()
}

