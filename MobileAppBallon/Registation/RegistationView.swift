import SwiftUI

struct RegistationView: View {
    @StateObject var registationModel =  RegistationViewModel()
    @State var name = ""
    @State var email = ""
    @State var password = ""
    @State var next = false
    @State var log = false
    var body: some View {
        ZStack {
            Color(red: 0/255, green: 157/255, blue: 255/255)
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Registration")
                                .ProBold(size: 32)
                            
                            Text("Do a quick registration  to save  your progress")
                                .Pro(size: 18, color: .white.opacity(0.75))
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    Image(.registation)
                        .resizable()
                        .frame(height: 140)
                    
                    VStack(spacing: 15) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("What's your name?")
                                .Pro(size: 16)
                                .padding(.horizontal)
                            
                            CustomTextFiled(text: $name, placeholder: "Your name")
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("What's your e-mail adress?")
                                .Pro(size: 16)
                                .padding(.horizontal)
                            
                            CustomTextFiled(text: $email, placeholder: "Your e-mail")
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Make up and remember your password")
                                .Pro(size: 16)
                                .padding(.horizontal)
                            
                            CustomSecureField(text: $password, placeholder: "Your password")
                        }
                    }
                    
                    VStack(spacing: 10) {
                        Button(action: {
                            registationModel.register(name: name, email: email, password: password) { success in
                                if success {
                                    next = true
                                }
                            }
                        }) {
                            Rectangle()
                                .fill(Color(red: 247/255, green: 213/255, blue: 44/255))
                                .overlay {
                                    Text("Registation")
                                        .Pro(size: 19, color: .black)
                                }
                                .frame(height: 50)
                                .cornerRadius(12)
                                .padding(.horizontal)
                        }
                        
                        Button(action: {
                            next = true
                            UserDefaultsManager().enterAsGuest()
                        }) {
                            Rectangle()
                                .fill(.clear)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(.white, lineWidth: 2)
                                    
                                    Text("I'm a guest")
                                        .Pro(size: 19)
                                }
                                .frame(height: 50)
                                .cornerRadius(12)
                                .padding(.horizontal)
                        }
                        
                        Button(action: {
                            log = true
                        }) {
                            Text("I already have an account, sign in.")
                                .Pro(size: 16)
                                .underline()
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
        .fullScreenCover(isPresented: $log) {
            SignInView()
        }
        .alert("Error", isPresented: $registationModel.showAlert) {
            Text("\(registationModel.alertMessage ?? "Error")")
                .ProBold(size: 18)
            
            Button("OK", role: .cancel) {}
          
        }
    }
}

#Preview {
    RegistationView()
}

struct CustomTextFiled: View {
    @Binding var text: String
    @FocusState var isTextFocused: Bool
    var placeholder: String
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(Color(red: 191/255, green: 231/255, blue: 255/255))
                .frame(height: 50)
                .cornerRadius(12)
                .padding(.horizontal)
            
            TextField("", text: $text, onEditingChanged: { isEditing in
                if !isEditing {
                    isTextFocused = false
                }
            })
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .frame(height: 47)
            .font(.custom("SFProDisplay-Regular", size: 15))
            .cornerRadius(9)
            .foregroundStyle(.black.opacity(0.5))
            .focused($isTextFocused)
            .padding(.horizontal, 35)
            
            if text.isEmpty && !isTextFocused {
                Text(placeholder)
                    .Pro(size: 16, color: .black.opacity(0.5))
                    .frame(height: 50)
                    .padding(.leading, 30)
                    .onTapGesture {
                        isTextFocused = true
                    }
            }
        }
    }
}

struct CustomSecureField: View {
    @Binding var text: String
    @FocusState var isTextFocused: Bool
    var placeholder: String
    
    @State private var isSecure: Bool = true
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(Color(red: 191/255, green: 231/255, blue: 255/255))
                .frame(height: 50)
                .cornerRadius(12)
                .padding(.horizontal)
            
            HStack {
                if isSecure {
                    SecureField("", text: $text)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .font(.custom("SFProDisplay-Regular", size: 16))
                        .foregroundStyle(.black.opacity(0.5))
                        .focused($isTextFocused)
                } else {
                    TextField("", text: $text)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .font(.custom("SFProDisplay-Regular", size: 16))
                        .foregroundStyle(.black.opacity(0.5))
                        .focused($isTextFocused)
                }
            }
            .padding(.horizontal, 35)
            .frame(height: 50)
            .cornerRadius(9)
            
            if text.isEmpty && !isTextFocused {
                Text(placeholder)
                    .font(.custom("SFProDisplay-Regular", size: 16))
                    .foregroundColor(.black.opacity(0.5))
                    .frame(height: 50)
                    .padding(.leading, 30)
                    .onTapGesture {
                        isTextFocused = true
                    }
            }
        }
    }
}
