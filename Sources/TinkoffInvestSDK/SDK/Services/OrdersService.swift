//
//  OrdersService.swift
//  TinkoffInvestSwiftSDK
//
//  Created by Andrey Vasilev on 21.05.2022.
//

import Combine
import GRPC
import CombineGRPC

public protocol OrdersService {
    
    func postOrder(request: PostOrderRequest) -> AnyPublisher<PostOrderResponse, RPCError>
    
    func cancelOrder(accountID: String, orderID: String) -> AnyPublisher<CancelOrderResponse, RPCError>
    
    func getOrderState(accountID: String, orderID: String) -> AnyPublisher<OrderState, RPCError>
    
    func getOrders(accountID: String) -> AnyPublisher<GetOrdersResponse, RPCError>
}

final class GRPCOrdersService: BaseCombineGRPCService, OrdersService {

    // MARK: - Private

    private lazy var client = OrdersServiceClient(channel: channel)

    // MARK: - OrdersService

    func postOrder(request: PostOrderRequest) -> AnyPublisher<PostOrderResponse, RPCError> {
        return executor.call(client.postOrder)(request)
    }

    func cancelOrder(accountID: String, orderID: String) -> AnyPublisher<CancelOrderResponse, RPCError> {
        var request = CancelOrderRequest()
        request.accountID = accountID
        request.orderID = orderID
        return executor.call(client.cancelOrder)(request)
    }

    func getOrderState(accountID: String, orderID: String) -> AnyPublisher<OrderState, RPCError> {
        var request = GetOrderStateRequest()
        request.accountID = accountID
        request.orderID = orderID
        return executor.call(client.getOrderState)(request)
    }
    
    func getOrders(accountID: String) -> AnyPublisher<GetOrdersResponse, RPCError> {
        var request = GetOrdersRequest()
        request.accountID = accountID
        return executor.call(client.getOrders)(request)
    }
}
