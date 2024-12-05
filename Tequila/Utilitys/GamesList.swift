//
//  GamesUtil.swift
//  Tequila
//
//  Created by Ben Tettmar on 30/11/2024.
//

import SwiftUI

func bestTranslationLayer(game: Game) -> String {
    let compatibilities = game.compatibility
    let layers = compatibilities.getLayers()
    
    let weights = [
        "parallels": 1,
        "crossover": 2,
        "rosetta_2": 3,
        "native": 4
    ]
    
    let levels = [
        "Unknown": 0,
        "N/A": 0,
        "Unplayable": 1,
        "Menu": 2,
        "Runs": 3,
        "Playable": 4,
        "Perfect": 5
    ]
    
    let responses = [
        0: "This game has not been tested using any translation layers",
        1: "Runs {translationLayerText} but may be unplayable",
        2: "Will run {translationLayerText} but will not play past the menu",
        3: "Runs {translationLayerText} but you may experience issues",
        4: "Playable {translationLayerText} but with a few issues",
        5: "Plays perfectly {translationLayerText}!"
    ]
    
    let translationLayerTexts = [
        "crossover": "using Crossover",
        "native": "natively",
        "parallels": "using Parallels",
        "rosetta_2": "using Rosetta 2"
    ]
    
    var bestLayer = "Unknown"
    var bestWeight = 0
    var bestLevel = 0
    
    for (layer, compatibility) in layers {
        let weight = weights[layer]!
        let level = levels[compatibility]!
        
        if level > bestLevel {
            bestLayer = layer
            bestWeight = weight
            bestLevel = level
        } else if level == bestLevel {
            if weight > bestWeight {
                bestLayer = layer
                bestWeight = weight
                bestLevel = level
            }
        }
    }
    
    return responses[bestLevel]!.replacingOccurrences(of: "{translationLayerText}", with: translationLayerTexts[bestLayer]!)
}

func compatibilityDescription(translationLayer: String, compatibility: String) -> String {
    var translationLayerText = "using \(translationLayer)"
    
    if translationLayer.lowercased() == "native" {
        translationLayerText = "natively"
    }
    
    let descriptions = [
        "Unknown": "This game has not been tested yet \(translationLayerText).",
        "N/A": "This game will not run \(translationLayerText).",
        "Unplayable": "This game will run \(translationLayerText) but is inoperable or you will struggle to enjoy the game.",
        "Menu": "This game will run \(translationLayerText) but will not play past the menu.",
        "Runs": "This game will run \(translationLayerText) but you may experience issues.",
        "Playable": "This game will run better \(translationLayerText) but you may experience a few issues.",
        "Perfect": "This game will run perfectly \(translationLayerText)!"
    ]
    
    if translationLayer.lowercased() == "native" && compatibility == "Perfect" {
        return "This game has a native port and runs perfectly!"
    }

    return descriptions[compatibility]!
}

class Games: ObservableObject {
    @Published var games = [Game]()
    
    init() {
        refresh()
        sort()
    }
    
    func sort() {
        games.sort { $0.title < $1.title }
    }
    
    func refresh() {
        WebService().getGames { games in
            self.games = games
        }
    }
}

struct GamesResponse: Decodable {
    let response: [Game]
}

class GameArtwork: Decodable, ObservableObject {
    let response: String
}

class Game: Decodable, ObservableObject, Identifiable {
    var title: String = ""
    var compatibility: Compatibility = Compatibility()
    var aliases: [String] = []
}

class Compatibility: Decodable, ObservableObject {
    var crossover: String = "Unknown"
    var linux_arm: String = "Unknown"
    var native: String = "Unknown"
    var parallels: String = "Unknown"
    var rosetta_2: String = "Unknown"
    var wine: String = "Unknown"
    
    var all: [String] {
        [crossover, native, parallels, rosetta_2]
    }
    
    func getLayers() -> [String: String] {
        [
            "crossover": crossover,
            "native": native,
            "parallels": parallels,
            "rosetta_2": rosetta_2
        ]
    }

    func getLayer(_ layer: String) -> String {
        switch layer {
        case "crossover":
            return crossover
        case "native":
            return native
        case "parallels":
            return parallels
        case "rosetta_2":
            return rosetta_2
        default:
            return "Unknown"
        }
    }
}
