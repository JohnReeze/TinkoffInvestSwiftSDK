//
//  MoneyValue+Extension.swift
//  TinkoffInvestSwiftSDK
//
//  Created by m.monakov on 18.01.2022.
//

import Foundation

public extension MoneyValue {
    var asMoneyAmount: MoneyAmount {
        let value = Decimal(units) + Decimal(sign: nano.signum() == -1 ? .minus : .plus , exponent: -9, significand: Decimal(nano))
        guard let currency = MoneyCurrency(rawValue: currency) else {
            assertionFailure("Did not recognize currency \(currency)")
            return .init(currency: .rub, value: value)
        }
        return .init(currency: currency, value: value)
    }
}
