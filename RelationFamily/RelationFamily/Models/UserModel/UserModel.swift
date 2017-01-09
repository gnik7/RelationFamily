//
//  UserModel.swift
//  RelationFamily
//
//  Created by Nikita Gil on 08.01.17.
//  Copyright © 2017 Nikita Gil. All rights reserved.
//

import Foundation

class UserModel {
    var name: String?
    var type: UserNumber?
    var relation: String?
    var indexRelation: Int?
    
    init(name: String, type: UserNumber, relation: String, indexRelation: Int) {
        self.name = name
        self.type = type
        self.relation = relation
        self.indexRelation = indexRelation
    }
    
}
