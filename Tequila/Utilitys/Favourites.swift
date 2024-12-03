//
//  Library.swift
//  Tequila
//
//  Created by Ben Tettmar on 30/11/2024.
//

import SwiftUI

class Favourites: ObservableObject {
    @State private var favourites: Set<String>
    private let key = "Favourites"
    
    init() {
        if let data = UserDefaults.standard.array(forKey: key) as? [String] {
            favourites = Set(data)
        } else {
            favourites = []
        }
    }
    
    func contains(_ game: Game) -> Bool {
        favourites.contains(game.title)
    }
    
    func add(_ game: Game) {
        favourites.insert(game.title)
        save()
    }
    
    func remove(_ game: Game) {
        favourites.remove(game.title)
        save()
    }
    
    func save() {
        UserDefaults.standard.set(Array(favourites), forKey: key)
    }
}
