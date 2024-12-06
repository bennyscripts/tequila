//
//  LibraryView.swift
//  Tequila
//
//  Created by Ben Tettmar on 01/12/2024.
//

import SwiftUI

struct LibraryView: View {
    @ObservedObject var model: ViewModel
    @EnvironmentObject var gamesList: Games
    @EnvironmentObject var favourites: Favourites
    
    @State private var showAddGameSheet = false
    
    var body: some View {
        if gamesList.games.isEmpty {
            ProgressView()
        } else {
            if favourites.isEmpty() {
                VStack(alignment: .leading) {
                    HStack {
                        Button(action: {
                            showAddGameSheet.toggle()
                        }) {
                            Image(systemName: "plus")
                                .padding()
                                .foregroundColor(.accentColor)
                                .background(Color.gray.opacity(0.05))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 7.5)
                                    .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                                )
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.trailing, 5)
                        VStack(alignment: .leading) {
                            Text("No games saved yet!")
                                .font(.headline)
                            Text("Add a game to your library by pressing the plus button!")
                                .font(.subheadline)
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 7.5)
                    .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                )
                .cornerRadius(7.5)
            } else {
                NavigationStack {
                    ScrollView(showsIndicators: false) {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 225))], spacing: 10) {
                            ForEach(gamesList.games.filter{favourites.contains($0)}) { game in
                                NavigationLink(destination: GameDetailedView(model: model, from: "LibraryView").environmentObject(game)) {
                                    GameCard(noHover: false)
                                        .environmentObject(game)
                                        .environmentObject(model)
                                }
                                .cornerRadius(7.5)
                                .buttonStyle(PlainButtonStyle())
                                .contextMenu {
                                    Button(action: {
                                        favourites.remove(game)
                                        model.updateView()
                                    }) {
                                        Label("Remove from favourites", systemImage: "star.slash")
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        Text("")
        .toolbar {
            if model.showAddGameButton {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button(action: {
                        showAddGameSheet.toggle()
                    }) {
                        Label("Search", systemImage: "plus")
                    }
                    .sheet(isPresented: $showAddGameSheet) {
                        AddGameSheet(model: model, favourites: favourites, showAddGameSheet: $showAddGameSheet)
                            .environmentObject(gamesList)
                    }
                }
            }
        }
        .onAppear() {
            model.showAddGameButton = true
        }
        .onDisappear() {
            model.showAddGameButton = false
        }
    }
}
