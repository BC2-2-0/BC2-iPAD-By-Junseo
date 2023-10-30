//
//  ChargeRealmEntity.swift
//  BC2-New
//
//  Created by 신아인 on 10/30/23.
//

import Foundation
import RealmSwift

class ChargeRealmEntity: Object {
    convenience init(balance: String, charged_money: String, emailHash: String) {
        self.init()
        self.uuid = UUID().uuidString
        self.balance = balance
        self.charged_money = charged_money
        self.emailHash = emailHash
    }
    @Persisted (primaryKey: true) var uuid: String
    @Persisted var balance: String
    @Persisted var charged_money: String
    @Persisted var emailHash: String
    
}
