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
                if model.favourites.hitLimit() {
                    print("hit limit")
                } else {
                    favourite.toggle()
                    
                    if favourite && !model.favourites.contains(game) {
                        model.favourites.add(game)
                    } else if !favourite && model.favourites.contains(game) {
                        model.favourites.remove(game)
                    }
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

struct FilterView: View {
    @ObservedObject var model: ViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Picker("Translation Layer", selection: $model.translationLayerFilter) {
                Text("All").tag("")
                Text("Native").tag("native")
                Text("Rosetta 2").tag("rosetta_2")
                Text("CrossOver").tag("crossover")
                Text("Parallels").tag("parallels")
            }
            .pickerStyle(MenuPickerStyle())
            
            Picker("Compatibility", selection: $model.compatibilityFilter) {
                Text("All").tag("")
                Text("N/A").tag("n/a")
                Text("Unknown").tag("unknown")
                Text("Menu").tag("menu")
                Text("Runs").tag("runs")
                Text("Playable").tag("playable")
                Text("Perfect").tag("perfect")
            }
            .pickerStyle(MenuPickerStyle())
            
            Button("Reset") {
                model.translationLayerFilter = ""
                model.compatibilityFilter = ""
            }
        }
        .padding()
    }
}

struct GamesListView: View {
    @ObservedObject var model: ViewModel
    @EnvironmentObject var gamesList: Games
    @EnvironmentObject var favourites: Favourites
    
    @State private var searchText = ""
    @State private var refreshButtonRotation = 0.0
    @State private var sortButtonRotation = 0.0
    @State private var titleSortAscending = true
    @State private var showFilterPopover = false
    @State private var showUpButton = false
    
    func filterGames() -> [Game] {
        return gamesList.games.filter { game in
            let searchMatch = searchText.isEmpty ||
            game.title.localizedCaseInsensitiveContains(searchText) ||
            game.aliases.contains(where: { $0.localizedCaseInsensitiveContains(searchText) })
            
            let translationLayerMatch = model.translationLayerFilter.isEmpty || model.compatibilityFilter.isEmpty ||
            game.compatibility.getLayer(model.translationLayerFilter).localizedCaseInsensitiveContains(model.compatibilityFilter)
            
            return searchMatch && translationLayerMatch
        }.sorted { game1, game2 in
            if titleSortAscending {
                return game1.title < game2.title
            } else {
                return game1.title > game2.title
            }
        }
    }
    
    var body: some View {
        if model.gamesList.games.isEmpty {
            ProgressView()
        } else {
            NavigationStack {
                ScrollViewReader { proxy in
                    ZStack {
                        List(filterGames(), id: \.title) { game in
                            NavigationLink(destination: GameDetailedView(model: model).environmentObject(game)) {
                                GameCardView(model: model)
                                    .environmentObject(game)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .searchable(text: $searchText)
                        .background(Color.clear)
                        
                        if showUpButton {
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        withAnimation {
                                            proxy.scrollTo(filterGames().first?.title)
                                        }
                                    }) {
                                        Image(systemName: "arrow.up")
                                            .padding()
                                            .background(Color.secondary.opacity(1))
                                            .cornerRadius(10)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .padding(.bottom)
                                    .padding(.trailing, 30)
                                    .shadow(radius: 5, y: 5)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Tequila")
            .toolbar {
                if model.showRefreshButton {
                    ToolbarItem(placement: .navigation) {
                        Button(action: {
                            model.refresh()
                            withAnimation {
                                refreshButtonRotation += 360
                            }
                        }) {
                            Label("Refresh", systemImage: "arrow.clockwise")
                                .rotationEffect(.degrees(refreshButtonRotation))
                        }
                    }
                    ToolbarItemGroup(placement: .primaryAction) {
                        Button(action: {
                            titleSortAscending.toggle()
                            withAnimation {
                                sortButtonRotation += 180
                            }
                        }) {
                            Label("Sort", systemImage: "arrow.up")
                                .rotationEffect(.degrees(sortButtonRotation))
                        }
                        Button(action: {
                            showFilterPopover.toggle()
                        }) {
                            Label("Filter", systemImage: "line.horizontal.3.decrease.circle")
                        }
                        .popover(isPresented: $showFilterPopover, arrowEdge: .bottom) {
                            FilterView(model: model)
                        }
                    }
                }
            }
            .onAppear() {
                model.showRefreshButton = true
            }
            .onDisappear() {
                model.showRefreshButton = false
            }
        }
    }
}
