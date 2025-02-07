//
//  ContentView.swift
//  InvitesSplashScreen
//
//  Created by Ludovic Riviere on 07/02/2025.
//

import SwiftUI

struct ContentView: View {
    let animals = Animal.allCases

    @State private var isVisible = false
    @State private var scrollID: Int?
    @State private var backgroundName = Animal.lemur.imageName

    var body: some View {
        ZStack {
            Image(backgroundName)
                .resizable()
                .ignoresSafeArea()
            ScrollView {
                if !isVisible {
                    Color.clear
                }
                VStack(spacing: 32) {
                    if isVisible {
                        cardsView
                            .transition(.opacity.combined(with: .move(edge: .top)))
                    } else {
                        EmptyView()
                            .frame(height: 320)
                    }
                    if isVisible {
                        titlesView
                            .transition(.opacity.combined(with: .offset(y: -30)))
                    }
                }
                .padding(.vertical, 32)
            }
            .clipped()
            .background(.regularMaterial)
        }
        .onChange(of: scrollID, initial: false) { _, newValue in
            if let scrollID = newValue {
                withAnimation {
                    backgroundName = animals[scrollID % animals.count].imageName
                }
            }
        }
        .onAppear {
            withAnimation(.interpolatingSpring(duration: 1).delay(1)) {
                isVisible = true
            }
        }
    }

    var titlesView: some View {
        VStack(spacing: 8) {
            Text("Welcome to")
                .bold()
                .foregroundStyle(.white.opacity(0.5))

            Text("Apple Invites")
                .font(.system(size: 40, weight: .bold, design: .default))
                .bold()
                .foregroundStyle(.white)

            Text("Create beautiful invitations for all your events. Anyone can receive invitations. Sending included with iCloud+")
                .font(.callout)
                .multilineTextAlignment(.center)
                .foregroundStyle(.white.opacity(0.5))

            Button {

            } label: {
                Text("Create an Event")
                    .fontWeight(.medium)
                    .padding(.vertical)
                    .padding(.horizontal, 32)
                    .background(Color.white)
                    .foregroundStyle(.black)
                    .clipShape(Capsule())
            }
            .padding(.vertical, 40)
        }
        .padding(.horizontal)
    }

    var cardsView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(0..<9) { i in
                    Image(animals[i % animals.count].imageName)
                        .resizable()
                        .clipShape(.rect(cornerRadius: 16))
                        .aspectRatio(2.0 / 3.2, contentMode: .fill)
                        .frame(width: 200)
                        .scrollTransition(
                            axis: .horizontal
                        ) { content, phase in
                            content
                                .rotationEffect(.degrees(phase.value * 2))
                                .offset(y: phase.isIdentity ? 0 : 16)
                        }
                        .shadow(radius: 5)
                        .id(i)
                }
            }
            .scrollTargetLayout()
        }
        .defaultScrollAnchor(.center)
        .scrollClipDisabled()
        .scrollPosition(id: $scrollID)
        .safeAreaPadding(.horizontal, 20.0)
    }
}

#Preview {
    ContentView()
}
