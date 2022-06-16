//
//  MultiLevelIVR.swift
//  Croissant
//
//  Created by Dquavius Griffin on 6/16/22.
//

import Foundation

class MultiLevelIVR: Codable {
    var menus: [Menu]
    
    init() {
        menus = []
    }
    
    enum CodingKeys: String, CodingKey {
        case menus = "Menu"
    }
}
