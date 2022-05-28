//
//  Sidebar.swift
//  PDToolbox
//
//  Created by Dquavius Griffin on 5/27/22.
//

import SwiftUI

struct SidebarView: View {
    
    @ObservedObject var viewModel = SidebarViewModel()
    @State private var selectedCategory: SidebarCategory?
    
    var body: some View {
        List(viewModel.options) { option in
            NavigationLink(
                destination: viewModel.destination(forCategoryNamed: option.category),
                tag: option,
                selection: $selectedCategory,
                label: {
                    HStack {
                        Image(systemName: "folder")
                        Text(option.category)
                    }
                })
        }
        .frame(minWidth: 215)
        .listStyle(.sidebar)
    }
}

struct Sidebar_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView()
    }
}
