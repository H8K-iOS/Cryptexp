import SwiftUI

struct CircleButtonView: View {
    let iconName: String
    
    var body: some View {
        Image(systemName: iconName)
            .foregroundStyle(Color.theme.accent)
            .font(.headline)
            .frame(width: 50, height: 50)
            .background(
                Circle()
                    .foregroundStyle(Color.theme.backgroundColor)
            )
            .shadow(
                color: Color.theme.accent.opacity(0.4),
                radius: 10,
                x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/,
                y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/
            )
            .padding()
    }
}

struct CircleButtonView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CircleButtonView(iconName: "info")
                .padding()
                .previewLayout(.sizeThatFits)
            
            CircleButtonView(iconName: "plus")
                .padding()
                .previewLayout(.sizeThatFits)
                .colorScheme(.dark)
        }
    }
}
