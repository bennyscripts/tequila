//
//  ContentView.swift
//  Tequila
//
//  Created by Ben Tettmar on 30/11/2024.
//

import SwiftUI

struct GameView: View {
    var game: Game
    
    var body: some View {
        VStack {
            Text(game.title)
                .font(.title)
        }
    }
}
