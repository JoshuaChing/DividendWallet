//
//  YFChartModel.swift
//  DividendWallet
//
//  Created by Joshua Ching on 12/7/22.
//

import Foundation

struct YFChartModel: Codable {
    let chart: YFChart
}

struct YFChart: Codable {
    let result: [YFChartResult]
}

struct YFChartResult: Codable {
    let meta: YFChartMeta
    let events: YFChartEvents?
}

struct YFChartMeta: Codable {
    let symbol: String
    let instrumentType: String
}

struct YFChartEvents: Codable {
    let dividends: [String: dividendModel]?
}

struct dividendModel: Codable {
    let amount: Double
    let date: Int
}
