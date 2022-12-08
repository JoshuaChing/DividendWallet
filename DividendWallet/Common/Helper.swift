//
//  Helper.swift
//  DividendWallet
//
//  Created by Joshua Ching on 12/7/22.
//

import Foundation

extension Double {
    func toMoneyString() -> String {
        return "$\(String(format: "%.2f", self))"
    }
}
