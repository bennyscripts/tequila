//
//  EditGameRequestSheet.swift
//  Tequila
//
//  Created by Ben Tettmar on 06/12/2024.
//

import SwiftUI

struct EditGameRequestSheet: View {
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
                            Text("Unplayable").tag("Unplayable")
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
                            Text("Unplayable").tag("Unplayable")
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
                            Text("Unplayable").tag("Unplayable")
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
                            Text("Unplayable").tag("Unplayable")
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
