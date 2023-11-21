//
//  RealmModel.swift
//  BC2-New
//
//  Created by 신아인 on 10/30/23.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var ownMoney: Int = 0
}
