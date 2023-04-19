//
//  NotificationCenterManager.swift
//  Dividend Wallet
//
//  Created by Joshua Ching on 4/6/23.
//

import Foundation

struct NotificationCenterManager {
    private static let UPDATE_POSITIONS_NOTIFICATION = Notification.Name("UpdatePositionsNotification")
    private static let UPDATE_POSITIONS_DIVIDENDS_NOTIFICATION = Notification.Name("UpdatePositionsDividendsNotification")
    private static let UPDATE_POSITIONS_DIVIDEND_HISTORY_NOTIFICATION = Notification.Name("UpdatePositionsDividendHistoryNotification")

    // MARK: handling notifications for portfolio updates

    static func postUpdatePositions(positions: [PortfolioPositionModel]) {
        NotificationCenter.default.post(name: NotificationCenterManager.UPDATE_POSITIONS_NOTIFICATION, object: positions)
    }

    static func getUpdatePositionsPublisher() -> NotificationCenter.Publisher {
        return NotificationCenter.default.publisher(for: NotificationCenterManager.UPDATE_POSITIONS_NOTIFICATION)
    }

    // MARK: handling notifications for portfolio dividend data updates

    static func postUpdatePositionsDividends(positions: [PortfolioPositionDividendModel]) {
        NotificationCenter.default.post(name: NotificationCenterManager.UPDATE_POSITIONS_DIVIDENDS_NOTIFICATION, object: positions)
    }

    static func getUpdatePositionsDividendsPublisher() -> NotificationCenter.Publisher {
        return NotificationCenter.default.publisher(for: NotificationCenterManager.UPDATE_POSITIONS_DIVIDENDS_NOTIFICATION)
    }

    // MARK: handling notifications for portfolio dividend history updates

    static func postUpdatePositionsDividendHistory(dividendHistory: PositionsDividendHistoryModel) {
        NotificationCenter.default.post(name: NotificationCenterManager.UPDATE_POSITIONS_DIVIDEND_HISTORY_NOTIFICATION, object: dividendHistory)
    }

    static func getUpdatePositionsDividendHistoryPublisher() -> NotificationCenter.Publisher {
        return NotificationCenter.default.publisher(for: NotificationCenterManager.UPDATE_POSITIONS_DIVIDEND_HISTORY_NOTIFICATION)
    }
}
