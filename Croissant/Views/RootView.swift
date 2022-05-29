//
//  RootView.swift
//  PDToolbox
//
//  Created by Dquavius Griffin on 5/27/22.
//

import SwiftUI

struct RootView: View {
    
    var body: some View {
        NavigationView {
            SidebarView()
            MainView()
        }
        .toolbar {
            ToolbarItem(placement: ToolbarItemPlacement.navigation) {
                Button {
                    NSApp.keyWindow?.firstResponder?.tryToPerform(
                        #selector(NSSplitViewController.toggleSidebar(_:)), with: nil
                    )
                } label: {
                    Label("Toggle sidebar", systemImage: "sidebar.left")
                }
                .onAppear {
                    NSApp.keyWindow?.firstResponder?.tryToPerform(
                        #selector(NSSplitViewController.toggleSidebar(_:)), with: nil
                    )
                }
            }
            ToolbarItem(placement: ToolbarItemPlacement.status) {
                Button {
                    
                } label: {
                    Label("About Croissant", systemImage: "info.circle")
                }
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
    
}
