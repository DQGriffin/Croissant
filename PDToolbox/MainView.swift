//
//  MainView.swift
//  PDToolbox
//
//  Created by Dquavius Griffin on 5/25/22.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("Select File . . .")
            Button {
                print("")
            } label: {
                Text("Select File . . .")
            }

            Spacer()
            HStack {
                VStack {
                    Divider()
                }
                Text("Or")
                VStack {
                    Divider()
                }
            }
            Spacer()
            Text("Drag and Dop")
            Spacer()
        }
        .frame(width: 500, height: 450)
        .onDrop(of: ["public.url", "public.file-url"], isTargeted: nil) { providers in
            print("Hey, you dropped a file")
            if let item = providers.first {
                if let identifier = item.registeredTypeIdentifiers.first {
                    if identifier == "public.ur" || identifier == "public.file-url" {
                        item.loadItem(forTypeIdentifier: identifier, options: nil) { urlData, error in
                            if let urlData = urlData as? Data {
                                let url = NSURL(absoluteURLWithDataRepresentation: urlData, relativeTo: nil) as URL
                                let reader = IVRReader(path: url.path)
                            }
                        }
                    }
                }
            }
            return true
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
