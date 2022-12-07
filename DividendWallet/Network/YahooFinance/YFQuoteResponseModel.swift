//
//  YFQuoteResponseModel.swift
//  DividendWallet
//
//  Created by Joshua Ching on 12/7/22.
//

import Foundation

struct YFQuoteResponseModel: Codable {
    let quoteResponse: YFQuoteResponse
}

struct YFQuoteResponse: Codable {
    let result: [YFQuoteResult]
}

struct YFQuoteResult: Codable {
    let symbol: String
    let quoteType: String
    let trailingAnnualDividendRate: Double? // dividend dollar amount
    let trailingAnnualDividendYield: Double? // dividend percentage yield
}
