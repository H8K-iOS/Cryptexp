import SwiftUI

struct CustomSearchBarView: View {
    
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(
                    searchText.isEmpty ?
                    Color.theme.secondaryTextColor : Color.theme.accent
                )
            
            TextField("Search by name or symbol...", text: $searchText)
                .foregroundStyle(Color.theme.accent)
                .autocorrectionDisabled(true)
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .padding()
                        .offset(x: 10)
                        .foregroundStyle(Color.theme.accent)
                        .opacity(searchText.isEmpty ? 0.0 : 1.0)
                        
                        .onTapGesture {
                            UIApplication.shared.endEditing()
                            searchText = ""
                        }
                    ,alignment: .trailing
                        
                )
            
        }
        .font(.headline)
        .padding()
        .background(
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.theme.backgroundColor)
            .shadow(color: Color.theme.accent.opacity(0.2),radius: 10)
        )
        .padding()
    }
}

#Preview {
    CustomSearchBarView(searchText: .constant(""))
}
