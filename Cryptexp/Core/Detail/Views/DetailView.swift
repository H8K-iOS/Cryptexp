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
    @State private var showFullDescription: Bool = false
    
    init(coin: Coin) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ChartView(coin: vm.coin)
                    .padding(.vertical)
                
                VStack(spacing: 20) {
                    overviewTitle
                    Divider()
                    
                    descriptionSection
                    
                    
                    overviewGrid
                    
                    additioalTitle
                    Divider()
                    
                    additionalGrid
                    
                    linksSection
                    
                }
                .padding()
            }
            
            
        }
        .navigationTitle(vm.coin.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                toolBarTrailingItems
            }
        }
    }
}


#Preview {
    NavigationView {
        DetailView(coin: DeveloperPreview.instance.coin)
    }
    
}

//MARK: - Extensions
private extension DetailView {
    var toolBarTrailingItems: some View {
        HStack {
            Text(vm.coin.symbol.uppercased())
                .font(.headline)
                .foregroundStyle(Color.theme.secondaryTextColor)
            
            CoinImageView(coin: vm.coin)
                .frame(width: 25, height: 25)
        }
    }
    
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
    
    var descriptionSection: some View {
        ZStack {
            if let coinDescription = vm.coinDescription, !coinDescription.isEmpty {
                VStack(alignment: .leading) {
                    Text(coinDescription)
                        .lineLimit(showFullDescription ? nil : 3)
                        .font(.callout)
                        .foregroundStyle(Color.theme.secondaryTextColor)
                    
                    Button {
                        withAnimation(.easeInOut) {
                            showFullDescription.toggle()
                        }
                    } label: {
                        Text(showFullDescription ? "Less" : "Read more...")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.vertical, 4)
                    }
                    .tint(.blue)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    var linksSection: some View {
        HStack {
            if let websiteString = vm.websiteURL,
               let url = URL(string: websiteString) {
                Link(destination: url) {
                    Text("Website")
                }
                .tint(.blue)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.headline)
            }
            
            
            if let redditString = vm.redditURL,
               let url = URL(string: redditString) {
                Link(destination: url) {
                    Text("Reddit")
                        .tint(.blue)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.headline)
                }
            }
        }
        
    }
}
