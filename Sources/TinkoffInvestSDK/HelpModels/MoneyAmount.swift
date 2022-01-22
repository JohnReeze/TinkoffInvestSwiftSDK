//
//  MoneyAmount.swift
//  
//
//  Created by m.monakov on 20.01.2022.
//

import Foundation

public struct MoneyAmount: Codable {
    // MARK: - Public Properties
    public let currency: MoneyCurrency
    public let value: Decimal
}
