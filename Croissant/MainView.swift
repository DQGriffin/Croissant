//
//  MainView.swift
//  PDToolbox
//
//  Created by Dquavius Griffin on 5/25/22.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var viewModel = IVRToolsViewModel()
    @State var isShowingAudit = false
    
    var body: some View {
        if !isShowingAudit {
            VStack {
                Spacer()
                Image(systemName: "arrow.down.doc")
                    .resizable()
                    .frame(width: 75, height: 95)
                Text("Drag and drop BRD here")
                    .font(.largeTitle)
                    .padding()
                VStack(alignment: .leading) {
                    Text("1. Drag and drop your BRD into this window")
                        .font(.caption2)
                    Text("2. Check your downloads folder for the generated Auto-Receptionist.xml file")
                        .font(.caption2)
                    Text("3. Upload the file in Service Web")
                        .font(.caption2)
                }
                .padding()
                Text(viewModel.status)
                    .padding(.bottom)
                if viewModel.isDone {
                    Button {
                        isShowingAudit = true
                    } label: {
                        Text("View Audit")
                    }

                }
                Spacer()
            }
            .frame(width: 450, height: 450)
            .onDrop(of: ["public.url", "public.file-url"], isTargeted: nil) { providers in
                if let item = providers.first {
                    if let identifier = item.registeredTypeIdentifiers.first {
                        if identifier == "public.ur" || identifier == "public.file-url" {
                            item.loadItem(forTypeIdentifier: identifier, options: nil) { urlData, error in
                                if let urlData = urlData as? Data {
                                    let url = NSURL(absoluteURLWithDataRepresentation: urlData, relativeTo: nil) as URL
                                    viewModel.transform(atPath: url)
                                }
                            }
                        }
                    }
                }
                return true
            }
        }
        else {
            List(viewModel.menus) { menu in
                MenuView(menu: menu)
                    .padding(.bottom)
                Divider()
            }
            //.frame(width: 500, height: 450)
        }
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
