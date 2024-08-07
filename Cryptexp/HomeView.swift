import SwiftUI

struct HomeView: View {
    //MARK: - Properties
    @State private var showPortfolio: Bool = false
    
    //MARK: - Body
    var body: some View {
        ZStack {
            //MARK: Background Layer
            Color.theme.backgroundColor
                .ignoresSafeArea()
            
            
            //MARK: - Content Layer
            VStack {
                NavigationBarView
                Spacer(minLength: 0)
            }
        }
        
    }
}

#Preview {
    NavigationView {
        HomeView()
            .navigationBarHidden(true)
    }
}

//MARK: - Extensions
extension HomeView {
    private var NavigationBarView: some View {
            HStack {
                CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                    .background(
                        CirculButtonAnimationView(animate: $showPortfolio)
                    )
                Spacer()
                Text(showPortfolio ? "Portfolio" : "Live prices")
                    .font(.headline)
                    .fontWeight(.heavy)
                    .foregroundStyle(Color.theme.accent)
                Spacer()
                CircleButtonView(iconName: "chevron.right")
                    .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                    .onTapGesture {
                        withAnimation(.spring) {
                            showPortfolio.toggle()
                        }
                    }
            }
            .padding(.horizontal)
        }
}
