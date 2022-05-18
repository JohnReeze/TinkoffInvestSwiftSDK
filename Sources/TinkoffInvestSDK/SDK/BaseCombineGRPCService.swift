//
//  BaseCombineGRPCService.swift
//  TinkoffInvestSwiftSDK
//
//  Created by m.monakov on 19.01.2022.
//

import CombineGRPC
import Combine
import GRPC

private enum Constants {
    static let investURL = "invest-public-api.tinkoff.ru"
    static let investPort = 443
}

class BaseCombineGRPCService {

    // MARK: - Private Properties

    private let group = PlatformSupport.makeEventLoopGroup(loopCount: 1)
    private let tokenProvider: TinkoffInvestTokenProvider
    private let appName: String
    private lazy var defaulCallOptions = CurrentValueSubject<CallOptions, Never>(
        CallOptions(
            customMetadata: [
                "Authorization": "Bearer \(tokenProvider.provideToken())",
                "x-app-name": appName
            ]
        )
    ).eraseToAnyPublisher()

    // MARK: - Internal Properties

    lazy var channel = try! GRPCChannelPool.with(target: .hostAndPort(Constants.investURL, Constants.investPort),
                                                 transportSecurity: .tls(.makeClientConfigurationBackedByNIOSSL()),
                                                 eventLoopGroup: group)
    lazy var executor = GRPCExecutor(callOptions: defaulCallOptions)

    // MARK: - Initialization

    init(tokenProvider: TinkoffInvestTokenProvider, appName: String) {
        self.tokenProvider = tokenProvider
        self.appName = appName
    }

    deinit {
        try? group.syncShutdownGracefully()
    }
}
