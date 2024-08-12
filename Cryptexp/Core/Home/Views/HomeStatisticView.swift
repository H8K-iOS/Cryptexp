import SwiftUI

struct HomeStatisticView: View {
    @EnvironmentObject private var vm: HomeViewModel
    
    @Binding var showPortfolio: Bool
    var body: some View {
    
        HStack {
            ForEach(vm.statisctic) { stat in
                StatistickView(stat: stat)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
            .frame(width: UIScreen.main.bounds.width,
                   alignment: showPortfolio ? .trailing : .leading)
    }
}

struct HomeStatisticView_Preview: PreviewProvider {
    static var previews: some View {
        HomeStatisticView(showPortfolio: .constant(false))
            .environmentObject(dev.homeVM)
    }
}
