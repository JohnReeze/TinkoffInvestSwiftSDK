//
//  MarketDataStreamService.swift
//  TinkoffInvestSDK
//
//  Created by m.monakov on 27.01.2022.
//

import Combine
import GRPC
import CombineGRPC
import Foundation

public typealias MarketDataPublisher = AnyPublisher<MarketDataResponse, RPCError>

public protocol MarketDataStreamService: AnyObject {
    func subscribeToTrades(figi: String) -> MarketDataPublisher
    func unsubscribeFromTrades(figi: String) -> MarketDataPublisher

    func subscribeToCandels(figi: String, interval: SubscriptionInterval) -> MarketDataPublisher
    func unsubscribeFromCandels(figi: String, interval: SubscriptionInterval) -> MarketDataPublisher

    func subscribeToOrderBook(figi: String, depth: Int) -> MarketDataPublisher
    func unsubscribeFromOrderBook(figi: String, depth: Int)  -> MarketDataPublisher

    func subscribeToInfo(figi: String) -> MarketDataPublisher
    func unsubscribeFromInfo(figi: String) -> MarketDataPublisher

    func cancelAllSubscribtions()
}

final class GRPCMarketDataStreamService: BaseCombineGRPCService, MarketDataStreamService {

    // MARK: - Private

    private lazy var client = MarketDataStreamServiceClient(channel: channel)

    private var currentRequestPublsher: AnyPublisher<MarketDataRequest, Error> {
        return inputSubject.eraseToAnyPublisher()
    }

    private var inputSubject = PassthroughSubject<MarketDataRequest, Error>()
    private var currentResponsePublisher: MarketDataPublisher?

    // MARK: - MarketDataStreamService

    func subscribeToTrades(figi: String) -> MarketDataPublisher {
        return performTrades(action: .subscribe, figi: figi)
    }

    func unsubscribeFromTrades(figi: String) -> MarketDataPublisher {
        return performTrades(action: .unsubscribe, figi: figi)
    }

    func subscribeToCandels(figi: String, interval: SubscriptionInterval) -> MarketDataPublisher {
        return performCandels(action: .subscribe, figi: figi, interval: interval)
    }

    func unsubscribeFromCandels(figi: String, interval: SubscriptionInterval) -> MarketDataPublisher {
        return performCandels(action: .unsubscribe, figi: figi, interval: interval)
    }

    func subscribeToOrderBook(figi: String, depth: Int) -> MarketDataPublisher {
        return performOrderBook(action: .subscribe, figi: figi, depth: depth)
    }

    func unsubscribeFromOrderBook(figi: String, depth: Int)  -> MarketDataPublisher {
        return performOrderBook(action: .unsubscribe, figi: figi, depth: depth)
    }

    func subscribeToInfo(figi: String) -> MarketDataPublisher {
        return performInfo(action: .subscribe, figi: figi)
    }

    func unsubscribeFromInfo(figi: String) -> MarketDataPublisher {
        return performInfo(action: .unsubscribe, figi: figi)
    }

    func cancelAllSubscribtions() {
        inputSubject.send(completion: .finished)
        currentResponsePublisher = nil
    }

    // MARK: - Private help methods

    private func performTrades(action: SubscriptionAction, figi: String) -> MarketDataPublisher {
        let subscribeRequest = SubscribeTradesRequest.create(figi: figi, action: action)
        return makeMarket(request: .create(with: subscribeRequest))
    }

    private func performCandels(action: SubscriptionAction, figi: String, interval: SubscriptionInterval) -> MarketDataPublisher {
        let candelsRequest = SubscribeCandlesRequest.create(action: action, figi: figi, interval: interval)
        return makeMarket(request: .create(with: candelsRequest))
    }

    private func performOrderBook(action: SubscriptionAction, figi: String, depth: Int) -> MarketDataPublisher {
        let orderBookRequest = SubscribeOrderBookRequest.create(action: action, figi: figi, depth: depth)
        return makeMarket(request: .create(with: orderBookRequest))
    }

    private func performInfo(action: SubscriptionAction, figi: String) -> MarketDataPublisher {
        let infoRequest = SubscribeInfoRequest.create(action: action, figi: figi)
        return makeMarket(request: .create(with: infoRequest))
    }

    private func makeMarket(request: MarketDataRequest) -> MarketDataPublisher  {
        if let currentResponsePublisher = currentResponsePublisher {
            inputSubject.send(request)
            return currentResponsePublisher
        }

        defer {
            self.inputSubject.send(request)
        }

        let responsePublisher = executor.call(client.marketDataStream)(currentRequestPublsher)
        self.currentResponsePublisher = responsePublisher
        return responsePublisher
    }
}

private extension SubscribeInfoRequest {
    static func create(action: SubscriptionAction, figi: String) -> SubscribeInfoRequest {
        var request = SubscribeInfoRequest()
        var instrument = InfoInstrument()
        instrument.figi = figi
        request.instruments = [instrument]
        request.subscriptionAction = action
        return request
    }
}

private extension SubscribeOrderBookRequest {
    static func create(action: SubscriptionAction, figi: String, depth: Int) -> SubscribeOrderBookRequest {
        var orderBookRequest = SubscribeOrderBookRequest()
        orderBookRequest.subscriptionAction = action
        var instrument = OrderBookInstrument()
        instrument.figi = figi
        instrument.depth = Int32(depth)
        orderBookRequest.instruments = [instrument]
        return orderBookRequest
    }
}

private extension SubscribeCandlesRequest {
    static func create(action: SubscriptionAction, figi: String, interval: SubscriptionInterval) -> SubscribeCandlesRequest {
        var candelsRequest = SubscribeCandlesRequest()
        var instrument = CandleInstrument()
        instrument.figi = figi
        instrument.interval = interval
        candelsRequest.subscriptionAction = action
        candelsRequest.instruments = [instrument]
        return candelsRequest
    }
}

private extension SubscribeTradesRequest {
    static func create(figi: String, action: SubscriptionAction) -> SubscribeTradesRequest {
        var tradeRequest = SubscribeTradesRequest()
        tradeRequest.subscriptionAction = action
        var instrument = TradeInstrument()
        instrument.figi = figi
        tradeRequest.instruments = [instrument]
        return tradeRequest
    }
}

private extension MarketDataRequest {
    static func create(with infoRequest: SubscribeInfoRequest) -> MarketDataRequest {
        var request = MarketDataRequest()
        request.payload = .subscribeInfoRequest(infoRequest)
        return request
    }

    static func create(with orderBookRequest: SubscribeOrderBookRequest) -> MarketDataRequest {
        var request = MarketDataRequest()
        request.payload = .subscribeOrderBookRequest(orderBookRequest)
        return request
    }

    static func create(with tradeRequest: SubscribeTradesRequest) -> MarketDataRequest {
        var request = MarketDataRequest()
        request.payload = .subscribeTradesRequest(tradeRequest)
        return request
    }

    static func create(with candelsRequest: SubscribeCandlesRequest) -> MarketDataRequest {
        var request = MarketDataRequest()
        request.payload = .subscribeCandlesRequest(candelsRequest)
        return request
    }
}
