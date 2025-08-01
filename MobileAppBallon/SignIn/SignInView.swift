import SwiftUI

struct SignInView: View {
    @StateObject var signInModel =  SignInViewModel()
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
                            Text("Sign In")
                                .ProBold(size: 32)
                            
                            Text("Log in to get back to your progress")
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
                            signInModel.login(email: email, password: password) { success in
                                if success {
                                    next = true
                                }
                            }
                        }) {
                            Rectangle()
                                .fill(Color(red: 247/255, green: 213/255, blue: 44/255))
                                .overlay {
                                    Text("Sign In")
                                        .Pro(size: 19, color: .black)
                                }
                                .frame(height: 50)
                                .cornerRadius(12)
                                .padding(.horizontal)
                        }
                        
                        Button(action: {
                            log = true
                        }) {
                            Rectangle()
                                .fill(.clear)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(.white, lineWidth: 2)
                                    
                                    Text("Registration")
                                        .Pro(size: 19)
                                }
                                .frame(height: 50)
                                .cornerRadius(12)
                                .padding(.horizontal)
                        }
                        
                        Button(action: {
                            log = true
                        }) {
                            Text("Forgot my password")
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
            RegistationView()
        }
    }
}

#Preview {
    SignInView()
}

