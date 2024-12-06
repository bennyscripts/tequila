//
//  AddGameSheet.swift
//  Tequila
//
//  Created by Ben Tettmar on 06/12/2024.
//

import SwiftUI

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
