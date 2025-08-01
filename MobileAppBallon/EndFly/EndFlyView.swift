import SwiftUI

struct EndFlyView: View {
    @Binding var metres: Int
    let array = ["Wow—%@ meters! Your balloon’s flight means your wish is soaring!",
                 "Your balloon reached %@ m—believe it: your wish is on its way!",
                 "%@ meters up! The sky’s the limit for your wish!",
                 "Your balloon climbed %@ m—trust that your dream will follow!",
                 "%@ m in the air! The stars are aligning for your wish.",
                 "Your balloon drifted %@ m—here’s to your desire taking flight!",
                 "%@ meters achieved! Good luck—your wish is destined to happen.",
                 "Your balloon flew %@ m—your wish is flying right along!",
                 "%@ m and counting—your goal (and your wish) is within reach!",
                 "Your balloon soared %@ m. Keep the faith—your wish awaits!",
                 "%@ m aloft! May your wish lift you just as high.",
                 "Your balloon made %@ m—your desire is already airborne!",
                 "%@ m up—trust the journey; your wish will land true.",
                 "Your balloon flew %@ m! The universe is listening—make that wish"]
    
    @State var back = false
    @State var create = false
    
    var message: String {
        let format = array.randomElement() ?? "Your balloon flew %@ meters!"
        return String(format: format, "\(metres)")
    }
    
    var body: some View {
        ZStack {
            Image(.back)
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                ZStack {
                    Image(.ball3)
                        .resizable()
                        .frame(width: 70, height: 70)
                        .offset(x: 120, y: -80)
                    
                    Image(.ball4)
                        .resizable()
                        .frame(width: 80, height: 80)
                        .offset(x: 150, y: -90)
                    
                    Rectangle()
                        .fill(Color(red: 32/255, green: 145/255, blue: 216/255).opacity(0.55))
                        .overlay {
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color(red: 127/255, green: 228/255, blue: 245/255), lineWidth: 1.5)
                                .overlay {
                                    VStack(spacing: 10) {
                                        Text("\(metres)m")
                                            .ProBold(size: 40)
                                        
                                        Text(message)
                                            .Pro(size: 15)
                                            .multilineTextAlignment(.center)
                                    }
                                    .padding(.horizontal)
                                    
                                }
                        }
                        .frame(height: 150)
                        .cornerRadius(25)
                        .padding(.horizontal, 30)
                    
                    Image(.ball1)
                        .resizable()
                        .frame(width: 80, height: 80)
                        .offset(x: -150, y: 70)
                    
                    Image(.ball2)
                        .resizable()
                        .frame(width: 60, height: 60)
                        .offset(x: -120, y: 90)
                }
                
                Spacer()
                
                VStack {
                    Button(action: {
                        create = true
                    }) {
                        Rectangle()
                            .fill(Color(red: 247/255, green: 213/255, blue: 44/255))
                            .overlay {
                                Text("Make another wish")
                                    .Pro(size: 19, color: .black)
                            }
                            .frame(height: 50)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                    
                    Button(action: {
                        back = true
                    }) {
                        Rectangle()
                            .fill(.clear)
                            .overlay {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(.white, lineWidth: 2)
                                
                                Text("Return to main page")
                                    .Pro(size: 19)
                            }
                            .frame(height: 50)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical)
        }
        .fullScreenCover(isPresented: $back) {
            MainView()
        }
        
        .fullScreenCover(isPresented: $create) {
            CreateBallonView()
        }
    }
}

#Preview {
    EndFlyView(metres: .constant(123))
}

