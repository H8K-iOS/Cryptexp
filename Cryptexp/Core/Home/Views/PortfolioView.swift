import SwiftUI

struct PortfolioView: View {
    //MARK: - Properties
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var vm: HomeViewModel
    @State private var selectedCoin: Coin? = nil
    @State private var quantity: String = ""
    @State private var showCheckmark: Bool = false
    
    //MARK: - Body
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    CustomSearchBarView(searchText: $vm.searchedText)
                    
                    coinCollection
                    
                    if selectedCoin != nil {
                        coinDetails
                        .padding()
                    }
                }
            }
            .navigationTitle(Text("Edit Portfolio"))
            
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    DismissButton(dismiss: _dismiss)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    trailingNavbarItem
                }
            })
        }
    }
}

struct PortfolioView_Preview: PreviewProvider {
    static var previews: some View {
        PortfolioView()
            .environmentObject(dev.homeVM)
    }
}

extension PortfolioView {
    private var coinCollection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(vm.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                selectedCoin = coin
                            }
                        }
                        .frame(width: 75)
                        .background(RoundedRectangle(cornerRadius: 10)
                            .stroke(
                                selectedCoin?.id == coin.id ?
                                Color.theme.greenColor : Color.clear,
                                lineWidth: 1)
                        )
                }
            }
            .padding(.vertical, 4)
            .padding(.leading)
        }
    }
    
    private var coinDetails: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""):")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
            }
            Divider()
            HStack {
                Text("Ammount holding: ")
                Spacer()
                TextField("Ex: 1.4", text: $quantity)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider()
            HStack {
                Text("Current value")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimals())
            }
        }
    }
    
    private var trailingNavbarItem: some View {
        HStack {
            Image(systemName: "checkmark")
                .opacity(showCheckmark ? 1 : 0)
            
            Button {
                saveButtonPressed()
            } label: {
                Text("Save")
            }
            .opacity(
                (selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantity)) ?
                1.0 : 0.0
            )
        }
        .font(.headline)
    }
    
    //MARK: - Methods
    private func getCurrentValue() -> Double {
        if let quantity = Double(quantity) {
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
    
    private func saveButtonPressed() {
        guard let coin = selectedCoin else { return }
        // save portfolio
        
        withAnimation {
            showCheckmark = true
            deselectCoin()
        }
        
        //keyboard hide
        UIApplication.shared.endEditing()
        
        
        
        //hide checkmark
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeOut) {
                showCheckmark = false
            }
        }
    }
    
    private func deselectCoin() {
        selectedCoin = nil
        vm.searchedText = ""
    }
}
