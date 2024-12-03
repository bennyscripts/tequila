//
//  GameDetailedView.swift
//  Tequila
//
//  Created by Ben Tettmar on 30/11/2024.
//

import SwiftUI
import SwiftSoup

struct CompatibilityDetailedView: View {
    var compatibility: String
    var translationLayerName: String
    
    var body: some View {
        Text(compatibilityDescription(translationLayer: translationLayerName, compatibility: compatibility))
            .font(.subheadline)
            .foregroundColor(.secondary)
        .padding()
    }
}

struct GameDetailedView: View {
    @EnvironmentObject var game: Game
//    @EnvironmentObject var favourites: Favourites
    @ObservedObject var model: ViewModel
    @State var gameArtwork: String = "No artwork found."
    @State var giantBombGame: GiantBombGame? = nil
    @State var gameDescription: String = "No description found..."
    @State var favourite: Bool = false
    
    @State var nativePopover = false
    @State var rosettaPopover = false
    @State var crossoverPopover = false
    @State var parallelsPopover = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("\(bestTranslationLayer(game: game))")
                    .font(.title)
                Spacer()
            }
            .padding()
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(5)
            
            HStack(alignment: .top) {
                VStack {
                    if giantBombGame != nil {
                        AsyncImage(url: URL(string: giantBombGame!.image!.medium_url)!) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 225, height: 300)
                                .clipped()
                                .cornerRadius(5)
                        } placeholder: {
                            ProgressView()
                        }
                        Button(action: {
                            if let url = URL(string: giantBombGame?.site_detail_url ?? "https://www.giantbomb.com/") {
                                NSWorkspace.shared.open(url)
                            }
                        }) {
                            HStack {
                                Text("Powered by")
                                Image("giantbomb")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100, height: 20)
                                    .offset(x: -35)
                            }
                            .offset(x: -20, y: 5)
                        }
                        .buttonStyle(PlainButtonStyle())
                    } else {
                        Image(.placeholder)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 225, height: 300)
                            .clipped()
                            .cornerRadius(5)
                    }
                }
                VStack(alignment: .leading) {
                    Text(giantBombGame?.name ?? game.title)
                        .font(.title)
                        .lineLimit(1)
                    Text("Released: \(giantBombGame?.original_release_date ?? "Unknown")")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 5)
                    ScrollView(showsIndicators: false) {
                        Text(gameDescription)
                            .font(.body)
                    }
                }
                .padding(.leading)
            }
            .padding(.bottom)
            .padding(.top, 8)
            Spacer()
            HStack {
                Button(action: {nativePopover.toggle()}) {
                    Text("Native: \(game.compatibility.native)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.trailing, 10)
                }
                .buttonStyle(PlainButtonStyle())
                .popover(isPresented: $nativePopover, arrowEdge: .top) {
                    CompatibilityDetailedView(compatibility: game.compatibility.native, translationLayerName: "Native")
                }
                Button(action: {rosettaPopover.toggle()}) {
                    Text("Rosetta 2: \(game.compatibility.rosetta_2)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.trailing, 10)
                }
                .buttonStyle(PlainButtonStyle())
                .popover(isPresented: $rosettaPopover, arrowEdge: .top) {
                    CompatibilityDetailedView(compatibility: game.compatibility.rosetta_2, translationLayerName: "Rosetta 2")
                }
                Button(action: {crossoverPopover.toggle()}) {
                    Text("CrossOver: \(game.compatibility.crossover)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.trailing, 10)
                }
                .buttonStyle(PlainButtonStyle())
                .popover(isPresented: $crossoverPopover, arrowEdge: .top) {
                    CompatibilityDetailedView(compatibility: game.compatibility.crossover, translationLayerName: "CrossOver")
                }
                Button(action: {parallelsPopover.toggle()}) {
                    Text("Parallels: \(game.compatibility.parallels)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.trailing, 10)
                }
                .buttonStyle(PlainButtonStyle())
                .popover(isPresented: $parallelsPopover, arrowEdge: .top) {
                    CompatibilityDetailedView(compatibility: game.compatibility.parallels, translationLayerName: "Parallels")
                }
                Spacer()
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
        }
        .padding()
        .navigationTitle(game.title)
        .onAppear {
            favourite = model.favourites.contains(game)
            
            model.webService.searchGiantBomb(query: game.title) { result in
                if result.count > 0 {
                    giantBombGame = result[0]
                    
                    if giantBombGame!.name.lowercased() == game.title.lowercased() {
                        if giantBombGame!.description != nil {
                            gameDescription = ""
                            
                            do {
                                var html = giantBombGame!.description ?? ""
                                if html.contains("<h2>") {
                                    let htmlArray = html.components(separatedBy: "<h2>")
                                    html = htmlArray[1]
                                }
                                let paragraphs = try SwiftSoup.parse(html).select("p")
                                for paragraph in paragraphs {
                                    gameDescription += try paragraph.text() + "\n\n"
                                }
                            } catch Exception.Error(let type, let message) {
                                print(type)
                                print(message)
                            } catch {
                                print("error")
                            }
                        } else {
                            gameDescription = giantBombGame!.deck
                        }
                    } else {
                        giantBombGame = nil
                    }
                }
            }
        }
        .onDisappear {
            model.updateView()
        }
    }
}
