import SwiftUI

struct PasswordRecoveryView: View {
    @State var currentIndex = 0
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        ZStack {
            Color(red: 0/255, green: 157/255, blue: 255/255)
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Password\nRecovery")
                            .ProBold(size: 32)
                        
                        Text("Enter your e-mail address and you will\nreceive a link to create a new password")
                            .Pro(size: 18, color: .white.opacity(0.75))
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                Image(.passwordrecovery)
                    .resizable()
                    .frame(height: 250)
                
                Spacer()
                
                VStack(spacing: 15) {
                    if currentIndex == 0 {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("What's your e-mail adress?")
                                .Pro(size: 16)
                                .padding(.horizontal)
                            
                            CustomTextFiled(text: $email, placeholder: "Your e-mail")
                        }
                    }
                    if currentIndex == 2 {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Make up and remember your password")
                                .Pro(size: 16)
                                .padding(.horizontal)
                            
                            CustomSecureField(text: $password, placeholder: "Your password")
                        }
                    }
                }
                .padding(.bottom, 25)
                
                VStack(spacing: 10) {
                    Button(action: {
                        withAnimation {
                            currentIndex += 1
                        }
                    }) {
                        Rectangle()
                            .fill(Color(red: 247/255, green: 213/255, blue: 44/255))
                            .overlay {
                                Text(currentIndex == 0 ? "Send link" : currentIndex == 1 ? "Check email" : "Next")
                                    .Pro(size: 19, color: .black)
                            }
                            .frame(height: 50)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                    
                    if currentIndex != 2 {
                        Button(action: {
                            
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
                }
            }
            .padding(.vertical)
        }
    }
}

#Preview {
    PasswordRecoveryView()
}

