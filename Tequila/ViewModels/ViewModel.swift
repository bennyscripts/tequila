//
//  ViewModel.swift
//  Tequila
//
//  Created by Ben Tettmar on 06/12/2024.
//

import SwiftUI

class ViewModel: ObservableObject {
    @Published var gamesList = Games()
    @Published var favourites = Favourites()
    @Published var webService = WebService()
    @Published var cache = GamesCache()
    @Published var showRefreshButton = false
    @Published var showAddGameButton = false
    @Published var refreshButtonCooldown = false
    @Published var compatibilityFilter = ""
    @Published var translationLayerFilter = ""
    @Published var gameRequestCooldown = false
    @Published var gameRequestCooldownCurrentWaitTime = 0
    
    func updateView() {
        self.objectWillChange.send()
    }
    
    func refresh() {
        if refreshButtonCooldown {
            return print("Cooldown active! Please dont spam my API 🙏")
        }
        
        gamesList.refresh()
        gamesList.sort()
        favourites.save()
        
        refreshButtonCooldown = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.refreshButtonCooldown = false
        }
    }
    
    func addGameRequest(title: String, native: String, rosetta_2: String, crossover: String, parallels: String, aliases: String) {
        if title.isEmpty {
            return print("Title cannot be empty")
        }
        
        if gameRequestCooldown {
            return print("Cooldown active! Please dont spam my API 🙏")
        }
        
        webService.sendNewGameRequest(title: title, native: native, rosetta_2: rosetta_2, crossover: crossover, parallels: parallels, aliases: aliases)
        gameRequestCooldown = true
        gameRequestCooldownCurrentWaitTime = 60
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.gameRequestCooldownCurrentWaitTime -= 1
            
            if self.gameRequestCooldownCurrentWaitTime == 0 {
                timer.invalidate()
                self.gameRequestCooldown = false
            }
        }
    }
    
    func editGameRequest(title: String, native: String, rosetta_2: String, crossover: String, parallels: String, aliases: String) {
        if title.isEmpty {
            return print("Title cannot be empty")
        }
        
        if gameRequestCooldown {
            return print("Cooldown active! Please dont spam my API 🙏")
        }
        
        webService.sendEditGameRequest(title: title, native: native, rosetta_2: rosetta_2, crossover: crossover, parallels: parallels, aliases: aliases)
        gameRequestCooldown = true
        gameRequestCooldownCurrentWaitTime = 60
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.gameRequestCooldownCurrentWaitTime -= 1
            
            if self.gameRequestCooldownCurrentWaitTime == 0 {
                timer.invalidate()
                self.gameRequestCooldown = false
            }
        }
    }
}
