//
//  NewGameRequestSheet.swift
//  Tequila
//
//  Created by Ben Tettmar on 06/12/2024.
//

import SwiftUI

struct NewGameRequestSheet: View {
    @ObservedObject var model: ViewModel
    @Binding var showSheet: Bool
    
    @State private var title = ""
    @State private var native = "N/A"
    @State private var rosetta_2 = "N/A"
    @State private var crossover = "N/A"
    @State private var parallels = "N/A"
    @State private var aliases = ""
    @State private var showEmptyTitleWarning = false
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
                    Text("New Game Request")
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
                        Text("Title")
                        Spacer()
                        TextField("Epic Game III", text: $title)
                            .cornerRadius(7)
                            .frame(width: 174)
                    }
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
                    .padding(.top, 1)
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
                            if title.isEmpty {
                                showEmptyTitleWarning.toggle()
                            } else {
                                model.addGameRequest(title: title, native: native, rosetta_2: rosetta_2, crossover: crossover, parallels: parallels, aliases: aliases)
                                title = ""
                                native = "N/A"
                                rosetta_2 = "N/A"
                                crossover = "N/A"
                                parallels = "N/A"
                                aliases = ""
                                submitted = true
                            }
                        }
                        .disabled(title.isEmpty)
                    }
                }
                .padding(.top, 10)
                .padding(.bottom)
                .padding(.horizontal)
                .onAppear() {
                    if model.gameRequestCooldown {
                        submitted = true
                    }
                }
            }
            .frame(width: 300)
        }
    }
}
