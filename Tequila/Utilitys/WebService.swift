//
//  WebService.swift
//  Tequila
//
//  Created by Ben Tettmar on 30/11/2024.
//

import SwiftUI

class WebService {
    let cache = GamesCache()
    
    func getGames(completion: @escaping ([Game]) -> ()) {
        let url = URL(string: "https://benny.fun/api/mac-games")!
        let headers = [
            "User-Agent": "Tequila/1.0",
            "Accept": "application/json",
            "Host": "benny.fun"
        ]
        
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                DispatchQueue.main.async {
                    let decoder = JSONDecoder()
                    do {
                        let response = try decoder.decode(GameResponse.self, from: data)
                        completion(response.response)
                    } catch {
                        print(error)
                    }
                }
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
        if let cachedGame = cache.getGame(name: query) {
            DispatchQueue.main.async {
                completion([cachedGame])
            }
        } else {
            let query = query.replacingOccurrences(of: " ", with: "+")
            let url = URL(string: "https://www.giantbomb.com/api/search/?api_key=\(Bundle.main.infoDictionary!["GIANT_BOMB_API_KEY"]!)&format=json&query=\(query.lowercased())&limit=1")!
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    let decoder = JSONDecoder()
                    if let giantBombResponse = try? decoder.decode(GiantBombResponse.self, from: data) {
                        DispatchQueue.main.async {
                            if giantBombResponse.results.count > 0 {
                                self.cache.addGame(game: giantBombResponse.results[0])
                            }
                            completion(giantBombResponse.results)
                        }
                    } else {
                        print("Failed to decode Giant Bomb response.")
                    }
                }
            }.resume()
        }
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
    
    func sendWebhook(content: String, embed: [String: Any]) {
        let url = URL(string: "\(Bundle.main.infoDictionary!["DISCORD_WEBHOOK"]!)")!
        let jsonPayload: [String: Any] = ["content": content, "embeds": [embed]]
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonPayload)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 204 {
                    print("Webhook sent successfully.")
                } else {
                    print("Failed to send webhook.")
                }
            }
        }.resume()
    }
    
    func sendEditGameRequest(title: String, native: String, rosetta_2: String, crossover: String, parallels: String, aliases: String) {
        var newAliases = [String]()
        
        if title.isEmpty {
            return print("Title cannot be empty")
        }
        
        if aliases.contains(",") {
            newAliases = aliases.components(separatedBy: ", ")
        } else {
            newAliases.append(aliases)
        }
        
        let game = Game(
            aliases: newAliases,
            compatibility: Compatibility(
                crossover: crossover,
                linux_arm: "Unknown",
                native: native,
                parallels: parallels,
                rosetta_2: rosetta_2,
                wine: "Unknown"
            ),
            title: title
        )
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try? encoder.encode(game)
        
        sendWebhook(content: "<@\(Bundle.main.infoDictionary!["DISCORD_ID"]!)>", embed: [
            "title": "Edit Game Request",
            "description": "```json\n\(String(data: data!, encoding: .utf8)!)\n```",
        ])
    }
    
    func sendNewGameRequest(title: String, native: String, rosetta_2: String, crossover: String, parallels: String, aliases: String) {
        var newAliases = [String]()
        
        if title.isEmpty {
            return print("Title cannot be empty")
        }
        
        if aliases.contains(",") {
            newAliases = aliases.components(separatedBy: ", ")
        } else {
            newAliases.append(aliases)
        }
        
        let game = Game(
            aliases: newAliases,
            compatibility: Compatibility(
                crossover: crossover,
                linux_arm: "Unknown",
                native: native,
                parallels: parallels,
                rosetta_2: rosetta_2,
                wine: "Unknown"
            ),
            title: title
        )
        
//        turn the game object into a json string
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try? encoder.encode(game)
        
        sendWebhook(content: "<@\(Bundle.main.infoDictionary!["DISCORD_ID"]!)>", embed: [
            "title": "New Game Request",
            "description": "```json\n\(String(data: data!, encoding: .utf8)!)\n```",
        ])
    }
}
