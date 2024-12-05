//
//  TequilaApp.swift
//  Tequila
//
//  Created by Ben Tettmar on 30/11/2024.
//

import SwiftUI

class ViewModel: ObservableObject {
    @Published var gamesList = Games()
    @Published var favourites = Favourites()
    @Published var webService = WebService()
    @Published var cache = GamesCache()
    @Published var showRefreshButton = false
    @Published var refreshButtonCooldown = false
    @Published var compatibilityFilter = ""
    @Published var translationLayerFilter = ""
    
    init() {
        print("ViewModel init")
    }
    
    func updateView() {
        self.objectWillChange.send()
    }
    
    func refresh() {
        if !refreshButtonCooldown {
            self.gamesList.refresh()
            self.favourites.save()
            self.refreshButtonCooldown = true
        } else {
            print("Cooldown in effect! Please dont spam my API 🙏")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.refreshButtonCooldown = false
        }
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
