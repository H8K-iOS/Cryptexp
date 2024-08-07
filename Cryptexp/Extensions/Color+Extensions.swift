import SwiftUI

extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
    let accent = Color("AccentColor")
    let backgroundColor = Color("BackgroundColor")
    let greenColor = Color("GreenColor")
    let redColor = Color("RedColor")
    let secondaryTextColor = Color("SecondaryTextColor")
}
