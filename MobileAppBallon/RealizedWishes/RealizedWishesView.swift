import SwiftUI

struct RealizedWishesView: View {
    @StateObject var realizedWishesModel =  RealizedWishesViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Image(.back)
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                    
                    Spacer()
                    
                    Text("Realized wishes")
                        .Pro(size: 24)
                        .padding(.trailing, 15)
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 15) {
                        ForEach(realizedWishesModel.executedBallons) { ballon in
                            Rectangle()
                                .fill(Color(red: 32/255, green: 145/255, blue: 216/255).opacity(0.25))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color(red: 127/255, green: 228/255, blue: 245/255), lineWidth: 1.5)
                                        .overlay {
                                            HStack(alignment: .top) {
                                                VStack(alignment: .leading, spacing: 5) {
                                                    Text(ballon.title)
                                                        .ProBold(size: 18)
                                                    
                                                    Text(ballon.desc)
                                                        .Pro(size: 14, color: .white.opacity(0.75))
                                                }
                                                .padding(.leading, 5)
                                                
                                                Spacer()
                                                
                                                Text("Executed")
                                                    .Pro(size: 14, color: .black)
                                                    .padding(.horizontal, 10)
                                                    .padding(.vertical, 5)
                                                    .background(Color(red: 247/255, green: 213/255, blue: 44/255))
                                                    .cornerRadius(12)
                                            }
                                            .padding(.horizontal)
                                        }
                                }
                                .frame(height: 100)
                                .cornerRadius(25)
                                .padding(.horizontal)
                        }
                    }
                }
                .padding(.top)
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Rectangle()
                        .fill(Color(red: 247/255, green: 213/255, blue: 44/255))
                        .overlay {
                            Text("Back")
                                .Pro(size: 19, color: .black)
                        }
                        .frame(height: 50)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .onAppear {

            realizedWishesModel.loadExecutedBallons(userId: "\(UserDefaultsManager().getUserId() ?? "")")
        }
    }
}


#Preview {
    RealizedWishesView()
}

