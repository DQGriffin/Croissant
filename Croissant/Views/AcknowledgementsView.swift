//
//  AcknowledgementsView.swift
//  Croissant
//
//  Created by Dquavius Griffin on 6/16/22.
//

import SwiftUI

struct AcknowledgementsView: View {
    
    let viewModel: AboutViewModel
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "circle.fill")
                    .foregroundColor(.red)
                    .frame(width: 12, height: 12)
                    .onTapGesture {
                        isPresented = false
                    }
                Spacer()
                Text("Croissant uses the following third-party packages")
                Spacer()
            }
            .padding(.top)
            .padding(.leading)
            List(viewModel.attributions) { attribution in
                HStack {
                    Text(attribution.name)
                    Spacer()
                    Image(systemName: "link")
                        .onTapGesture {
                            let url = URL(string: attribution.link)!
                            if NSWorkspace.shared.open(url) {
                                print("default browser was successfully opened")
                            }
                        }
                }
            }
            
        }
        .frame(width: 380, height: 250)
    }
}

struct AcknowledgementsView_Previews: PreviewProvider {
    
    @State static var isPresented = false
    
    static var previews: some View {
        AcknowledgementsView(viewModel: AboutViewModel(), isPresented: $isPresented)
    }
}
