//
//  ContentView.swift
//  Tequila
//
//  Created by Ben Tettmar on 30/11/2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var model: ViewModel
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: LibraryView(model: model).environmentObject(model.gamesList).environmentObject(model.favourites)) {
                    Label(" Library", systemImage: "books.vertical")
                }
                NavigationLink(destination: GamesListView(model: model).environmentObject(model.gamesList).environmentObject(model.favourites)) {
                    Label(" Games", systemImage: "gamecontroller")
                }
            }
            .listStyle(SidebarListStyle())
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button(action: {
                        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
                    }) {
                        Image(systemName: "sidebar.left")
                    }
                }
            }
            
            LibraryView(model: model)
                .environmentObject(model.gamesList)
                .environmentObject(model.favourites)
        }
        .frame(minWidth: 875, minHeight: 500)
    }
}
