//
//  PortfolioService.swift
//  TinkoffInvestSwiftSDK
//
//  Created by m.monakov on 19.01.2022.
//

import Combine
import GRPC
import CombineGRPC

public protocol PortfolioService: AnyObject {

    func getPortfolio(accountID: String) -> AnyPublisher<PortfolioResponse, RPCError>

    func getPositions(accountID: String) -> AnyPublisher<PositionsResponse, RPCError>

    func getWithdrawLimits(accountID: String) -> AnyPublisher<WithdrawLimitsResponse, RPCError>

    func getOperations(request: OperationsRequest) -> AnyPublisher<OperationsResponse, RPCError>
}

final class GRPCPortfolioService: BaseCombineGRPCService, PortfolioService {

    // MARK: - Private

    private lazy var client = OperationsServiceClient(channel: channel)

    // MARK: - PortfolioService

    func getPortfolio(accountID: String) -> AnyPublisher<PortfolioResponse, RPCError> {
        var request = PortfolioRequest()
        request.accountID = accountID
        return executor.call(client.getPortfolio)(request)
    }

    func getPositions(accountID: String) -> AnyPublisher<PositionsResponse, RPCError> {
        var request = PositionsRequest()
        request.accountID = accountID
        return executor.call(client.getPositions)(request)
    }

    func getWithdrawLimits(accountID: String) -> AnyPublisher<WithdrawLimitsResponse, RPCError> {
        var request = WithdrawLimitsRequest()
        request.accountID = accountID
        return executor.call(client.getWithdrawLimits)(request)
    }

    func getOperations(request: OperationsRequest) -> AnyPublisher<OperationsResponse, RPCError> {
        return executor.call(client.getOperations)(request)
    }
}
