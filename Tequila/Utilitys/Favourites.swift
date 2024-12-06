//
//  Library.swift
//  Tequila
//
//  Created by Ben Tettmar on 30/11/2024.
//

import SwiftUI

class Favourites: ObservableObject {
    var favourites: [String] = []
    var limit = 10
    
    init() {
        let favouritesFileURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0].appendingPathComponent("favourites.json")
        
        if !FileManager.default.fileExists(atPath: favouritesFileURL.path) {
            let data = Data()
            try? data.write(to: favouritesFileURL, options: [.atomicWrite, .completeFileProtection])
        }
        
        let decoder = JSONDecoder()
        
        do {
            let data = try Data(contentsOf: favouritesFileURL)
            self.favourites = try decoder.decode([String].self, from: data)
        } catch {
            self.favourites = []
        }
    }
    
    func hitLimit() -> Bool {
        return self.favourites.count >= limit
    }
    
    func isEmpty() -> Bool {
        return self.favourites.isEmpty
    }
    
    func reset() {
        self.favourites = []
        return save()
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func save() {
        let favouritesFileURL = getDocumentsDirectory().appendingPathComponent("favourites.json")
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(self.favourites)
            try data.write(to: favouritesFileURL, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Failed to save favourites")
        }
    }
    
    func contains(_ game: Game) -> Bool {
        return self.favourites.contains(game.title)
    }
    
    func add(_ game: Game) {
        if self.favourites.count >= limit {
            return
        } else if self.favourites.contains(game.title) {
            return
        }
        self.favourites.append(game.title)
        return save()
    }
    
    func remove(_ game: Game) {
        self.favourites.removeAll(where: { $0 == game.title })
        return save()
    }
}
