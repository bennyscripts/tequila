//
//  TequilaApp.swift
//  Tequila
//
//  Created by Ben Tettmar on 30/11/2024.
//

import SwiftUI

extension NSTextField {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set { }
    }
}

@main
struct TequilaApp: App {
    @ObservedObject var model = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView(model: model)
        }
        .windowResizability(.contentSize)
        .commands {
            CommandGroup(replacing: CommandGroupPlacement.newItem) {
                Button(action: {
                    model.refresh()
                }) {
                    Label("Refresh", systemImage: "arrow.clockwise")
                }
                Button(action: {
                    model.cache.clear()
                }) {
                    Label("Clear Cache", systemImage: "trash")
                }
            }
        }
    }
}
