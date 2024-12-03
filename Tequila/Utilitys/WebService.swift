//
//  WebService.swift
//  Tequila
//
//  Created by Ben Tettmar on 30/11/2024.
//

import SwiftUI

class WebService {
    func getGames(completion: @escaping ([Game]) -> ()) {
        URLSession.shared.dataTask(with: URL(string: "https://benny.fun/api/mac-games")!) { data, response, error in
            print("Getting games")
            
            if let data = data {
                print("Got data")
                
                let decoder = JSONDecoder()
                if let gamesResponse = try? decoder.decode(GamesResponse.self, from: data) {
                    print("Decoded games")
                    
                    DispatchQueue.main.async {
                        completion(gamesResponse.response)
                    }
                }
            }
            
            if (error as? URLError)?.code == .timedOut {
                print("Request timed out.")
            }
        }.resume()
    }
    
    func getGameArtwork(game: Game, completion: @escaping (GameArtwork) -> ()) {
        URLSession.shared.dataTask(with: URL(string: "https://benny.fun/api/game-artwork?game=\(game.title)")!) { data, response, error in
            if let data = data {
                DispatchQueue.main.async {
                    let decoder = JSONDecoder()
                    if let gameArtwork = try? decoder.decode(GameArtwork.self, from: data) {
                        completion(gameArtwork)
                    }
                }
            }
        }.resume()
    }
    
    func searchGiantBomb(query: String, completion: @escaping ([GiantBombGame]) -> ()) {
        let query = query.replacingOccurrences(of: " ", with: "+")
        let url = URL(string: "https://www.giantbomb.com/api/search/?api_key=\(Bundle.main.infoDictionary!["GIANT_BOMB_API_KEY"]!)&format=json&query=\(query.lowercased())&limit=1")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                if let giantBombResponse = try? decoder.decode(GiantBombResponse.self, from: data) {
                    DispatchQueue.main.async {
                        completion(giantBombResponse.results)
                    }
                } else {
                    print("Failed to decode Giant Bomb response.")
                }
            }
        }.resume()
    }
    
    func getGiantBombScreenshots(api_detail_url: String, completion: @escaping ([GiantBombImage]) -> ()) {
        let url = URL(string: "\(api_detail_url)&api_key=\(Bundle.main.infoDictionary!["GIANT_BOMB_API_KEY"]!)&format=json")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                if let giantBombResponse = try? decoder.decode(GiantBombImageResponse.self, from: data) {
                    DispatchQueue.main.async {
                        completion(giantBombResponse.results)
                    }
                } else {
                    print("Failed to decode Giant Bomb response.")
                }
            }
        }.resume()
    }
}
