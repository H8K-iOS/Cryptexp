import SwiftUI

struct CoinRowView: View {
    //MARK: - Properties
    let coin: Coin
    let showHoldingColumns: Bool
    
    //MARK: - Body
    var body: some View {
        HStack(spacing: 0) {
            self.leftColumn
            
            Spacer()
            
            if showHoldingColumns {
                self.centerColumn
            }
            
            self.rightColumn
        }
        .font(.subheadline)
        .padding(.horizontal, 10)
    }
}

//MARK: - Preview
struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CoinRowView(coin: dev.coin, showHoldingColumns: true)
                .previewLayout(.sizeThatFits)
            
            CoinRowView(coin: dev.coin, showHoldingColumns: false)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}

//MARK: - Extensions
extension CoinRowView {
    private var leftColumn: some View {
        HStack(spacing: 0) {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryTextColor)
                .frame(minWidth: 30)
            
            CoinImageView(coin: coin)
                .frame(width: 30, height: 30)
            
            Text(coin.symbol.uppercased())
                .padding(.leading, 6)
                .fontWeight(.bold)
                .foregroundStyle(Color.theme.accent)
        }
    }
    
    private var centerColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentHoldingValue.asCurrencyWith6Decimals())
                .bold()
            Text((coin.currentHoldings ?? 0).asNumberString())
        }
    }
    
    private var rightColumn: some View {
        VStack(alignment: .trailing){
            Text(coin.currentPrice.asCurrencyWith2Decimals())
                .fontWeight(.bold)
                .foregroundStyle(Color.theme.accent)
            Text(coin.priceChangePercentage24H?.asPercentageString() ?? "")
                .foregroundStyle(
                    (coin.priceChangePercentage24H ?? 0) >= 0 ?
                    Color.theme.greenColor : Color.theme.redColor
                )
        }
        .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
    }
}
