import SwiftUI

struct MainView: View {
    @State var isAnim = false
    @State var isSettings = false
    @State var wishMap = false
    
    var body: some View {
        ZStack {
            Color(red: 0/255, green: 157/255, blue: 255/255)
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Hello, \(UserDefaultsManager().getName() ?? "Guest")!")
                        .ProBold(size: 32)
                        .padding(.trailing, 15)
                    
                    Spacer()
                    
                    Button(action: {
                        isSettings = true
                    }) {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                }
                .padding(.horizontal)
                
                Image(.mainBall)
                    .resizable()
                    .frame(height: 380)
                
                Spacer()
                
                Text("Write a wish on a balloon  and release it high up in the air  to make it come true!")
                    .Pro(size: 24)
                    .multilineTextAlignment(.center)
                
                VStack(spacing: 25) {
                    if !UserDefaultsManager().isGuest() {
                        Button(action: {
                            isAnim = true
                        }) {
                            Image(.addBtn)
                                .resizable()
                                .frame(width: 100, height: 100)
                        }
                    }
                    
                    Button(action: {
                        wishMap = true
                    }) {
                        Rectangle()
                            .fill(Color(red: 247/255, green: 213/255, blue: 44/255))
                            .overlay {
                                Text("Wish map")
                                    .Pro(size: 19, color: .black)
                            }
                            .frame(height: 50)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                }
                .padding(.top)
            }
            .padding(.vertical)
            
            if isAnim {
                AnimatonView()
                    .ignoresSafeArea()
            }
        }
        .fullScreenCover(isPresented: $isSettings) {
            SettingsView()
        }
        .fullScreenCover(isPresented: $wishMap) {
            WishMapView()
        }
    }
}

#Preview {
    MainView()
}

struct AnimatonView: View {
    @State private var ballOpacity = 0.0
    @State private var ballOffset = CGSize.zero
    @State private var ballFlewUp = false
    
    var body: some View {
        ZStack {
            Image("back")
                .resizable()
                .ignoresSafeArea()
            
            Image("yelowBall")
                .resizable()
                .frame(width: 180, height: 190)
                .opacity(ballOpacity)
                .offset(ballOffset)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.0)) {
                        ballOpacity = 1.0
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        withAnimation(.easeInOut(duration: 1)) {
                            ballOffset = CGSize(width: 0, height: -UIScreen.main.bounds.height)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                ballFlewUp = true
                            }
                        }
                    }
                }
        }
        .fullScreenCover(isPresented: $ballFlewUp) {
            CreateBallonView()
        }
    }
}

struct CustomTextView2: View {
    @FocusState var isTextFocused: Bool
    var placeholder: String
    var height: CGFloat = 120
    var width: CGFloat = 230
    var body: some View {
        ZStack(alignment: .leading) {
            Image(.note)
                .resizable()
                .overlay {
                    VStack(spacing: 14) {
                        ForEach(0..<5) { index in
                            Rectangle()
                                .fill(Color.black.opacity(0.5))
                                .frame(height: 1)
                                .padding(.horizontal)
                        }
                    }
                    .offset(y: 8)
                }
                .padding(.horizontal)
                .offset(y: 20)
            
            VStack {
                Text(placeholder)
                    .Pro(size: 14, color: .black)
                    .padding(.horizontal, 15)
                    .padding(.horizontal)
                    .padding(.top, 40)
                    .onTapGesture {
                        isTextFocused = true
                    }
                Spacer()
            }
            
        }
        .frame(width: width, height: height)
    }
}
