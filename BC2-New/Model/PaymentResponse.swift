//
//  PaymentResponse.swift
//  BC2-New
//
//  Created by 신아인 on 10/30/23.
//

import Foundation

struct PaymentResponse: Decodable {
    var bid: Int
    var email: String
    var balance: Int
    var menu: String
    var price: Int
    var quantity: Int
}
