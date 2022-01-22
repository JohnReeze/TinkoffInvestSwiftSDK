//
//  UserService.swift
//  TinkoffInvestSwiftSDK
//
//  Created by m.monakov on 19.01.2022.
//

import Combine
import GRPC
import CombineGRPC

public protocol UserService {
    func getAccounts() -> AnyPublisher<GetAccountsResponse, RPCError>

    func getUserInfo() -> AnyPublisher<GetInfoResponse, RPCError>

    func getMarginAttributes(accountID: String) -> AnyPublisher<GetMarginAttributesResponse, RPCError>

    func getUserTariffRequest() -> AnyPublisher<GetUserTariffResponse, RPCError>
}

final class GRPCUserService: BaseCombineGRPCService, UserService {

    private lazy var client = UsersServiceClient(channel: channel)

    // MARK: - UserService

    func getAccounts() -> AnyPublisher<GetAccountsResponse, RPCError> {
        return executor.call(client.getAccounts)(GetAccountsRequest())
    }

    func getUserInfo() -> AnyPublisher<GetInfoResponse, RPCError> {
        return executor.call(client.getInfo)(.init())
    }

    func getMarginAttributes(accountID: String) -> AnyPublisher<GetMarginAttributesResponse, RPCError> {
        var request = GetMarginAttributesRequest()
        request.accountID = accountID
        return executor.call(client.getMarginAttributes)(request)
    }

    func getUserTariffRequest() -> AnyPublisher<GetUserTariffResponse, RPCError> {
        return executor.call(client.getUserTariff)(GetUserTariffRequest())
    }
}
