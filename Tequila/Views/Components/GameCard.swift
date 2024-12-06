//
//  GameCard.swift
//  Tequila
//
//  Created by Ben Tettmar on 06/12/2024.
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
