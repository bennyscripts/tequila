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

struct EditGameView: View {
    @ObservedObject var model: ViewModel
    @EnvironmentObject var game: Game
    @Binding var showSheet: Bool
    
    @State private var native = "N/A"
    @State private var rosetta_2 = "N/A"
    @State private var crossover = "N/A"
    @State private var parallels = "N/A"
    @State private var aliases = ""
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
                    Text("Edit Game Request")
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
                            if native != game.compatibility.native || rosetta_2 != game.compatibility.rosetta_2 || crossover != game.compatibility.crossover || parallels != game.compatibility.parallels || aliases != game.aliases.joined(separator: ", ") {
                                model.editGameRequest(title: game.title, native: native, rosetta_2: rosetta_2, crossover: crossover, parallels: parallels, aliases: aliases)
                                native = game.compatibility.native
                                rosetta_2 = game.compatibility.rosetta_2
                                crossover = game.compatibility.crossover
                                parallels = game.compatibility.parallels
                                aliases = game.aliases.joined(separator: ", ")
                                submitted = true
                            }
                        }
                        .disabled(native == game.compatibility.native && rosetta_2 == game.compatibility.rosetta_2 && crossover == game.compatibility.crossover && parallels == game.compatibility.parallels && aliases == game.aliases.joined(separator: ", "))
                    }
                }
                .padding(.top, 10)
                .padding(.bottom)
                .padding(.horizontal)
                .onAppear() {
                    native = game.compatibility.native
                    rosetta_2 = game.compatibility.rosetta_2
                    crossover = game.compatibility.crossover
                    parallels = game.compatibility.parallels
                    aliases = game.aliases.joined(separator: ", ")
                    
                    if model.gameRequestCooldown {
                        submitted = true
                    }
                }
            }
            .frame(width: 300)
        }
    }
}

struct GameDetailedView: View {
    @EnvironmentObject var game: Game
//    @EnvironmentObject var favourites: Favourites
    @ObservedObject var model: ViewModel
    var from: String
    @State var gameArtURL: String = "https://placehold.co/225x300.jpg"
    @State var giantBombGame: GiantBombGame? = nil
    @State var gameDescription: String = "No description found..."
    @State var favourite: Bool = false
    
    @State var nativePopover = false
    @State var rosettaPopover = false
    @State var crossoverPopover = false
    @State var parallelsPopover = false
    @State var editGameRequestPopover = false
    @State var showRequestCooldownPopover = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("\(bestTranslationLayer(game: game))")
                    .font(.title)
                Spacer()
            }
            .padding()
            .background(Color.gray.opacity(0.05))
            .overlay(
                RoundedRectangle(cornerRadius: 7.5)
                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
            )
            .cornerRadius(7.5)
            .padding(.bottom, -5)
            
            HStack(alignment: .top) {
                VStack {
                    AsyncImage(url: URL(string: gameArtURL)!) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 225, height: 300)
                            .clipped()
                            .cornerRadius(7.5)
                    } placeholder: {
                        ProgressView()
                    }
                    if giantBombGame != nil {
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
                    .frame(minHeight: 250)
                }
                .padding(.leading, 8)
            }
            .padding(.vertical)
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
            }
        }
        .padding(.top)
        .padding(.horizontal)
        .padding(.bottom, from.localizedCaseInsensitiveContains("GamesListView") ? 16 : 0)
        .navigationTitle(game.title)
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button(action: {editGameRequestPopover.toggle()}) {
                    Image(systemName: "square.and.pencil")
                }
                .disabled(model.gameRequestCooldown)
                .sheet(isPresented: $editGameRequestPopover) {
                    EditGameView(model: model, showSheet: $editGameRequestPopover).environmentObject(game)
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
                Button(action: {
                    if model.favourites.hitLimit() {
                        print("hit limit")
                    } else {
                        favourite.toggle()
                        
                        if favourite {
                            model.favourites.add(game)
                        } else {
                            model.favourites.remove(game)
                        }
                    }
                }) {
                    Image(systemName: favourite ? "star.fill" : "star")
                        .overlay {
                            if favourite {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.yellow)
                            }
                        }
                }
            }
        }
        .onDisappear() {
            model.showRefreshButton = true
            model.showAddGameButton = true
        }
        .onAppear {
            model.showRefreshButton = false
            model.showAddGameButton = false
            
            favourite = model.favourites.contains(game)
            model.webService.searchGiantBomb(query: game.title) { result in
                if result.count > 0 {
                    giantBombGame = result[0]
                    gameArtURL = giantBombGame!.image!.medium_url
                    
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
    }
}
