//
//  YFQuoteSummaryModel.swift
//  Dividend Wallet
//
//  Created by Joshua Ching on 12/23/22.
//

import Foundation

struct YFQuoteSummaryModel: Codable {
    let quoteSummary: YFQuoteSummary
}

struct YFQuoteSummary: Codable {
    let result: [YFQuoteSummaryResult]
}

struct YFQuoteSummaryResult: Codable {
    let summaryDetail: YFSummaryDetail
    let defaultKeyStatistics: YFDefaultKeyStatistics
}

struct YFSummaryDetail: Codable {
    let dividendRate: YFRawValueModel
    let dividendYield: YFRawValueModel
    let exDividendDate: YFRawValueModel
    let trailingAnnualDividendRate: YFRawValueModel
    let trailingAnnualDividendYield: YFRawValueModel
}

struct YFDefaultKeyStatistics: Codable {
    let lastDividendValue: YFRawValueModel
    let lastDividendDate: YFRawValueModel
}

struct YFRawValueModel: Codable {
    let raw: Double?
}
