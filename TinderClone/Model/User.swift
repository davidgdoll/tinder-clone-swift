//
//  User.swift
//  TinderClone
//
//  Created by David Doll on 09/05/19.
//  Copyright © 2019 David Doll. All rights reserved.
//

import UIKit

struct User {
    var name: String?
    var age: Int?
    var profession: String?
    var imageUrl1: String?
    var uid: String?
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["fullName"] as? String
        self.age = dictionary["age"] as? Int
        self.profession = dictionary["profession"] as? String
        self.imageUrl1 = dictionary["imageUrl1"] as? String
        self.uid = dictionary["uid"] as? String
    }
}

