//
//  DividendHistoryModel.swift
//  Dividend Wallet
//
//  Created by Joshua Ching on 4/18/23.
//

// for cache: [symbol: [events]]
typealias DividendHistoryModel = [String: [WSDividendEventModel]]

// for notification center manager: [symbol: PositionDividendHistoryModel]
typealias PositionsDividendHistoryModel = [String: PositionDividendHistoryModel]

struct PositionDividendHistoryModel {
    let events: [WSDividendEventModel]
    let shareCount: Double
}
