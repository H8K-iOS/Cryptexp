import SwiftUI

struct StatistickView: View {
    let stat: StatisticModel
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(stat.title)
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryTextColor)
            Text(stat.value)
                .font(.headline)
                .foregroundStyle(Color.theme.accent)

            HStack {
                Image(systemName: "triangle.fill")
                    .font(.caption)
                    .rotationEffect(
                        Angle.degrees( (stat.percentageChange ?? 0) >= 0 ? 0 : 180)
                    )
                
                Text(stat.percentageChange?.asPercentageString() ?? "")
                    .font(.caption)
                .bold()
            }
            .foregroundStyle(
                (stat.percentageChange ?? 0) >= 0 ? Color.theme.greenColor : Color.theme.redColor
            )
            .opacity(stat.percentageChange == nil ? 0.0 : 1.0)
        }
        
    }
}

struct StatisticView_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            StatistickView(stat: dev.stat1)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
        
    }
}
