import SwiftUI

struct EditView: View {
    @StateObject var editModel =  EditViewModel()
    @State var back = false
    @State var isDone = false
    @State var ballon: BallonModel
@State var text = ""
    @State var title = ""
    var body: some View {
        ZStack {
            Image(.back)
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button(action: {
                        back = true
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                    
                    Spacer()
                    
                    Text("Wish map")
                        .Pro(size: 24)
                        .padding(.trailing, 15)
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                Rectangle()
                    .fill(Color(red: 32/255, green: 145/255, blue: 236/255).opacity(0.25))
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(red: 127/255, green: 228/255, blue: 245/255), lineWidth: 1.5)
                            .overlay {
                                Text("First Flight")
                                    .Pro(size: 17, color: .white)
                            }
                    }
                    .frame(width: 100, height: 45)
                    .cornerRadius(16)
                    .padding(.top, 10)
                
                Image(ballon.image)
                    .resizable()
                    .frame(width: 190, height: 225)
                    .scaleEffect(x: -1, y: 1)
                    .padding(.top, 30)
                
                Spacer()
                
                Rectangle()
                    .fill(.white.opacity(0.5))
                    .frame(height: 400)
                    .cornerRadius(40)
                    .overlay {
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(.white, lineWidth: 2)
                            .overlay {
                                VStack {
                                    Rectangle()
                                        .fill(.gray.opacity(0.5))
                                        .frame(width: 110, height: 5)
                                        .cornerRadius(20)
                                    
                                    CustomTextView3(text: $text, title: $title, placeholder: "Write a wish on a balloon and release it high up to make it come true!", placeholderTitle: "Title wish", width: 320)
                                    
                                    HStack {
                                        Text("Status:")
                                            .Pro(size: 18, color: .black)
                                        
                                        Button(action: {
                                            withAnimation {
                                                isDone = false
                                            }
                                        }) {
                                            Rectangle()
                                                .fill(.clear)
                                                .overlay {
                                                    RoundedRectangle(cornerRadius: 30)
                                                        .stroke(isDone ? .black.opacity(0.3) : .black, lineWidth: 2)
                                                        .overlay {
                                                            Text("thinking about it")
                                                                .Pro(size: 14, color: isDone ? .black.opacity(0.3) : .black)
                                                        }
                                                }
                                                .frame(width: 130, height: 30)
                                                .cornerRadius(30)
                                        }
                                        
                                        Button(action: {
                                            withAnimation {
                                                isDone = true
                                            }
                                        }) {
                                            Rectangle()
                                                .fill(.clear)
                                                .overlay {
                                                    RoundedRectangle(cornerRadius: 30)
                                                        .stroke(!isDone ? .black.opacity(0.3) : .black, lineWidth: 2)
                                                        .overlay {
                                                            Text("Executed!")
                                                                .Pro(size: 14, color: !isDone ? .black.opacity(0.3) : .black)
                                                        }
                                                }
                                                .frame(width: 100, height: 30)
                                                .cornerRadius(30)
                                        }
                                    }
                                    .padding(.top, 40)
                                    
                                    Button(action: {
                                        saveChanges()
                                    }) {
                                        Rectangle()
                                            .fill(Color(red: 247/255, green: 213/255, blue: 44/255))
                                            .overlay {
                                                Text("Save")
                                                    .Pro(size: 19, color: .black)
                                            }
                                            .frame(height: 50)
                                            .cornerRadius(12)
                                            .padding(.horizontal, 100)
                                    }
                                    .padding(.top)
                                    
                                    Spacer()
                                }
                                .padding()
                            }
                    }
                    .offset(y: 50)
            }
        }
        .onAppear {
            isDone = ballon.status == "Executed!"
            text = ballon.desc
            title = ballon.title
        }
        .fullScreenCover(isPresented: $back) {
            WishMapView()
        }
    }
    
    private func saveChanges() {
        editModel.updateBallon(
            ballonId: ballon.id,
            image: ballon.image,
            title: title,
            desc: text,
            status: isDone ? "Executed!" : "thinking about it"
        ) { success in
            if success {
                back = true
            } else {
                print("Ошибка сохранения шарика")
            }
        }
    }
}

#Preview {
    EditView(ballon: BallonModel(id: "", userId: "", image: "", title: "123123123", desc: "thinkingthinkingthinkingthinkingthinkingthinkingthinkingthinking", status: ""))
}

