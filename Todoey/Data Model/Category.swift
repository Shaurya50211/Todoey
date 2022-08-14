//
//  Category.swift
//  Todoey
//
//  Created by Shaurya Gupta on 2022-08-12.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
