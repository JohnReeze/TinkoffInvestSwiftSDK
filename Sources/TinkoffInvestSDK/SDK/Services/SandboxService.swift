//
//  SandboxService.swift
//  TinkoffInvestSwiftSDK
//
//  Created by Andrey Vasilev on 16.05.2022.
//

import Combine
import GRPC
import CombineGRPC

public protocol SandboxService: OrdersService {
    
    func openAccount() -> AnyPublisher<OpenSandboxAccountResponse, RPCError>
    
    func getAccounts() -> AnyPublisher<GetAccountsResponse, RPCError>
    
    func closeAccount(accountID: String) -> AnyPublisher<CloseSandboxAccountResponse, RPCError>
    
    func getPositions(accountID: String) -> AnyPublisher<PositionsResponse, RPCError>
    
    func getOperations(request: OperationsRequest) -> AnyPublisher<OperationsResponse, RPCError>
    
    func getPortfolio(accountID: String) -> AnyPublisher<PortfolioResponse, RPCError>
    
    func payIn(accountID: String, amount: MoneyValue) -> AnyPublisher<SandboxPayInResponse, RPCError>
}

final class GRPCSandboxService: BaseCombineGRPCService, SandboxService {

    // MARK: - Private

    private lazy var client = SandboxServiceClient(channel: channel)

    // MARK: - SandboxService

    func openAccount() -> AnyPublisher<OpenSandboxAccountResponse, RPCError> {
        return executor.call(client.openSandboxAccount)(OpenSandboxAccountRequest())
    }

    func getAccounts() -> AnyPublisher<GetAccountsResponse, RPCError> {
        return executor.call(client.getSandboxAccounts)(GetAccountsRequest())
    }

    func closeAccount(accountID: String) -> AnyPublisher<CloseSandboxAccountResponse, RPCError> {
        var request = CloseSandboxAccountRequest()
        request.accountID = accountID
        return executor.call(client.closeSandboxAccount)(request)
    }

    func postOrder(request: PostOrderRequest) -> AnyPublisher<PostOrderResponse, RPCError> {
        return executor.call(client.postSandboxOrder)(request)
    }

    func getOrders(accountID: String) -> AnyPublisher<GetOrdersResponse, RPCError> {
        var request = GetOrdersRequest()
        request.accountID = accountID
        return executor.call(client.getSandboxOrders)(request)
    }

    func cancelOrder(accountID: String, orderID: String) -> AnyPublisher<CancelOrderResponse, RPCError> {
        var request = CancelOrderRequest()
        request.accountID = accountID
        request.orderID = orderID
        return executor.call(client.cancelSandboxOrder)(request)
    }

    func getOrderState(accountID: String, orderID: String) -> AnyPublisher<OrderState, RPCError> {
        var request = GetOrderStateRequest()
        request.accountID = accountID
        request.orderID = orderID
        return executor.call(client.getSandboxOrderState)(request)
    }

    func getPositions(accountID: String) -> AnyPublisher<PositionsResponse, RPCError> {
        var request = PositionsRequest()
        request.accountID = accountID
        return executor.call(client.getSandboxPositions)(request)
    }

    func getOperations(request: OperationsRequest) -> AnyPublisher<OperationsResponse, RPCError> {
        return executor.call(client.getSandboxOperations)(request)
    }

    func getPortfolio(accountID: String) -> AnyPublisher<PortfolioResponse, RPCError> {
        var request = PortfolioRequest()
        request.accountID = accountID
        return executor.call(client.getSandboxPortfolio)(request)
    }

    func payIn(accountID: String, amount: MoneyValue) -> AnyPublisher<SandboxPayInResponse, RPCError> {
        var request = SandboxPayInRequest()
        request.accountID = accountID
        request.amount = amount
        return executor.call(client.sandboxPayIn)(request)
    }

}
