//
//  AllGamesList.swift
//  Tequila
//
//  Created by Ben Tettmar on 30/11/2024.
//

import SwiftUI

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
                                GameListItem(model: model)
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
                            FilterPopover(model: model)
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
                            NewGameRequestSheet(model: model, showSheet: $showNewGamePopover)
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
