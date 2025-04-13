import Foundation


extension Date {
    
    //coingeko string: 2021-03-13T23:18:10.268Z
    
    
    init(coinGekoString: String) {
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = formater.date(from: coinGekoString) ?? Date()
        self.init(timeInterval: 0, since: date)
    }
    
    private var shortFormater: DateFormatter {
        let formater = DateFormatter()
        formater.dateStyle = .short
        return formater
    }
    
    func asShortDateString() -> String {
        return shortFormater.string(from: self)
    }
}
