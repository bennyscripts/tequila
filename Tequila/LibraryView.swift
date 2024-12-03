//
//  LibraryView.swift
//  Tequila
//
//  Created by Ben Tettmar on 01/12/2024.
//

import SwiftUI

struct GameCard: View {
    @EnvironmentObject var game: Game
    @EnvironmentObject var model: ViewModel
    
    @State var appeared = false
    @State var giantBombGame: GiantBombGame? = nil
    @State var imageScale = 1.0
    @State var imageRotation = 0.0
    @State var imageBlur = 0.0
    @State var shadowY = 2.0
    @State var shadowRadius = 5.0
    @State var textOpacity = 0.0
    @State var gameArtURL: String = "https://placehold.co/225x300.jpg"
    
    var body: some View {
        ZStack {
            AsyncImage(url: URL(string: gameArtURL)!) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 225, height: 300)
                    .scaleEffect(CGFloat(imageScale))
                    .rotationEffect(.degrees(imageRotation))
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
        .cornerRadius(5)
        .shadow(radius: 2, x: 0, y: shadowY)
        .onHover { hovering in
            withAnimation(Animation.bouncy(duration: 0.5)) {
                imageBlur = hovering ? 5 : 0
                imageScale = hovering ? 1.3 : 1.0
                imageRotation = hovering ? [2, -2].randomElement()! : 0
                shadowY = hovering ? 5 : 2
                textOpacity = hovering ? 1 : 0
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


struct LibraryView: View {
    @ObservedObject var model: ViewModel
    @EnvironmentObject var gamesList: Games
    @EnvironmentObject var favourites: Favourites
    
    var body: some View {
        if gamesList.games.isEmpty {
            ProgressView()
        } else {
            if favourites.isEmpty() {
                Text("No favourites yet")
                    .font(.headline)
                Text("Add some games to your library by tapping the star icon on a game's page.")
                    .font(.subheadline)
            } else {
                NavigationStack {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 225))], spacing: 10) {
                            ForEach(gamesList.games.filter{favourites.contains($0)}) { game in
                                NavigationLink(destination: GameDetailedView(model: model).environmentObject(game)) {
                                    GameCard()
                                        .environmentObject(game)
                                        .environmentObject(model)
                                }
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
    }
}
