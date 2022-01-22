//
//  MoneyCurrency.swift
//  
//
//  Created by m.monakov on 20.01.2022.
//

public enum MoneyCurrency: String, Codable {
    case chf = "CHF"
    case cny = "CNY"
    case eur = "EUR"
    case gbp = "GBP"
    case hkd = "HKD"
    case jpy = "JPY"
    case rub = "RUB"
    case `try` = "TRY"
    case usd = "USD"

    public var sign: String {
        switch self {
        case .rub: return "₽"
        case .cny: return "¥"
        case .jpy: return "¥"
        case .eur: return "€"
        case .usd: return "$"
        case .gbp: return "£"
        case .try: return "₺"
        case .hkd: return "HKD"
        case .chf: return "CHF"
        }
    }
}
