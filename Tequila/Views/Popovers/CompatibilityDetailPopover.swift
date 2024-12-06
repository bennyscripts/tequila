//
//  CompatibilityDetailPopover.swift
//  Tequila
//
//  Created by Ben Tettmar on 06/12/2024.
//

import SwiftUI

struct CompatibilityDetailPopover: View {
    var compatibility: String
    var translationLayerName: String
    
    var body: some View {
        Text(compatibilityDescription(translationLayer: translationLayerName, compatibility: compatibility))
            .font(.subheadline)
            .foregroundColor(.secondary)
        .padding()
    }
}
