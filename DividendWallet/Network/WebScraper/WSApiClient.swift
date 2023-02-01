//
//  WSApiClient.swift
//  Dividend Wallet
//
//  Created by Joshua Ching on 1/17/23.
//

import Foundation
import SwiftSoup

class WSApiClient {
    static let shared = WSApiClient()

    private struct Constants {
        static let dividendComUrlFormat = "https://www.dividend.com/etfs/%@"
        static let dividendComDistributions = "distributions--dividend-payout-history"
        static let dividendComColumnLimit = 2
        static let dividendComDateColumn = 0
        static let dividendComAmountColumn = 1
        static let dividendComAmountPrefix = "$"
        static let dividendComDateFormat = "MMM dd, yyyy"

        static let dividendInvestorUrlFormat = "https://www.dividendinvestor.com/dividend-history-detail/%@/"
        static let dividendInvestorColumnLimit = 5;
        static let dividendInvestorDateColumn = 3
        static let dividendInvestorAmountColumn = 5;
        static let dividendInvestorDateFormat = "MM/dd/yy"

        static let dividendsTag = "dividends"
        static let detailTag = "detail"
        static let mobileTag = "mobile"
        static let tbodyTag = "tbody"
        static let tdTag = "td"
        static let trTag = "tr"
    }

    func getDividendEventsForFund(symbol: String) -> [WSDividendEventModel] {
        var events = [WSDividendEventModel]()
        if let url = URL(string: String(format: Constants.dividendComUrlFormat, symbol)) {
            do {
                let html = try String(contentsOf: url)
                let document = try SwiftSoup.parseBodyFragment(html)
                let dividendsTable = try document.getElementsByClass(Constants.dividendComDistributions).first()
                let tbody = try dividendsTable?.getElementsByTag(Constants.tbodyTag).first()
                if let rows = try tbody?.getElementsByTag(Constants.trTag), rows.count > 0 {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = Constants.dividendComDateFormat
                    for row in rows {
                        let cols = try row.getElementsByTag(Constants.tdTag)
                        if cols.count >= Constants.dividendComColumnLimit {
                            let dateString = try cols[Constants.dividendComDateColumn].text()
                            var amountString = try cols[Constants.dividendComAmountColumn].text()
                            if amountString.hasPrefix(Constants.dividendComAmountPrefix) {
                                amountString = String(amountString.dropFirst())
                            }
                            if let amount = Double(amountString), let date = dateFormatter.date(from: dateString) {
                                events.append(WSDividendEventModel(date: date, amount: amount))
                            }
                        }
                    }
                }
            } catch {
                print(error)
            }
        }
        return events
    }

    func getDividendEventsForIndividualEquity(symbol: String) -> [WSDividendEventModel]{
        var events = [WSDividendEventModel]()
        if let url = URL(string: String(format: Constants.dividendInvestorUrlFormat, symbol)) {
            do {
                let html = try String(contentsOf: url)
                let document = try SwiftSoup.parse(html)
                let dividendsTable = try document.getElementById(Constants.dividendsTag)
                let tbody = try dividendsTable?.getElementsByTag(Constants.tbodyTag).first()
                if let rows = try tbody?.getElementsByClass(Constants.detailTag), rows.count > 0 {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = Constants.dividendInvestorDateFormat
                    for row in rows {
                        let cols = try row.getElementsByTag(Constants.tdTag)
                        if cols.count >= Constants.dividendInvestorColumnLimit,
                           let dateString = try cols[Constants.dividendInvestorDateColumn].getElementsByClass(Constants.mobileTag).first()?.text(),
                           let amountString = try cols[Constants.dividendInvestorAmountColumn].getElementsByTag(Constants.tdTag).first()?.text(),
                           let amount = Double(amountString), let date = dateFormatter.date(from: dateString) {
                            events.append(WSDividendEventModel(date: date, amount: amount))
                        }
                    }
                }
            } catch {
                print(error)
            }
        }
        return events
    }
}
