//
//  Cache.swift
//  Tequila
//
//  Created by Ben Tettmar on 05/12/2024.
//

import SwiftUI

class GamesCache: ObservableObject {
    var giantBombGames: [GiantBombGame] = []
    
    init() {
        load()
    }
    
    func load() {
        let cacheFileURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0].appendingPathComponent("cache.json")
        
        if !FileManager.default.fileExists(atPath: cacheFileURL.path) {
            let data = Data()
            try? data.write(to: cacheFileURL, options: [.atomicWrite, .completeFileProtection])
        }
    }

    func save() {
        let cacheFileURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0].appendingPathComponent("cache.json")
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(self.giantBombGames)
            try data.write(to: cacheFileURL, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Failed to save cache")
        }
    }
    
    func addGame(game: GiantBombGame) {
        if !containsGame(game: game) {
            giantBombGames.append(game)
            return save()
        } else {
            return print("Game already in cache")
        }
    }
    
    func removeGame(game: GiantBombGame) {
        if !containsGame(game: game) {
            print("Game not in cache")
            return
        }
        
        giantBombGames.removeAll { $0.name == game.name }
        return save()
    }
    
    func containsGame(game: GiantBombGame) -> Bool {
        return giantBombGames.contains { $0.name == game.name }
    }
    
    func getGame(name: String) -> GiantBombGame? {
        return giantBombGames.first { $0.name == name }
    }
    
    func clear() {
        giantBombGames = []
        return save()
    }
}
