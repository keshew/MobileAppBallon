import SwiftUI

struct AchievModel: Codable, Identifiable {
    var id = UUID().uuidString
    var image: String
    var title: String
    var description: String
    var isDone: Bool
}

struct AchievementsView: View {
    
    var achiev = [AchievModel(image: "ach1", title: "First Flight", description: "Launched your very first balloon", isDone: false),
                  AchievModel(image: "ach2", title: "Wish Collector", description: "Added 10 wishes to your map.", isDone: false),
                  AchievModel(image: "ach3", title: "Sky Traveler", description: "Sent a balloon to 3 different color", isDone: false),
                  AchievModel(image: "ach4", title: "Altitude Master", description: "Launched a balloon 500 m high", isDone: false),
                  AchievModel(image: "ach5", title: "Cloud King", description: "Your balloon flew 1 000 m", isDone: false),
                  AchievModel(image: "ach6", title: "Map of Dreams", description: "Filled your wish map with 5 balloons", isDone: false),
                  AchievModel(image: "ach7", title: "Tailwind", description: "Made 5 successful launches in a row.", isDone: false),
                  AchievModel(image: "ach8", title: "Dawn Pioneer", description: "Launched a balloon between 5 AM and 7 AM", isDone: false),
                  AchievModel(image: "ach9", title: "Night Dreamer", description: "Sent a balloon after sunset.", isDone: false),
                  AchievModel(image: "ach10", title: "Energetic Starter", description: "Launched a balloon within an hour  of adding a wish.", isDone: false)]
    
    var body: some View {
        ZStack {
            Image(.back)
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button(action: {
                        
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                    
                    Spacer()
                    
                    Text("My achievements")
                        .Pro(size: 24)
                        .padding(.trailing, 20)
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                ScrollView(showsIndicators: false) {
                    VStack {
                        ForEach(achiev.indices, id: \.self) { index in
                            Rectangle()
                                .fill(Color(red: 32/255, green: 145/255, blue: 216/255).opacity(0.25))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color(red: 127/255, green: 228/255, blue: 245/255), lineWidth: 1.5)
                                        .overlay {
                                            HStack {
                                                Image(achiev[index].image)
                                                    .resizable()
                                                    .frame(width: 65, height: 65)
                                                    .overlay {
                                                        if achiev[index].isDone == false {
                                                            Image(.lock)
                                                                .resizable()
                                                                .frame(width: 45, height: 45)
                                                        }
                                                    }
                                                
                                                VStack(alignment: .leading, spacing: 5) {
                                                    Text(achiev[index].title)
                                                        .ProBold(size: 18)
                                                    
                                                    Text(achiev[index].description)
                                                        .Pro(size: 14)
                                                }
                                                .padding(.leading, 5)
                                                
                                                Spacer()
                                            }
                                            .padding(.horizontal)
                                        }
                                }
                                .frame(height: 90)
                                .cornerRadius(25)
                                .padding(.horizontal)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    AchievementsView()
}

