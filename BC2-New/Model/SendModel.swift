//
//  SendModel.swift
//  BC2-New
//
//  Created by 신아인 on 10/30/23.
//

import Foundation

struct chargeRequest: Codable {
    let email: String
    let balance: Int
    let charged_money: Int
}
