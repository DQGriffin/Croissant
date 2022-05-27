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
        HStack(alignment: .center) {
            VStack(alignment: .trailing) {
                HStack {
                    Text("Key")
                        .bold()
                }
                HStack {
                    Text("Action")
                        .bold()
                }
                HStack {
                    Text("Destination")
                        .bold()
                }
            }
            VStack(alignment: .leading) {
                HStack {
                    Text(keyPress.key)
                }
                HStack {
                    Text(keyPress.actionType)
                }
                HStack {
                    Text(keyPress.destination)
                }
            }
            Spacer()
        }
    }
}

struct KeyPressView_Previews: PreviewProvider {
    static var previews: some View {
        KeyPressView(keyPress: IVRKeyPress(key: "1", actionType: "ForwardToExtension", destination: "1128"))
    }
}
