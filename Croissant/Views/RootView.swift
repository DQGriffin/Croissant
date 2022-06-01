//
//  RootView.swift
//  PDToolbox
//
//  Created by Dquavius Griffin on 5/27/22.
//

import SwiftUI
import AlertToast

struct RootView: View {
    
    @State private var isShowingAboutView = false 
    
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
                    isShowingAboutView.toggle()
                    print("Toggle")
                } label: {
                    Label("About Croissant", systemImage: isShowingAboutView ? "x.circle" : "info.circle")
                }
            }
        }
        .sheet(isPresented: $isShowingAboutView) {
            AboutView(isPresented: $isShowingAboutView)
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
    
}
