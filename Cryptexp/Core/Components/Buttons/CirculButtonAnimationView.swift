import SwiftUI

struct CirculButtonAnimationView: View {
    @Binding var animate: Bool
    
    var body: some View {
       Circle()
            .stroke(lineWidth: 5.0)
            .scale(animate ? 1.0 : 0.0)
            .opacity(animate ? 0.0 : 1.0)
            .animation(animate ? Animation.easeOut(duration: 1.0) : .none)
    }
}

#Preview {
    CirculButtonAnimationView(animate: .constant(false))
}
