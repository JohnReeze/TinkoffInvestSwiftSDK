//
//  TinkoffInvestTokenProvider.swift
//  
//
//  Created by m.monakov on 20.01.2022.
//

public protocol TinkoffInvestTokenProvider {
    func provideToken() -> String
}

public struct DefaultTokenProvider: TinkoffInvestTokenProvider {
    public let token: String

    public init(token: String) {
        self.token = token
    }

    // MARK: - TinkoffInvestTokenProvider

    public func provideToken() -> String {
        return token
    }
}
