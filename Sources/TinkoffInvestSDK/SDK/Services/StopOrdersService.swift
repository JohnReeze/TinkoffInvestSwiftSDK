//
//  StopOrdersService.swift
//  TinkoffInvestSDK
//
//  Created by m.monakov on 30.01.2022.
//

import Foundation

import Combine
import GRPC
import CombineGRPC

public protocol StopOrdersService: AnyObject {

    func postStopOrder(request: PostStopOrderRequest) -> AnyPublisher<PostStopOrderResponse, RPCError>

    func getStopOrders(request: GetStopOrdersRequest) -> AnyPublisher<GetStopOrdersResponse, RPCError>

    func cancelStopOrders(request: CancelStopOrderRequest) -> AnyPublisher<CancelStopOrderResponse, RPCError>
}

final class GRPCStopOrdersService: BaseCombineGRPCService, StopOrdersService {

    // MARK: - Private

    private lazy var client = StopOrdersServiceClient(channel: channel)

    // MARK: - StopOrdersService

    func postStopOrder(request: PostStopOrderRequest) -> AnyPublisher<PostStopOrderResponse, RPCError> {
        return executor.call(client.postStopOrder)(request)
    }

    func getStopOrders(request: GetStopOrdersRequest) -> AnyPublisher<GetStopOrdersResponse, RPCError> {
        return executor.call(client.getStopOrders)(request)
    }

    func cancelStopOrders(request: CancelStopOrderRequest) -> AnyPublisher<CancelStopOrderResponse, RPCError> {
        return executor.call(client.cancelStopOrder)(request)
    }
}
