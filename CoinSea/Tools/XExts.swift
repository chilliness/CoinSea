//
//  XExts.swift
//  CoinSea
//
//  Created by xiaohan on 2026/5/20.
//

import SwiftUI

extension Double {
    private var currencyFormatters2: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.currencyCode = "usd"
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    private var currencyFormatters6: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.currencyCode = "usd"
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        return formatter
    }
    
    func asCurrencyWith2Decimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormatters2.string(from: number) ?? "$0.00"
    }
    
    func asCurrencyWith6Decimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormatters6.string(from: number) ?? "$0.00"
    }
    
    func asNumberString() -> String {
        return String(format: "%.2f", self)
    }
    
    func asPercentString() -> String {
        return asNumberString() + "%"
    }
    
    func asWithAbbr() -> String {
        let num = abs(Double(self))
        let sign = (self < 0) ? "-" : ""
        
        switch num {
        case 1_000_000_000_000...:
            let formatted = num / 1_000_000_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)Tr"
        case 1_000_000_000...:
            let formatted = num / 1_000_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)Bn"
        case 1_000_000...:
            let formatted = num / 1_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)M"
        case 1_000...:
            let formatted = num / 1_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)K"
        case 0...:
            return self.asNumberString()
            
        default:
            return "\(sign)\(self)"
        }
    }
}

extension URLResponse {
    var isOK: Bool {
        (self as? HTTPURLResponse).map { (200...299).contains($0.statusCode) } ?? false
    }
}

extension Date {
    init(utcDate: String) {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        self.init(timeInterval: 0, since: fmt.date(from: utcDate) ?? Date())
    }
    
    func asShortString() -> String {
        let fmt = DateFormatter()
        fmt.dateStyle = .short
        return fmt.string(from: self)
    }
}

extension UIApplication {
    // 收起键盘
    func handleEnd() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension String {
    func handleRemoveHTML() -> String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}

extension View {
    // 是否渲染该视图
    @ViewBuilder
    func isPresented(_ condition: Bool) -> some View {
        if condition {
            self
        }
    }
    
    @ViewBuilder
    func isRounded(_ cornerRadius: CGFloat) -> some View {
        self.clipShape(.rect(cornerRadius: cornerRadius))
    }
}
