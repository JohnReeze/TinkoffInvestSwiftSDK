//
//  MoneyCurrency.swift
//  
//
//  Created by m.monakov on 20.01.2022.
//

public enum MoneyCurrency: String, Codable {
    case chf = "chf"
    case cny = "cny"
    case eur = "eur"
    case gbp = "gbp"
    case hkd = "hkd"
    case jpy = "jpy"
    case rub = "rub"
    case `try` = "try"
    case usd = "usd"

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
