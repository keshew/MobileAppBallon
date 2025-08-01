import SwiftUI

struct WishMapView: View {
    @StateObject var wishMapModel =  WishMapViewModel()
    @State private var selectedBallonID: Int? = nil
    @Environment(\.presentationMode) var presentationMode
    @State var isAdd = false
    @State var isEdit = false
    @State var isRemove = false
    @State var editingBallon: BallonModel? = nil
    @State private var ballonToDelete: BallonModel? = nil
    @State private var showDeleteAlert = false
    @State var back = false
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
                
                if wishMapModel.ballons.isEmpty {
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
                    
                    Image(.ballPush)
                        .resizable()
                        .frame(width: 190, height: 225)
                        .scaleEffect(x: -1, y: 1)
                        .padding(.top, 30)
                    
                    Spacer()
                    
                    Text("You don't have any wishes added yet. Click on the “+” button and add the first one. Connect your wishes with strings and you will have everything come true!")
                        .Pro(size: 18, color: .black.opacity(0.5))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 50)
                    
                    Spacer()
                    
                } else {
                    if !UserDefaultsManager().isGuest() {
                        VStack {
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
                            
                            ScrollView([.vertical, .horizontal], showsIndicators: false) {
                                VStack(alignment: .center, spacing: 40) {
                                    ForEach(Array(wishMapModel.ballons.enumerated()), id: \.element.id) { index, ballon in
                                        ZStack {
                                            if index < wishMapModel.ballons.count - 1 {
                                                let currentX = index % 2 == 0 ? -80.0 + 75 : 80.0 + 75
                                                let nextX = (index + 1) % 2 == 0 ? -80.0 + 75 : 80.0 + 75
                                                let currentY = 90.0
                                                let nextY = currentY + 180 + 40
                                                
                                                WavyLine(start: CGPoint(x: currentX, y: currentY),
                                                         end: CGPoint(x: nextX, y: nextY),
                                                         waveHeight: 20,
                                                         waveLength: 40)
                                                .stroke(Color.white, lineWidth: 5)
                                                .zIndex(-1)
                                                .opacity(selectedBallonID != nil ? 0.5 : 1)
                                            }
                                            
                                            Image(ballon.image)
                                                .resizable()
                                                .frame(width: 150, height: 180)
                                                .overlay {
                                                    ZStack {
                                                        Text(ballon.title)
                                                            .Pro(size: 24)
                                                        
                                                        if ballon.status == "Executed!" {
                                                            Image(.done)
                                                                .resizable()
                                                                .frame(width: 40, height: 40)
                                                                .offset(x: 60, y: -60)
                                                        }
                                                        
                                                        if selectedBallonID == index {
                                                            HStack(spacing: 20) {
                                                                Button(action: {
                                                                    editingBallon = ballon
                                                                    isEdit = true
                                                                }) {
                                                                    Image(.editImg)
                                                                        .resizable()
                                                                        .frame(width: 35, height: 35)
                                                                }
                                                                
                                                                Button(action: {
                                                                    ballonToDelete = ballon
                                                                    showDeleteAlert = true
                                                                }) {
                                                                    Image(.trashImg)
                                                                        .resizable()
                                                                        .frame(width: 35, height: 35)
                                                                }
                                                                .offset(x: -15, y: 30)
                                                            }
                                                            .offset(x: -50, y: 35)
                                                            .transition(.opacity.combined(with: .move(edge: .top)))
                                                        }
                                                    }
                                                }
                                                .offset(x: index % 2 == 0 ? -80 : 80)
                                                .opacity(selectedBallonID == nil ? 1 : selectedBallonID == index ? 1 : 0.5)
                                                .onTapGesture {
                                                    withAnimation {
                                                        if selectedBallonID == index {
                                                            selectedBallonID = nil
                                                        } else {
                                                            selectedBallonID = index
                                                        }
                                                    }
                                                }
                                        }
                                        .frame(height: 180)
                                    }
                                }
                            }
                        }
                    }
                }
                
                if !UserDefaultsManager().isGuest() {
                    Button(action: {
                        isAdd = true
                    }) {
                        Image(.addBtn2)
                            .resizable()
                            .frame(width: 90, height: 90)
                    }
                }
            }
            .padding(.vertical)
        }
        .fullScreenCover(isPresented: $isAdd) {
            CreateBallView()
        }
        .fullScreenCover(isPresented: $back) {
            MainView()
        }
        .fullScreenCover(item: $editingBallon) { ballon in
            EditView(ballon: ballon)
        }
        .onAppear {
            if !UserDefaultsManager().isGuest() {
                wishMapModel.loadBallons(userId: "\(UserDefaultsManager().getUserId() ?? "" )")
            }
        }
        .alert("Do you really want to remove the wishing ball?", isPresented: $showDeleteAlert, actions: {
            Button("No, leave it", role: .cancel) {
                ballonToDelete = nil
            }
            Button("Yes, I do", role: .destructive) {
                if let ballon = ballonToDelete {
                    wishMapModel.deleteBallon(id: ballon.id)
                    selectedBallonID = nil
                }
                ballonToDelete = nil
            }
        })
    }
}

