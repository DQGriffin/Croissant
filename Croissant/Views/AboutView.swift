//
//  AboutView.swift
//  Croissant
//
//  Created by Dquavius Griffin on 5/28/22.
//

import SwiftUI
import AlertToast

struct AboutView: View {
    
    let viewModel = AboutViewModel()
    @Binding var isPresented: Bool
    @State var isShowingAttributions = false
    @State var isShowingToast = false
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "circle.fill")
                .foregroundColor(.red)
                .frame(width: 12, height: 12)
                .padding(.top)
                .padding(.leading)
                .onTapGesture {
                    isPresented = false
                }
            HStack {
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .padding(.trailing)
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text("Croissant")
                            .font(.title)
                            .bold()
                        Text("Version 0.9.2 (Build \(viewModel.buildNumber))")
                            .font(.body)
                    }
                    .padding(.vertical)
                    Spacer()
                    Text("Copyright © 2022 D'Quavius Griffin. All rights reserved.")
                        .font(.caption)
                    HStack {
                        Button {
                            isShowingAttributions = true
                        } label: {
                            Text("Acknowledgements")
                        }
                        Button {
                            isShowingToast = true
                        } label: {
                            Text("Give Feedback")
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical)
                }
                .padding(.trailing)
            }
            .sheet(isPresented: $isShowingAttributions, content: {
                AcknowledgementsView(viewModel: viewModel, isPresented: $isShowingAttributions)
            })
            .toast(isPresenting: $isShowingToast, duration: 3, tapToDismiss: false, alert: {
                AlertToast(displayMode: .hud, type: .regular, title: "Sending feedback doesn't work yet")
            })
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
