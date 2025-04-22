import SwiftUI

struct SettingsView: View {
    //TODO: - vm
    
    let defaultURL = URL(string: "https://www.google.com")!
    
    let youtubeURL = URL(string: "https://www.youtube.com/watch?v=xvFZjo5PgG0&list=RDxvFZjo5PgG0&start_radio=1")!
    let  coingeckoURL = URL(string: "https://www.coingecko.com")!
    let gitURL = URL(string: "https://github.com/H8K-iOS")!
    
    
    var body: some View {
        NavigationStack {
            List {
                infoCard
                coingeckoCard
                applicationCard
            }
            .toolbarRole(.navigationStack)
        }
        .navigationTitle("Settings")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                DismissButton()
            }
        }
    }
}

#Preview {
    NavigationView {
        SettingsView()
    }
}

private extension SettingsView {
    //MARK: - info card
    var infoCard: some View {
        Section {
            VStack(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius:  20))
                    
                
                Text("This app was made to improve SwiftUI skills. It uses MVVM Architecture, Combine, CoreData")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.theme.accent)
                
            }
            .padding(.vertical)
            Link(destination: youtubeURL) {
                Text("My youtube personal blog 💥")
                    .foregroundStyle(Color.theme.secondaryTextColor)
            }
            Link(destination: gitURL) {
                Text("My GitHub profile 🫡")
                    .foregroundStyle(Color.theme.secondaryTextColor)
            }
        } header: {
            Text("H8K-iOS")
        }
        .listStyle(GroupedListStyle())
    }
    
    
    //MARK: - coingeko card
    var coingeckoCard: some View {
        Section {
            VStack(alignment: .leading) {
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius:  20))
                    
                
                Text("The cryptocurrency data that is used in this app comes from a free API by CoinGecko! Prices might be slightly delayed.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.theme.accent)
                
            }
            .padding(.vertical)
            Link(destination: coingeckoURL) {
                Text("Visit CoinGecko 🦎")
                    .foregroundStyle(Color.theme.secondaryTextColor)
            }
        } header: {
            Text("Coin Gecko")
        }
        .listStyle(GroupedListStyle())
    }
    
    var applicationCard: some View {
        Section {
            Link(destination: defaultURL) {
                Text("Tearms of Service")
                    .foregroundStyle(Color.theme.secondaryTextColor)
            }
            Link(destination: defaultURL) {
                Text("Privacy Policy")
                    .foregroundStyle(Color.theme.secondaryTextColor)
            }
            
            Link(destination: defaultURL) {
                Text("Learn More")
                    .foregroundStyle(Color.theme.secondaryTextColor)
            }
            
        } header: {
            Text("Application")
        }
        .listStyle(GroupedListStyle())

        
        
    }
}