#Preview {
    WishMapView()
}

struct WavyLine: Shape {
    let start: CGPoint
    let end: CGPoint
    let waveHeight: CGFloat
    let waveLength: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: start)
        
        let totalDistance = hypot(end.x - start.x, end.y - start.y)
        let numberOfWaves = Int(totalDistance / waveLength)
        guard numberOfWaves > 0 else {
            path.addLine(to: end)
            return path
        }
        
        let deltaX = (end.x - start.x) / CGFloat(numberOfWaves)
        let deltaY = (end.y - start.y) / CGFloat(numberOfWaves)
        
        for i in 0..<numberOfWaves {
            let startPoint = CGPoint(x: start.x + CGFloat(i) * deltaX, y: start.y + CGFloat(i) * deltaY)
            let endPoint = CGPoint(x: start.x + CGFloat(i + 1) * deltaX, y: start.y + CGFloat(i + 1) * deltaY)
            
            let midPoint = CGPoint(x: (startPoint.x + endPoint.x) / 2, y: (startPoint.y + endPoint.y) / 2)
            
            let vectorX = end.x - start.x
            let vectorY = end.y - start.y
            let length = sqrt(vectorX * vectorX + vectorY * vectorY)
            let normX = vectorX / length
            let normY = vectorY / length
            
            let perpX = -normY
            let perpY = normX
            
            let controlPoint = CGPoint(x: midPoint.x + perpX * (i % 2 == 0 ? waveHeight : -waveHeight),
                                       y: midPoint.y + perpY * (i % 2 == 0 ? waveHeight : -waveHeight))
            
            path.addQuadCurve(to: endPoint, control: controlPoint)
        }
        
        return path
    }
}

struct CustomTextView3: View {
    @Binding var text: String
    @Binding var title: String
    @FocusState var isTextFocused: Bool
    var placeholder: String
    var placeholderTitle: String
    var height: CGFloat = 150
    var width: CGFloat = 270
    var body: some View {
        ZStack(alignment: .leading) {
            Image(.note)
                .resizable()
                .overlay {
                    VStack(spacing: 15) {
                        ForEach(0..<5) { index in
                            Rectangle()
                                .fill(Color.black.opacity(0.5))
                                .frame(height: 1)
                                .padding(.horizontal)
                        }
                    }
                    .offset(y: 20)
                }
                .padding(.horizontal)
                .offset(y: 20)
            
            TextEditor(text: $text)
                .scrollContentBackground(.hidden)
                .padding(.horizontal, 15)
                .padding(.horizontal)
                .padding(.top, 34)
                .padding(.top, 25)
                .frame(height: height)
                .font(.custom("SFProDisplay-Regular", size: 14))
                .foregroundStyle(.black)
                .focused($isTextFocused)
            
            CustomTextFiled2(text: $title, placeholder: placeholderTitle)
                .offset(y: -25)
            
            if text.isEmpty && !isTextFocused {
                Text(placeholder)
                    .Pro(size: 14, color: .black.opacity(0.25))
                    .padding(.horizontal, 19)
                    .padding(.horizontal)
                    .onTapGesture {
                        isTextFocused = true
                    }
                
                    .padding(.top, 32)
            }
        }
        .frame(width: width, height: height)
    }
}
struct CustomTextFiled2: View {
    @Binding var text: String
    @FocusState var isTextFocused: Bool
    var placeholder: String
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(.clear)
                .frame(height: 35)
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
            .font(.custom("SFProDisplay-Bold", size: 16))
            .cornerRadius(9)
            .foregroundStyle(.black)
            .focused($isTextFocused)
            .padding(.horizontal, 35)
            
            if text.isEmpty && !isTextFocused {
                Text(placeholder)
                    .ProBold(size: 16, color: .black.opacity(0.5))
                    .frame(height: 20)
                    .padding(.leading, 35)
                    .onTapGesture {
                        isTextFocused = true
                    }
            }
        }
    }
}


