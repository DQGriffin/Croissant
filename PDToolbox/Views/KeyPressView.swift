//
//  KeyPressView.swift
//  PDToolbox
//
//  Created by Dquavius Griffin on 5/26/22.
//

import SwiftUI

struct KeyPressView: View {
    let keyPress: IVRKeyPress
    
    var body: some View {
        HStack {
            VStack {
                HStack {
                    Spacer()
                    Text("Key")
                        .bold()
                }
                HStack {
                    Spacer()
                    Text("Action")
                        .bold()
                }
                HStack {
                    Spacer()
                    Text("Destination")
                        .bold()
                }
            }
            VStack {
                HStack {
                    Text(keyPress.key)
                    Spacer()
                }
                HStack {
                    Text(keyPress.actionType)
                    Spacer()
                }
                HStack {
                    Text(keyPress.destination)
                    Spacer()
                }
            }
        }
    }
}

struct KeyPressView_Previews: PreviewProvider {
    static var previews: some View {
        KeyPressView(keyPress: IVRKeyPress(key: "1", actionType: "ForwardToExtension", destination: "1128"))
    }
}
