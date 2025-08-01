import SwiftUI

struct CreateBallonView: View {
    @State private var selectedColorIndex: Int? = nil
    @State private var text = ""
    @State private var isNext = false
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
                        CustomTextView(text: $text, placeholder: "Write a wish on a balloon and release it high up to make it come true!")
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
                        isNext = true
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
        .fullScreenCover(isPresented: $isNext) {
            PushBallView(textPlaceholer: $text)
        }
    }
}


#Preview {
    CreateBallonView()
}

struct CustomTextView: View {
    @Binding var text: String
    @FocusState var isTextFocused: Bool
    var placeholder: String
    var height: CGFloat = 150
    var width: CGFloat = 270
    var body: some View {
        ZStack(alignment: .leading) {
            Image(.note)
                .resizable()
                .overlay {
                    VStack(spacing: 15) {
                        ForEach(0..<7) { index in
                            Rectangle()
                                .fill(Color.black.opacity(0.5))
                                .frame(height: 1)
                                .padding(.horizontal)
                        }
                    }
                    .offset(y: 10)
                }
                .padding(.horizontal)
                .offset(y: 20)
            
            TextEditor(text: $text)
                .scrollContentBackground(.hidden)
                .padding(.horizontal, 15)
                .padding(.horizontal)
                .padding(.top, 34)
                .frame(height: height)
                .font(.custom("SFProDisplay-Regular", size: 14))
                .foregroundStyle(.black)
                .focused($isTextFocused)
            
            if text.isEmpty && !isTextFocused {
                VStack {
                    Text(placeholder)
                        .Pro(size: 14, color: .black.opacity(0.25))
                        .padding(.horizontal, 15)
                        .padding(.horizontal)
                        .padding(.top, 40)
                        .onTapGesture {
                            isTextFocused = true
                        }
                    Spacer()
                }
            }
        }
        .frame(width: width, height: height)
    }
}
