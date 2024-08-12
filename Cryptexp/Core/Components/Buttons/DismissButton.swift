import SwiftUI

struct DismissButton: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack{
        Button(action: {
            dismiss.callAsFunction()
        }, label: {
            Image(systemName: "xmark")
                .font(.headline)
        })
        }
    }
}

#Preview {
    DismissButton()
}
