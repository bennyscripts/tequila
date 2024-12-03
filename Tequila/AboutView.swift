//
//  ContentView.swift
//  Tequila
//
//  Created by Ben Tettmar on 30/11/2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var gamesList: Games
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: AllGamesListView().environmentObject(gamesList)) {
                    Text("Library")
                }
                NavigationLink(destination: AllGamesListView().environmentObject(gamesList)) {
                    Text("All Games")
                }
//                NavigationLink(destination: HomeView()) {
//                    Text("Good")
//                }
//                NavigationLink(destination: HomeView()) {
//                    Text("Unplayable")
//                }
            }
            .padding(.top, 20)
            .listStyle(.sidebar)
            
            AllGamesListView()
                .environmentObject(gamesList)
        }
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
