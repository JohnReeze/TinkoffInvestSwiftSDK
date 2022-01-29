//
//  MarketDataService.swift
//  TinkoffInvestSDK
//
//  Created by m.monakov on 27.01.2022.
//

import Combine
import GRPC
import CombineGRPC

public protocol MarketDataService: AnyObject {
    func getCandels(request: GetCandlesRequest) -> AnyPublisher<GetCandlesResponse, RPCError>

    func getLastPrices(figi: [String]) -> AnyPublisher<GetLastPricesResponse, RPCError>

    func getOrderBook(figi: String, depth: Int) -> AnyPublisher<GetOrderBookResponse, RPCError>

    func getTradingStatus(figi: String) -> AnyPublisher<GetTradingStatusResponse, RPCError>
}

final class GRPCMarketDataService: BaseCombineGRPCService, MarketDataService {

    // MARK: - Private

    private lazy var client = MarketDataServiceClient(channel: channel)

    // MARK: - MarketDataService

    func getCandels(request: GetCandlesRequest) -> AnyPublisher<GetCandlesResponse, RPCError> {
        return executor.call(client.getCandles)(request)
    }

    func getLastPrices(figi: [String]) -> AnyPublisher<GetLastPricesResponse, RPCError> {
        var request = GetLastPricesRequest()
        request.figi = figi
        return executor.call(client.getLastPrices)(request)
    }

    func getOrderBook(figi: String, depth: Int) -> AnyPublisher<GetOrderBookResponse, RPCError> {
        var request = GetOrderBookRequest()
        request.figi = figi
        request.depth = Int32(depth)
        return executor.call(client.getOrderBook)(request)
    }

    func getTradingStatus(figi: String) -> AnyPublisher<GetTradingStatusResponse, RPCError> {
        var request = GetTradingStatusRequest()
        request.figi = figi
        return executor.call(client.getTradingStatus)(request)
    }
}
