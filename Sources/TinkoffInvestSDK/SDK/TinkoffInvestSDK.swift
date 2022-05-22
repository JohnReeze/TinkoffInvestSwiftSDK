//
//  TinkoffInvestSDK.swift
//  TinkoffInvestSwiftSDK
//
//  Created by m.monakov on 19.01.2022.
//

public class TinkoffInvestSDK {

    // Properties
    private let appName: String

    private let commonTokenProvider: TinkoffInvestTokenProvider
    private let sandboxTokenProvider: TinkoffInvestTokenProvider?

    // MARK: - Initialization

    public init(appName: String = "JohnReeze.TinkoffInvestSwiftSDK",
                tokenProvider: TinkoffInvestTokenProvider,
                sandbox sandboxTokenProvider: TinkoffInvestTokenProvider? = nil) {
        self.appName = appName
        self.commonTokenProvider = tokenProvider
        self.sandboxTokenProvider = sandboxTokenProvider
    }

    // MARK: - Services

    public lazy var portfolioService: PortfolioService = GRPCPortfolioService(tokenProvider: commonTokenProvider, appName: appName)

    public lazy var userService: UserService = GRPCUserService(tokenProvider: commonTokenProvider, appName: appName)

    public lazy var instrumentsService: InstrumentsService = GRPCInstrumentsService(tokenProvider: commonTokenProvider, appName: appName)

    public lazy var marketDataService: MarketDataService = GRPCMarketDataService(tokenProvider: commonTokenProvider, appName: appName)

    public lazy var marketDataServiceStream: MarketDataStreamService = GRPCMarketDataStreamService(tokenProvider: commonTokenProvider, appName: appName)

    public lazy var stopOrdersService: StopOrdersService = GRPCStopOrdersService(tokenProvider: commonTokenProvider, appName: appName)

    public lazy var ordersService: OrdersService = GRPCOrdersService(tokenProvider: commonTokenProvider, appName: appName)

    public lazy var sandboxService: SandboxService? = {
        guard let token = sandboxTokenProvider else { return nil }
        return GRPCSandboxService(tokenProvider: token, appName: appName)
    }()
}
