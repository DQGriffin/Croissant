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
        attributions.append(LibraryAttribution(name: "CoreXLSX", link: "https://github.com/CoreOffice/CoreXLSX"))
        attributions.append(LibraryAttribution(name: "XMLCoder", link: "https://github.com/CoreOffice/XMLCoder"))
        attributions.append(LibraryAttribution(name: "ZIPFoundation", link: "https://github.com/weichsel/ZIPFoundation"))
    }
    
}
