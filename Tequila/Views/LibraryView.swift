//
//  LibraryView.swift
//  Tequila
//
//  Created by Ben Tettmar on 01/12/2024.
//

import SwiftUI

struct GameCard: View {
    var noHover: Bool
    @EnvironmentObject var game: Game
    @EnvironmentObject var model: ViewModel
    
    @State var appeared = false
    @State var giantBombGame: GiantBombGame? = nil
    @State var imageScale = 1.05
    @State var imageRotation = 0.0
    @State var imageBlur = 0.0
    @State var shadowY = 0.0
    @State var shadowRadius = 5.0
    @State var textOpacity = 0.0
    @State var gameArtURL: String = "https://placehold.co/225x300.jpg"
    
    init(noHover: Bool) {
        self.noHover = noHover
        shadowY = noHover ? 2.0 : 0.0
    }
    
    var body: some View {
        ZStack {
            AsyncImage(url: URL(string: gameArtURL)!) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 225, height: 300)
                    .scaleEffect(CGFloat(imageScale))
                    .rotationEffect(.degrees(imageRotation))
                    .rotation3DEffect(
                        .degrees(imageRotation),
                        axis: (x: 0.0, y: 1.0, z: 0.0)
                    )
                    .clipped()
//                    .background(Color.white.padding(-30))
                    .blur(radius: CGFloat(imageBlur))
            } placeholder: {
                ProgressView()
            }
            VStack {
                Text(game.title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.35))
                    .cornerRadius(5)
            }
            .opacity(textOpacity)
        }
        .shadow(radius: 2, x: 0, y: shadowY)
        .onHover { hovering in
            if !noHover {
                withAnimation(Animation.bouncy(duration: 0.5)) {
                    imageBlur = hovering ? 5 : 0
                    imageScale = hovering ? 1.4 : 1.05
                    imageRotation = hovering ? [2, -2].randomElement()! : 0
                    shadowY = hovering ? 5 : 2
                    textOpacity = hovering ? 1 : 0
                }
            }
        }
        .onAppear() {
            if !appeared {
                model.webService.searchGiantBomb(query: game.title) { result in
                    if result.count > 0 {
                        giantBombGame = result[0]
                        gameArtURL = giantBombGame!.image!.medium_url
                        appeared = true
                    }
                }
            }
        }
    }
}

struct AddGameSheet: View {
    @ObservedObject var model: ViewModel
    @ObservedObject var favourites: Favourites
    @Binding var showAddGameSheet: Bool
    @EnvironmentObject var gamesList: Games
    
    @Namespace private var namespace
    @State private var searchQuery = ""
    @State private var searchResults: [Game] = []
    @State private var searched = false
    
    func search() {
        searchResults = gamesList.games.filter { $0.title.localizedCaseInsensitiveContains(searchQuery) ||
            $0.aliases.contains(where: { $0.localizedCaseInsensitiveContains(searchQuery) }) }
        
        if searchResults.count > 10 {
            searchResults = Array(searchResults.prefix(10))
        }
        
        if searchResults.count == 1 {
            showAddGameSheet.toggle()
            favourites.add(searchResults[0])
            model.updateView()
        }
        
        searched = searchResults.count > 0
    }
    
    var body: some View {
        if searched && searchResults.count > 1 {
            HStack {
                Button(action: {
                    searched = false
                    searchQuery = ""
                }) {
                    Image(systemName: "chevron.left")
                }
                .buttonStyle(PlainButtonStyle())
                Text("Search results for \"\(searchQuery)\"")
                Spacer()
            }
            .padding()
            .background(Color.gray.opacity(0.05))
            .overlay(
                RoundedRectangle(cornerRadius: 0)
                    .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
            )
        }
        
        VStack {
            if !searched {
                HStack {
                    TextField("Search for a game", text: $searchQuery)
                        .prefersDefaultFocus(in: namespace)
                        .textFieldStyle(PlainTextFieldStyle())
                        .onSubmit {
                            search()
                        }
                    Button(action: {
                        search()
                    }) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.accentColor)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding()
                .background(Color.gray.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 7.5)
                        .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                )
                .cornerRadius(7.5)
            } else if searchResults.count == 1 {
                ProgressView()
            } else {
                if searchResults.count > 1 {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(searchResults) { game in
                                Button(action: {
                                    favourites.add(game)
                                    showAddGameSheet.toggle()
                                    model.updateView()
                                }) {
                                    GameCard(noHover: true)
                                        .environmentObject(game)
                                        .environmentObject(model)
                                        .opacity(favourites.contains(game) ? 0.5 : 1)
                                        .disabled(favourites.contains(game))
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .cornerRadius(7.5)
                }
            }
        }
        .padding(.horizontal)
        .padding(.bottom)
        .padding(.top, searched ? 10 : 16)
        .frame(width: searched ? (searchResults.count > 0 ? 600 : 200) : 400)
    }
}

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
