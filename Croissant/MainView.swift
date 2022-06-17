//
//  MainView.swift
//  PDToolbox
//
//  Created by Dquavius Griffin on 5/25/22.
//

import SwiftUI
import AlertToast

struct MainView: View {
    
    @ObservedObject var viewModel = IVRToolsViewModel()
    @State var isShowingAudit = false
    @State var isShowingToast = false
    
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "arrow.down.doc")
                .resizable()
                .frame(width: 75, height: 95)
            Text("Drag and drop BRD here")
                .font(.largeTitle)
                .padding()
            VStack(alignment: .leading) {
                Text("1. Drag and drop the BRD into this window")
                    .font(.caption2)
                Text("2. Check your downloads folder for the generated Auto-Receptionist.xml file")
                    .font(.caption2)
                Text("3. Upload the file in Service Web")
                    .font(.caption2)
            }
            .padding()
            if viewModel.isDone {
                Button {
                    //isShowingAudit = true
                    isShowingToast = true
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
        .toast(isPresenting: $viewModel.hasMessage, duration: 5, tapToDismiss: false, offsetY: 15, alert: {
            AlertToast(displayMode: .hud, type: .regular, title: viewModel.message)
        }, onTap: {
            print("Toast clicked")
        }, completion: {
            //isShowingToast = false
            viewModel.hasMessage = false
            print("Toast finished")
        })
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
