//
//  SidebarViewModel.swift
//  PDToolbox
//
//  Created by Dquavius Griffin on 5/27/22.
//

import Foundation
import SwiftUI

class SidebarViewModel: ObservableObject {
    var options: [SidebarCategory]
    
    init() {
        options = []
        options.append(SidebarCategory(category: "IVR Tools"))
    }
    
    @ViewBuilder
    func destination(forCategoryNamed category: String) ->  some View {
        switch category {
        case "IVR Tools":
            MainView()
        default:
            MainView()
        }
    }
    
}
