//
//  TinkoffInvestSDK.swift
//  TinkoffInvestSwiftSDK
//
//  Created by m.monakov on 19.01.2022.
//

public class TinkoffInvestSDK {

    // Properties
    private let commonTokenProvider: TinkoffInvestTokenProvider

    // MARK: - Initialization

    public init(tokenProvider: TinkoffInvestTokenProvider) {
        self.commonTokenProvider = tokenProvider
    }

    // MARK: - Services

    public lazy var portfolioService: PortfolioService = GRPCPortfolioService(tokenProvider: commonTokenProvider)

    public lazy var userService: UserService = GRPCUserService(tokenProvider: commonTokenProvider)

    public lazy var instrumentsService: InstrumentsService = GRPCInstrumentsService(tokenProvider: commonTokenProvider)

    public lazy var marketDataService: MarketDataService = GRPCMarketDataService(tokenProvider: commonTokenProvider)

    public lazy var marketDataServiceStream: MarketDataStreamService = GRPCMarketDataStreamService(tokenProvider: commonTokenProvider)

    public lazy var stopOrdersService: StopOrdersService = GRPCStopOrdersService(tokenProvider: commonTokenProvider)
}
