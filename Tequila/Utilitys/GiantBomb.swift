//
//  GiantBomb.swift
//  Tequila
//
//  Created by Ben Tettmar on 30/11/2024.
//

import SwiftUI

class GiantBomb: ObservableObject {
    var game: [GiantBombGame] = []
    var webService = WebService()
    
    func search(query: String) {
        webService.searchGiantBomb(query: query) { game in
            self.game = game
        }
    }
}

class GiantBombImageTag: Decodable, Encodable {
    let api_detail_url: String
    let name: String
    let total: Int
}

class GiantBombImage: Decodable, Encodable {
    let icon_url: String
    let medium_url: String
    let screen_url: String
    let screen_large_url: String
    let small_url: String
    let super_url: String
    let thumb_url: String
    let tiny_url: String
    let original_url: String
}

class GiantBombPlatform: Decodable, Encodable {
    let name: String
    let site_detail_url: String
}

class GiantBombGame: Decodable, Encodable {
    var name: String = ""
    var deck: String = "Couldn't find a description for this game."
    var description: String? = nil
    var original_release_date: String? = nil
    var date_last_updated: String? = nil
    var image: GiantBombImage? = nil
    var platforms: [GiantBombPlatform]? = nil
    var image_tags: [GiantBombImageTag]? = nil
    var site_detail_url: String? = nil
}

struct GiantBombResponse: Decodable {
    let error: String
    let status_code: Int
    let results: [GiantBombGame]
}

struct GiantBombImageResponse: Decodable {
    let error: String
    let status_code: Int
    let results: [GiantBombImage]
}
