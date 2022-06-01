//
//  AboutView.swift
//  Croissant
//
//  Created by Dquavius Griffin on 5/28/22.
//

import SwiftUI

struct AboutView: View {
    
    let viewModel = AboutViewModel()
    @Binding var isPresented: Bool
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "circle.fill")
                .foregroundColor(.red)
                .frame(width: 12, height: 12)
                .padding()
                .onTapGesture {
                    isPresented = false
                }
            HStack {
                Image(systemName: "help")
                    .frame(width: 100, height: 100)
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text("Croissant")
                            .font(.title)
                            .bold()
                        Text("Version 1.0 (Build \(viewModel.buildNumber))")
                            .font(.body)
                    }
                    .padding(.vertical)
                    Spacer()
                    Text("Copyright © 2022 D'Quavius Griffin. All rights reserved.")
                        .font(.caption)
                    HStack {
                        Button {
                            
                        } label: {
                            Text("Acknowledgements")
                        }
                        Button {
                            
                        } label: {
                            Text("Submit Feedback")
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical)
                }
                .padding(.trailing)
            }
            .frame(minWidth: 200, minHeight: 200)
            .frame(maxWidth: 400, maxHeight: 200)
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    @State static var isPresented = false
    
    static var previews: some View {
        AboutView(isPresented: $isPresented)
    }
}
