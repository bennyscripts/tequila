//
//  AboutView.swift
//  Tequila
//
//  Created by Ben Tettmar on 30/11/2024.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
            }
            
            Text("Tequila")
                .font(.title)
            Text("The better way to see how well your games run on Apple Silicon")
                .font(.subheadline)
            Text("© 2024 Ben Tettmar")
                .font(.subheadline)
                .padding(.bottom, 5)
            Text("Dependencies:")
                .font(.headline)
            Text("SwiftSoup")
                .font(.subheadline)
            Text("GiantBomb API")
                .font(.subheadline)
            Text("AppleGamingWiki")
                .font(.subheadline)
            
            Spacer()
        }
        .padding()
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
