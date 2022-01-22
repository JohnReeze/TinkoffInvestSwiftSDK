//
//  InstrumentsService.swift
//  TinkoffInvestSDK
//
//  Created by m.monakov on 22.01.2022.
//

import Combine
import GRPC
import CombineGRPC

public struct InstrumentParameters {

    /// Тип идентификатора инструмента. Возможные значения: figi, ticker, isin. Подробнее об идентификации инструментов: [Идентификация инструментов](/investAPI/faq_identification/)
    public let idType: InstrumentIdType

    /// Идентификатор class_code. Обязателен при id_type = ticker.
    public let classCode: String

    /// Идентификатор запрашиваемого инструмента.
    public let id: String

    public init(idType: InstrumentIdType = .instrumentIDUnspecified,
                classCode: String = String(),
                id: String = String()) {
        self.idType = idType
        self.classCode = classCode
        self.id = id
    }

    var toInstrumentRequest: InstrumentRequest {
        var request = InstrumentRequest()
        request.id = id
        request.idType = idType
        request.classCode = classCode
        return request
    }
}

public protocol InstrumentsService {

    func getTradingSchedules() -> AnyPublisher<TradingSchedulesResponse, RPCError>
    func getAccruedInterests(request: GetAccruedInterestsRequest) -> AnyPublisher<GetAccruedInterestsResponse, RPCError>
    func getFuturesMargin(request: GetFuturesMarginRequest) -> AnyPublisher<GetFuturesMarginResponse, RPCError>
    func getInstrumentBy(params: InstrumentParameters) -> AnyPublisher<InstrumentResponse, RPCError>
    func getDividends(request: GetDividendsRequest) -> AnyPublisher<GetDividendsResponse, RPCError>

    func getBond(params: InstrumentParameters) -> AnyPublisher<BondResponse, RPCError>
    func getBonds(with status: InstrumentStatus) -> AnyPublisher<BondsResponse, RPCError>

    func getCurrency(params: InstrumentParameters) -> AnyPublisher<CurrencyResponse, RPCError>
    func getCurrencies(with status: InstrumentStatus) -> AnyPublisher<CurrenciesResponse, RPCError>

    func getEtf(params: InstrumentParameters) -> AnyPublisher<EtfResponse, RPCError>
    func getEtfs(with status: InstrumentStatus) -> AnyPublisher<EtfsResponse, RPCError>

    func getFuture(params: InstrumentParameters) -> AnyPublisher<FutureResponse, RPCError>
    func getFutures(with status: InstrumentStatus) -> AnyPublisher<FuturesResponse, RPCError>

    func getShare(params: InstrumentParameters) -> AnyPublisher<ShareResponse, RPCError>
    func getShares(with status: InstrumentStatus) -> AnyPublisher<SharesResponse, RPCError>
}

final class GRPCInstrumentsService: BaseCombineGRPCService, InstrumentsService {

    private lazy var client = InstrumentsServiceClient(channel: channel)

    // MARK: - InstrumentsService

    func getTradingSchedules() -> AnyPublisher<TradingSchedulesResponse, RPCError> {
        return executor.call(client.tradingSchedules)(TradingSchedulesRequest())
    }

    func getAccruedInterests(request: GetAccruedInterestsRequest) -> AnyPublisher<GetAccruedInterestsResponse, RPCError> {
        return executor.call(client.getAccruedInterests)(request)
    }

    func getFuturesMargin(request: GetFuturesMarginRequest) -> AnyPublisher<GetFuturesMarginResponse, RPCError> {
        return executor.call(client.getFuturesMargin)(request)
    }

    func getInstrumentBy(params: InstrumentParameters) -> AnyPublisher<InstrumentResponse, RPCError> {
        return executor.call(client.getInstrumentBy(_:callOptions:))(params.toInstrumentRequest)
    }

    func getDividends(request: GetDividendsRequest) -> AnyPublisher<GetDividendsResponse, RPCError> {
        return executor.call(client.getDividends(_:callOptions:))(request)
    }

    // MARK: - Bonds

    func getBond(params: InstrumentParameters) -> AnyPublisher<BondResponse, RPCError> {
        return executor.call(client.bondBy)(params.toInstrumentRequest)
    }

    func getBonds(with status: InstrumentStatus) -> AnyPublisher<BondsResponse, RPCError> {
        var request = InstrumentsRequest()
        request.instrumentStatus = status
        return executor.call(client.bonds)(request)
    }

    // MARK: - Currencies

    func getCurrency(params: InstrumentParameters) -> AnyPublisher<CurrencyResponse, RPCError> {
        return executor.call(client.currencyBy)(params.toInstrumentRequest)
    }

    func getCurrencies(with status: InstrumentStatus) -> AnyPublisher<CurrenciesResponse, RPCError> {
        var request = InstrumentsRequest()
        request.instrumentStatus = status
        return executor.call(client.currencies)(request)
    }

    // MARK: - Etfs

    func getEtf(params: InstrumentParameters) -> AnyPublisher<EtfResponse, RPCError> {
        return executor.call(client.etfBy)(params.toInstrumentRequest)
    }

    func getEtfs(with status: InstrumentStatus) -> AnyPublisher<EtfsResponse, RPCError> {
        var request = InstrumentsRequest()
        request.instrumentStatus = status
        return executor.call(client.etfs)(request)
    }

    // MARK: - Futures

    func getFuture(params: InstrumentParameters) -> AnyPublisher<FutureResponse, RPCError> {
        return executor.call(client.futureBy)(params.toInstrumentRequest)
    }

    func getFutures(with status: InstrumentStatus) -> AnyPublisher<FuturesResponse, RPCError> {
        var request = InstrumentsRequest()
        request.instrumentStatus = status
        return executor.call(client.futures)(request)
    }

    // MARK: - Shares

    func getShare(params: InstrumentParameters) -> AnyPublisher<ShareResponse, RPCError> {
        return executor.call(client.shareBy)(params.toInstrumentRequest)
    }

    func getShares(with status: InstrumentStatus) -> AnyPublisher<SharesResponse, RPCError> {
        var request = InstrumentsRequest()
        request.instrumentStatus = status
        return executor.call(client.shares)(request)
    }
}
