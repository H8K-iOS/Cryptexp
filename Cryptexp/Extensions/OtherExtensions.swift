import Foundation

extension Double {
    
    ///Converts a Double to a currency w 2 decimal places
    ///```
    ///Convert 1234.56 to $1,234.56
    ///```
    private var currencyFormater2: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
//        formatter.locale = .current
        formatter.currencyCode = "usd"
        formatter.currencySymbol = "$"
        
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    
    ///Converts a Double to a currency as a String w 2 decimal places
    ///```
    ///Convert 1234.56 to "$1,234.56"
    ///```
    public func asCurrencyWith2Decimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormater2.string(from: number) ?? "$0.00"
    }
    
    ///Converts a Double to a currency w 2-6 decimal places
    ///```
    ///Convert 1234.56 to $1,234.56
    ///Convert 12.3456 to $12.3456
    ///Convert 0.123456 to $0.123456
    ///```
    private var currencyFormater6: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
//        formatter.locale = .current
        formatter.currencyCode = "usd"
        formatter.currencySymbol = "$"
        
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        return formatter
    }
    
    
    ///Converts a Double to a currency as a String w 2-6 decimal places
    ///```
    ///Convert 1234.56 to "$1,234.56"
    ///Convert 12.3456 to "$12.3456"
    ///Convert 0.123456 to "$0.123456"
    ///```
    public func asCurrencyWith6Decimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormater6.string(from: number) ?? "$0.00"
    }
    
    
    ///Converts a Double into a String
    ///```
    ///Convert 1.23456 to "1.23"
    ///```
    public func asNumberString() -> String {
        String(format: "%.2f", self)
    }
    
    ///Converts a Double into a String w percent symbol
    ///```
    ///Convert 1.23456 to "1.23%"
    ///```
    public func asPercentageString() -> String {
        asNumberString() + "%"
    }
}
