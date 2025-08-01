import SwiftUI

struct PushBallView: View {
    @State private var text = ""
    @State private var rectOffsetY: CGFloat = -105
    @State private var isLaunched = false
    
    @State private var ballScale: CGFloat = 1.0
    @State private var ballOffsetY: CGFloat = 0
    @State private var buttonOffsetY: CGFloat = 0
    @State private var buttonScale: CGFloat = 1.0
    @State private var instructionOffsetY: CGFloat = 0
    @State private var instructionScale: CGFloat = 1.0
    @State private var flightMeterOpacity: Double = 0.0
    @State private var flightMeterText: String = "15m"
    
    @State private var displayedMeters: Int = 15
    @State private var targetMeters: Int = 15
    @State private var timer: Timer? = nil
    @State private var launchFinished = false
    @State private var direction: CGFloat = 1
    @Binding var textPlaceholer: String
    let maxOffset: CGFloat = 115
    
    var body: some View {
        ZStack {
            ScrollView {
                Image(.bgFly)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width)
                    .ignoresSafeArea()
                    .offset(y: isLaunched ? -UIScreen.main.bounds.height : -90)
                    .animation(.easeInOut(duration: 2), value: isLaunched)
            }
            
            Rectangle()
                .fill(Color(red: 32/255, green: 145/255, blue: 216/255).opacity(0.25))
                .overlay {
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color(red: 127/255, green: 228/255, blue: 245/255), lineWidth: 1.5)
                        .overlay {
                            Text("\(displayedMeters)m")
                                .ProBold(size: 18, color: .white)
                        }
                }
                .frame(width: 80, height: 55)
                .cornerRadius(25)
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 23)
                .opacity(flightMeterOpacity)
                .animation(.easeInOut(duration: 1), value: flightMeterOpacity)
            
            VStack {
                Image(.ballPush)
                    .resizable()
                    .frame(width: 320, height: 350)
                    .overlay{
                        CustomTextView2(placeholder: textPlaceholer)
                            .offset(y: -30)
                    }
                    .offset(y: ballOffsetY)
                    .scaleEffect(ballScale)
                    .animation(.easeInOut(duration: 4), value: ballOffsetY)
                    .animation(.easeInOut(duration: 1), value: ballScale)
                
                Spacer()
                
                HStack(alignment: .bottom, spacing: 40) {
                    Spacer()
                    
                    VStack {
                        Text("Squeeze the button,\nand release when the launch\nforce is maxed out!")
                            .Pro(size: 16, color: .black.opacity(0.5))
                            .multilineTextAlignment(.center)
                            .offset(y: instructionOffsetY)
                            .scaleEffect(instructionScale)
                            .animation(.easeInOut(duration: 1), value: instructionOffsetY)
                            .animation(.easeInOut(duration: 1), value: instructionScale)
                        
                        Button(action: startLaunchAnimation) {
                            Image(.tappedBtn)
                                .resizable()
                                .frame(width: 110, height: 110)
                        }
                        .offset(y: buttonOffsetY)
                        .scaleEffect(buttonScale)
                        .animation(.easeInOut(duration: 1), value: buttonOffsetY)
                        .animation(.easeInOut(duration: 1), value: buttonScale)
                    }
                    
                    Image("colorImg")
                        .resizable()
                        .frame(width: 40, height: 250)
                        .overlay {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(red: 130/255, green: 205/255, blue: 253/255), lineWidth: 10)
                                .overlay {
                                    Rectangle()
                                        .fill(Color.white.opacity(0.7))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color(red: 0/255, green: 85/255, blue: 138/255), lineWidth: 6)
                                        }
                                        .frame(width: 70, height: 28)
                                        .cornerRadius(12)
                                        .offset(y: rectOffsetY)
                                        .animation(
                                            Animation.easeInOut(duration: 2)
                                                .repeatForever(autoreverses: true),
                                            value: rectOffsetY
                                        )
                                        .onAppear {
                                            rectOffsetY = maxOffset
                                        }
                                    
                                }
                        }
                        .onAppear {
                            rectOffsetY = maxOffset
                        }
                        .offset(y: buttonOffsetY)
                        .scaleEffect(buttonScale)
                        .animation(.easeInOut(duration: 1), value: buttonOffsetY)
                        .animation(.easeInOut(duration: 1), value: buttonScale)
                }
                .padding(.trailing, 40)
            }
            .padding(.vertical, 50)
        }
        .onAppear {
            startMovingIndicator()
        }
        
        .onDisappear {
            timer?.invalidate()
        }
        .fullScreenCover(isPresented: $launchFinished) {
            EndFlyView(metres: $displayedMeters)
        }
    }
    
    func startMovingIndicator() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
            
            rectOffsetY += direction * 1.5
            if rectOffsetY >= maxOffset {
                direction = -1
            } else if rectOffsetY <= -maxOffset {
                direction = 1
            }
        }
    }
    
    func startLaunchAnimation() {
        withAnimation(.easeInOut(duration: 1.0)) {
            ballScale = 0.5
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeInOut(duration: 2.0)) {
                isLaunched = true
                ballOffsetY = -UIScreen.main.bounds.height
                buttonOffsetY = UIScreen.main.bounds.height
                buttonScale = 0.5
                instructionOffsetY = UIScreen.main.bounds.height
                instructionScale = 0.5
                flightMeterOpacity = 1.0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                launchFinished = true
            }
            
            startSmoothMeterUpdate()
        }
    }
    
    func calculateFlightDistanceValue(from offset: CGFloat) -> Int {
        let normalized = (offset + maxOffset) / (2 * maxOffset)
        let meters = Int(normalized * 3500) + 100
        return meters
    }
    
    func startSmoothMeterUpdate() {
        timer?.invalidate()
        targetMeters = calculateFlightDistanceValue(from: rectOffsetY)
        displayedMeters = 100
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            if displayedMeters < targetMeters {
                displayedMeters += max(1, (targetMeters - displayedMeters) / 10)
            } else {
                displayedMeters = targetMeters
                timer.invalidate()
            }
        }
    }
    
    func calculateFlightDistance(from offset: CGFloat) -> String {
        return "\(calculateFlightDistanceValue(from: offset))m"
    }
}

#Preview {
    PushBallView(textPlaceholer: .constant("I wish that everyone would be happy!"))
}


