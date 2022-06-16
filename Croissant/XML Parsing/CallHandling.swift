//
//  CallHandling.swift
//  Croissant
//
//  Created by Dquavius Griffin on 6/15/22.
//

import Foundation

struct CallHandling: Codable {
    var keyPresses: [DigitKeyInput]
    
    enum CodingKeys: String, CodingKey {
        case keyPresses = "DigitKeyInput"
    }
}
