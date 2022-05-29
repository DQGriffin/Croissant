//
//  AboutViewModel.swift
//  Croissant
//
//  Created by Dquavius Griffin on 5/28/22.
//

import Foundation

class AboutViewModel: ObservableObject {
    
    var attributions: [LibraryAttribution]
    
    init() {
        attributions = []
        attributions.append(LibraryAttribution(name: "SwiftCSV", link: "https://github.com/swiftcsv/SwiftCSV"))
        attributions.append(LibraryAttribution(name: "Excelify", link: "https://github.com/bruh"))
    }
    
}
