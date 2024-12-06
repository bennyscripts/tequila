//
//  AllGamesList.swift
//  Tequila
//
//  Created by Ben Tettmar on 30/11/2024.
//

import SwiftUI

<<<<<<< HEAD
=======
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
            
//            Button("Reset") {
//                model.translationLayerFilter = ""
//                model.compatibilityFilter = ""
//            }
        }
        .padding()
    }
}

struct NewGameView: View {
    @ObservedObject var model: ViewModel
    @Binding var showSheet: Bool
    
    @State private var title = ""
    @State private var native = "N/A"
    @State private var rosetta_2 = "N/A"
    @State private var crossover = "N/A"
    @State private var parallels = "N/A"
    @State private var aliases = ""
    @State private var showEmptyTitleWarning = false
    @State private var submitted = false
        
    var body: some View {
        if submitted {
            VStack {
                Text("Game Request Submitted")
                    .font(.headline)
                Text("Thanks for contributing to Tequila!")
                    .font(.subheadline)
            }
            .padding()
            .frame(width: 300)
        } else {
            VStack {
                HStack {
                    Text("New Game Request")
                    Spacer()
                    Button(action: {
                        showSheet.toggle()
                    }) {
                        Image(systemName: "xmark")
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding()
                .background(Color.gray.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 0)
                        .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                )
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("Title")
                        Spacer()
                        TextField("Epic Game III", text: $title)
                            .cornerRadius(7)
                            .frame(width: 174)
                    }
                    HStack {
                        Text("Native")
                        Spacer()
                        Picker("", selection: $native) {
                            Text("N/A").tag("N/A")
                            Text("Unknown").tag("Unknown")
                            Text("Menu").tag("Menu")
                            Text("Runs").tag("Runs")
                            Text("Playable").tag("Playable")
                            Text("Perfect").tag("Perfect")
                        }
                        .frame(width: 180)
                    }
                    .padding(.top, 1)
                    HStack {
                        Text("Rosetta 2")
                        Spacer()
                        Picker("", selection: $rosetta_2) {
                            Text("N/A").tag("N/A")
                            Text("Unknown").tag("Unknown")
                            Text("Menu").tag("Menu")
                            Text("Runs").tag("Runs")
                            Text("Playable").tag("Playable")
                            Text("Perfect").tag("Perfect")
                        }
                        .frame(width: 180)
                    }
                    HStack {
                        Text("CrossOver")
                        Spacer()
                        Picker("", selection: $crossover) {
                            Text("N/A").tag("N/A")
                            Text("Unknown").tag("Unknown")
                            Text("Menu").tag("Menu")
                            Text("Runs").tag("Runs")
                            Text("Playable").tag("Playable")
                            Text("Perfect").tag("Perfect")
                        }
                        .frame(width: 180)
                    }
                    HStack {
                        Text("Parallels")
                        Spacer()
                        Picker("", selection: $parallels) {
                            Text("N/A").tag("N/A")
                            Text("Unknown").tag("Unknown")
                            Text("Menu").tag("Menu")
                            Text("Runs").tag("Runs")
                            Text("Playable").tag("Playable")
                            Text("Perfect").tag("Perfect")
                        }
                        .frame(width: 180)
                    }
                    .padding(.bottom, 2)
                    HStack {
                        Text("Aliases")
                        Spacer()
                        TextField("Epic Game 3, Epic Game: The Trilogy", text: $aliases)
                            .cornerRadius(7)
                            .frame(width: 174)
                    }
                    Text("Separate aliases with commas")
                        .font(.caption)
                        .padding(.bottom)
                    HStack {
                        Button("Submit Request") {
                            if title.isEmpty {
                                showEmptyTitleWarning.toggle()
                            } else {
                                model.addGameRequest(title: title, native: native, rosetta_2: rosetta_2, crossover: crossover, parallels: parallels, aliases: aliases)
                                title = ""
                                native = "N/A"
                                rosetta_2 = "N/A"
                                crossover = "N/A"
                                parallels = "N/A"
                                aliases = ""
                                submitted = true
                            }
                        }
                        .disabled(title.isEmpty)
                    }
                }
                .padding(.top, 10)
                .padding(.bottom)
                .padding(.horizontal)
                .onAppear() {
                    if model.gameRequestCooldown {
                        submitted = true
                    }
                }
            }
            .frame(width: 300)
        }
    }
}

>>>>>>> 65fa265ba63b05d3634860b37b019d328f498815
struct GamesListView: View {
    @ObservedObject var model: ViewModel
    @EnvironmentObject var gamesList: Games
    @EnvironmentObject var favourites: Favourites
    
    @State private var searchText = ""
    @State private var sortButtonRotation = 0.0
    @State private var titleSortAscending = true
    @State private var showFilterPopover = false
    @State private var showUpButton = false
    @State private var showNewGamePopover = false
    @State private var filterButtonAnimate = false
    @State private var showRequestCooldownPopover = false
    
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
                            NavigationLink(destination: GameDetailedView(model: model, from: "GamesListView").environmentObject(game)) {
<<<<<<< HEAD
                                GameListItem(model: model)
=======
                                GameCardView(model: model)
>>>>>>> 65fa265ba63b05d3634860b37b019d328f498815
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
                        }) {
                            Label("Refresh", systemImage: "arrow.clockwise")
                        }
                        .symbolEffect(.rotate.byLayer, options: .nonRepeating, value: model.refreshButtonCooldown)
                        .disabled(model.refreshButtonCooldown)
                    }
                    ToolbarItemGroup(placement: .primaryAction) {
                        Button(action: {
                            showFilterPopover.toggle()
                        }) {
                            Label("Filter", systemImage: "line.horizontal.3.decrease")
                        }
                        .symbolEffect(.bounce, value: showFilterPopover)
                        .popover(isPresented: $showFilterPopover, arrowEdge: .bottom) {
<<<<<<< HEAD
                            FilterPopover(model: model)
=======
                            FilterView(model: model)
>>>>>>> 65fa265ba63b05d3634860b37b019d328f498815
                        }
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
                            showNewGamePopover.toggle()
                        }) {
                            Label("New Game", systemImage: "plus")
                        }
                        .disabled(model.gameRequestCooldown)
                        .sheet(isPresented: $showNewGamePopover) {
<<<<<<< HEAD
                            NewGameRequestSheet(model: model, showSheet: $showNewGamePopover)
=======
                            NewGameView(model: model, showSheet: $showNewGamePopover)
>>>>>>> 65fa265ba63b05d3634860b37b019d328f498815
                        }
                        .onHover { hovering in
                            if model.gameRequestCooldown {
                                if hovering {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        showRequestCooldownPopover = true
                                    }
                                } else {
                                    showRequestCooldownPopover = false
                                }
                            }
                        }
                        .popover(isPresented: $showRequestCooldownPopover, arrowEdge: .leading) {
                            Text("Cooldown active! Please don't spam my API 🙏")
                                .padding()
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