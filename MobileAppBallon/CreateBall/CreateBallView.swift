import SwiftUI

struct CreateBallView: View {
    @StateObject var createBallModel = CreateBallViewModel()
    @State private var selectedColorIndex: Int? = nil
    @State private var text = ""
    @State private var title = ""
    
    @State private var showAlert = false

    var colors = [
        Color(red: 248/255, green: 152/255, blue: 3/255),
        Color(red: 250/255, green: 72/255, blue: 69/255),
        Color(red: 58/255, green: 216/255, blue: 160/255),
        Color(red: 84/255, green: 57/255, blue: 216/255),
        Color(red: 216/255, green: 57/255, blue: 163/255)
    ]
    
    var body: some View {
        ZStack {
            Image(.back)
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                Image(.createBall)
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width, height: 430)
                    .overlay {
                        CustomTextView3(text: $text, title: $title, placeholder: "Write a wish on a balloon and release it high up to make it come true!", placeholderTitle: "Title wish")
                    }
                
                Spacer()
                
                HStack(spacing: 25) {
                    Rectangle()
                        .fill(Color.white.opacity(0.25))
                        .overlay {
                            RoundedRectangle(cornerRadius: 22)
                                .stroke(Color(red: 127/255, green: 228/255, blue: 245/255), lineWidth: 1.5)
                                .overlay {
                                    HStack(spacing: 14) {
                                        ForEach(colors.indices, id: \.self) { index in
                                            Circle()
                                                .fill(colors[index])
                                                .frame(width: selectedColorIndex == index ? 33 : 28,
                                                       height: selectedColorIndex == index ? 33 : 28)
                                                .overlay(
                                                    Circle()
                                                        .stroke(Color.white, lineWidth: selectedColorIndex == index ? 2 : 0)
                                                )
                                                .onTapGesture {
                                                    selectedColorIndex = index
                                                }
                                        }
                                    }
                                    .padding(10)
                                }
                        }
                        .frame(height: 50)
                        .cornerRadius(22)
                    
                    Button(action: {
                        if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                            text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            showAlert = true
                        } else {
                            createBallModel.saveBallon(
                                title: title,
                                desc: text)
                        }
                    }) {
                        Rectangle()
                            .fill(Color.clear)
                            .overlay {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white, lineWidth: 2)
                                Text("Ok")
                                    .Pro(size: 19)
                            }
                            .frame(width: 100, height: 50)
                            .cornerRadius(12)
                    }
                }
                .padding(.top)
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Error"),
                message: Text("Please fill all fields"),
                dismissButton: .default(Text("OK"))
            )
        }
        .fullScreenCover(isPresented: $createBallModel.back) {
            WishMapView()
        }
    }
}


#Preview {
    CreateBallView()
}

