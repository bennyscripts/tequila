//
//  AllGamesList.swift
//  Tequila
//
//  Created by Ben Tettmar on 30/11/2024.
//

import SwiftUI

struct GameCardView: View {
    @EnvironmentObject var game: Game
    @ObservedObject var model: ViewModel
    @State private var favourite = false
    @State private var backgroundOpacity = 0.0
    
    var body: some View {
        HStack {
            Text(game.title)
            Spacer()
            Text("Native: \(game.compatibility.native)")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.trailing, 10)
            Text("Rosetta 2: \(game.compatibility.rosetta_2)")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.trailing, 10)
            Text("CrossOver: \(game.compatibility.crossover)")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.trailing, 10)
            Text("Parallels: \(game.compatibility.parallels)")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.trailing, 10)
            Button(action: {
                favourite.toggle()
                
                if favourite && !model.favourites.contains(game) {
                    model.favourites.add(game)
                } else if !favourite && model.favourites.contains(game) {
                    model.favourites.remove(game)
                }
            }) {
                Image(systemName: favourite ? "star.fill" : "star")
                    .foregroundColor(favourite ? .yellow : .gray)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 5)
        .cornerRadius(5)
        .background(Color.gray.opacity(backgroundOpacity))
        .onAppear() {
            favourite = model.favourites.contains(game)
        }
        .onHover { hovering in
            if hovering {
                NSCursor.pointingHand.set()
            } else {
                NSCursor.arrow.set()
            }
            
            withAnimation {
                backgroundOpacity = hovering ? 0.2 : 0.0
            }
        }
    }
}

struct AllGamesListView: View {
    @ObservedObject var model: ViewModel
    @State private var searchText = ""
    @State private var sortOrder = [KeyPathComparator(\Game.title)]
    
    var body: some View {
        NavigationStack {
            if model.gamesList.games.isEmpty {
                ProgressView()
            }
            
            List {
                ForEach(model.gamesList.games.filter{searchText.isEmpty ? true : $0.title.localizedCaseInsensitiveContains(searchText)}) { game in
                    NavigationLink(destination: GameDetailedView(model: model).environmentObject(game)) {
                        GameCardView(model:model)
                            .environmentObject(game)
                    }
                }
            }
            .searchable(text: $searchText)
        }
        .navigationTitle("Tequila")
    }
}
