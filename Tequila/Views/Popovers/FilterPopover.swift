//
//  FilterPopover.swift
//  Tequila
//
//  Created by Ben Tettmar on 06/12/2024.
//

import SwiftUI

struct FilterPopover: View {
    @ObservedObject var model: ViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Picker("Translation Layer", selection: $model.translationLayerFilter) {
                Text("All").tag("")
                Text("Native").tag("native")
                Text("Rosetta 2").tag("rosetta_2")
                Text("CrossOver").tag("crossover")
                Text("Parallels").tag("parallels")
            }
            .pickerStyle(MenuPickerStyle())
            
            Picker("Compatibility", selection: $model.compatibilityFilter) {
                Text("All").tag("")
                Text("N/A").tag("n/a")
                Text("Unknown").tag("unknown")
                Text("Menu").tag("menu")
                Text("Runs").tag("runs")
                Text("Unplayable").tag("Unplayable")
                Text("Playable").tag("playable")
                Text("Perfect").tag("perfect")
            }
            .pickerStyle(MenuPickerStyle())
            
//            Button("Reset") {
//                model.translationLayerFilter = ""
//                model.compatibilityFilter = ""
//            }
        }
        .padding()
    }
}
