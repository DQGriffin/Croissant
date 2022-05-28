//
//  UnderConstructionView.swift
//  Croissant
//
//  Created by Dquavius Griffin on 5/27/22.
//

import SwiftUI

struct UnderConstructionView: View {
    var body: some View {
        VStack {
            Image(systemName: "questionmark.app.dashed")
                .resizable()
                .frame(width: 95, height: 95)
                .padding()
            Text("This tool is still under construction.")
                .bold()
        }
    }
}

struct UnderConstructionView_Previews: PreviewProvider {
    static var previews: some View {
        UnderConstructionView()
    }
}
