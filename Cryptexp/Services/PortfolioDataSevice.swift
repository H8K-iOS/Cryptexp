import Foundation
import CoreData

final class PortfolioDataSevice {
    //MARK: - Properties
    private let container: NSPersistentContainer
    private let containerName = "PortfolioContainer"
    private let entity: String = "Portfolio"
    @Published var savedEntity: [Portfolio] = []
    
    //MARK: - Init
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error {
                print("Error loading core data: - \(error)")
            }
            self.getPortfolio()
        }
    }
    
    //MARK: - Methods
    //MARK: PUBLIC
    public func updatePortfolio(coin: Coin, ammount: Double) {
        if let entity = savedEntity.first(where: {$0.coinID == coin.id}) {
            if ammount > 0 {
                update(entity: entity, ammount: ammount)
            } else {
                delete(entity: entity)
            }
        } else {
            add(coin: coin, ammount: ammount)
        }
    }
    
    //MARK: PRIVATE
    private func getPortfolio() {
        let req = NSFetchRequest<Portfolio>(entityName: entity)
        do {
            savedEntity = try container.viewContext.fetch(req)
        } catch let error {
            print("error fetching portfolio entities - \(error)")
        }
    }
    
    private func add(coin: Coin, ammount: Double) {
        let entity = Portfolio(context: container.viewContext)
        entity.coinID = coin.id
        entity.ammount = ammount
        applyChanges()
    }
    
    private func update(entity: Portfolio, ammount: Double) {
        entity.ammount = ammount
        applyChanges()
    }
    
    private func delete(entity: Portfolio) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch let error{
            print("error saving portfolio entities - \(error)")
        }
    }
    
    private func applyChanges() {
        save()
        getPortfolio()
    }
}
