//
//  ContentView.swift
//  Tequila
//
//  Created by Ben Tettmar on 30/11/2024.
//

import SwiftUI

class ViewModel: ObservableObject {
    @Published var gamesList = Games()
    @Published var favourites = Favourites()
    @Published var webService = WebService()
    @Published var showRefreshButton = false
    @Published var refreshButtonCooldown = false
    
    func updateView() {
        self.objectWillChange.send()
    }
    
    func refresh() {
        if !refreshButtonCooldown {
            self.gamesList.refresh()
            self.favourites.save()
            self.refreshButtonCooldown = true
        } else {
            print("Cooldown in effect! Please dont spam my API 🙏")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.refreshButtonCooldown = false
        }
    }
}

struct ContentView: View {
    @ObservedObject var model = ViewModel()
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: LibraryView(model: model).environmentObject(model.gamesList).environmentObject(model.favourites)) {
                    Label(" Library", systemImage: "books.vertical")
                }
                NavigationLink(destination: GamesListView(model: model).environmentObject(model.gamesList).environmentObject(model.favourites)) {
                    Label(" Games", systemImage: "gamecontroller")
                }
//                NavigationLink(destination: AboutView()) {
//                    Label(" About", systemImage: "info.circle")
//                }
            }
            .padding(.top, 20)
            .listStyle(.sidebar)
            
            LibraryView(model: model)
                .environmentObject(model.gamesList)
                .environmentObject(model.favourites)
//            GamesListView(model: model)
        }
        .frame(minWidth: 875, minHeight: 500)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: {
                    NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
                }) {
                    Image(systemName: "sidebar.left")
                }
            }
        }
    }
}
