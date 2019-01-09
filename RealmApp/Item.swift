//
//  Item.swift
//  RealmApp
//
//  Created by Rahul Chopra on 09/01/19.
//  Copyright © 2019 Rahul Chopra. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var picture = "todo"
    
}
