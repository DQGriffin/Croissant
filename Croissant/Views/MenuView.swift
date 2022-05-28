//
//  MenuView.swift
//  PDToolbox
//
//  Created by Dquavius Griffin on 5/26/22.
//

import SwiftUI

struct MenuView: View {
    
    var menu: IVRMenu
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Text(menu.name)
                    .font(.title)
                    .bold()
                    .padding(.leading)
                Text(menu.extensionNumber)
            }
            .padding(.vertical)
            Text("Prompt: \(menu.prompt)")
                .lineLimit(-1)
                .padding(.leading)
            VStack {
                ForEach(menu.actions) { action in
                    KeyPressView(keyPress: action)
                        .padding()
                        .border(.white, width: 1)
                }
            }
            .padding()
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        let keyPress = IVRKeyPress(key: "1", actionType: "ForwardToExtension", destination: "1128")
        let menu = IVRMenu(extensionNumber: "2280", name: "Main IVR", prompt: "Thank you for calling", actions: [keyPress])
        MenuView(menu: menu)
    }
}
