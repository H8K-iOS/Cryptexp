import SwiftUI

//MARK: - Loading
struct DetailLoadingView: View {
    @Binding var coin: Coin?
    
    var body: some View {
        ZStack {
            if let coin {
                DetailView(coin: coin)
            } else {
                
            }
        }
        
    }
}

//MARK: - View
struct DetailView: View {
    @StateObject private var vm: DetailViewModel
    private let spacing: CGFloat = 30
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    init(coin: Coin) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("")
                    .frame(height: 150)
                
                overviewTitle
                Divider()
                
                overviewGrid
                
                additioalTitle
                Divider()
                
                additionalGrid
            }
            .padding()
            
        }
        .navigationTitle(vm.coin.name)
    }
}
    

#Preview {
    NavigationView {
        DetailView(coin: DeveloperPreview.instance.coin)
    }
    
}

//MARK: - Extensions
private extension DetailView {
    var overviewTitle: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundStyle(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var additioalTitle: some View {
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundStyle(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var overviewGrid: some View {
        LazyVGrid(columns: columns,
                  alignment: .leading,
                  spacing: spacing,
                  content: {
            
            ForEach(vm.overviewStatistic) { stat in
                StatistickView(stat: stat)
            }
        })

    }
    
    var additionalGrid: some View {
        LazyVGrid(columns: columns,
                  alignment: .leading,
                  spacing: spacing,
                  content: {
            
            ForEach(vm.additionalStatistic) { stat in
                StatistickView(stat: stat)
            }
        })
    }
}
