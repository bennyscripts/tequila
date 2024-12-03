//
//  GamesUtil.swift
//  Tequila
//
//  Created by Ben Tettmar on 30/11/2024.
//

import SwiftUI

class Games: ObservableObject {
    @Published var games = [Game]()
    
    init() {
        refresh()
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

class Game: Decodable, ObservableObject, Identifiable {
    let title: String
    let compatibility: Compatibility
}

class Compatibility: Decodable, ObservableObject {
    let crossover: String
    let linux_arm: String
    let native: String
    let parallels: String
    let rosetta_2: String
    let wine: String
    var all: [String] {
        [crossover, linux_arm, native, parallels, rosetta_2, wine]
    }
}

class WebService {
    func getGames(completion: @escaping ([Game]) -> ()) {
        URLSession.shared.dataTask(with: URL(string: "https://benny.fun/api/mac-games")!) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                if let gamesResponse = try? decoder.decode(GamesResponse.self, from: data) {
                    DispatchQueue.main.async {
                        completion(gamesResponse.response)
                    }
                }
            }
        }.resume()
    }
}
