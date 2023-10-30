//
//  ChargeResponse.swift
//  BC2-New
//
//  Created by 신아인 on 10/30/23.
//

import Foundation

struct ChargeResponse: Decodable {
    var email: String
    var balance: String
    var charged_money: String
    var mid: Int
    var type: String
}
