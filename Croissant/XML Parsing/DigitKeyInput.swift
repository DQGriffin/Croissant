//
//  DigitKeyInput.swift
//  Croissant
//
//  Created by Dquavius Griffin on 6/15/22.
//

import Foundation

struct DigitKeyInput: Codable {
    var key: Int
    var action: String
    var destination: String?
    
    enum CodingKeys: String, CodingKey {
        case key = "Key"
        case action = "Action"
        case destination = "Destination"
    }
}
