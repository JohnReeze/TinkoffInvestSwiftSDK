//
//  TinkoffInvestSDK.swift
//  TinkoffInvestSwiftSDK
//
//  Created by m.monakov on 19.01.2022.
//

public class TinkoffInvestSDK {

    // Properties
    private let commonTokenProvider: TinkoffInvestTokenProvider
    private let sandboxTokenProvider: TinkoffInvestTokenProvider?

    // MARK: - Initialization

    public init(tokenProvider: TinkoffInvestTokenProvider, sandboxTokenProvider: TinkoffInvestTokenProvider? = nil) {
        self.commonTokenProvider = tokenProvider
        self.sandboxTokenProvider = sandboxTokenProvider
    }

    // MARK: - Services

    public lazy var portfolioService: PortfolioService = GRPCPortfolioService(tokenProvider: commonTokenProvider)

    public lazy var userService: UserService = GRPCUserService(tokenProvider: commonTokenProvider)

    public lazy var instrumentsService: InstrumentsService = GRPCInstrumentsService(tokenProvider: commonTokenProvider)
}
