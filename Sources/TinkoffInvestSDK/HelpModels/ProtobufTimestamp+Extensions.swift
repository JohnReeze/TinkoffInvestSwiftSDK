//
//  ProtobufTimestamp+Extensions.swift
//  TinkoffInvestSDK
//
//  Created by m.monakov on 27.01.2022.
//

import SwiftProtobuf
import Foundation

public extension Date {

    var asProtobuf: Google_Protobuf_Timestamp {
        return Google_Protobuf_Timestamp(date: self)
    }
}
