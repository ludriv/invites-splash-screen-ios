//
//  ContentView.swift
//  InvitesSplashScreen
//
//  Created by Ludovic R. on 07/02/2025.
//

import SwiftUI

/// Jump to ✨ marks to see tips & tricks
struct ContentView: View {

    @State private var isCardsVisible = false
    @State private var isTitleVisible = false
    @State private var isTextsVisible = false

    @State private var animalsArray: [[Animal]] = []
    @State private var scrollID: Int? = 0
    @State private var backgroundAnimal: Animal = .parrot

    private let animals = Animal.allCases
    private let animationDuration: TimeInterval = 1

    var body: some View {
        TabView(selection: $backgroundAnimal) {
            ForEach(animals, id: \.self) { animal in
                Image(animal.imageName)
                    .resizable()
                    .ignoresSafeArea()
                    .tag(animal)
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .ignoresSafeArea()
        .overlay {
            ScrollView {
                if !isCardsVisible {
                    Color.clear
                }
                VStack(spacing: 32) {
                    if isCardsVisible {
                        cardsView
                            .transition(.opacity.combined(with: .move(edge: .top)))
                    } else {
                        placeholderCardsView
                    }

                    VStack(spacing: 8) {
                        if isTextsVisible {
                            welcomeToText
                                .transition(.opacity.combined(with: .offset(y: -30)))
                        }

                        if isTitleVisible {
                            // ✨ Apple like title transition
                            Text("Animal Invites")
                                .customAttribute(EmphasisAttribute())
                                .font(.system(size: 40, weight: .bold))
                                .foregroundStyle(.white)
                                .transition(TextTransition(duration: animationDuration))
                        } else {
                            Text("")
                                .font(.system(size: 40, weight: .bold))
                                .opacity(0)
                        }

                        if isTextsVisible {
                            descriptionText
                                .transition(.opacity.combined(with: .offset(y: -30)))
                            createEventButton
                                .transition(.opacity.combined(with: .offset(y: -40)))
                        }
                    }
                    .padding()
                }
                .padding(.vertical, 32)
            }
            .clipped()
            .background(.regularMaterial) // ✨ dark blur background
        }
        .onChange(of: scrollID, initial: false) { _, newValue in
            // ✨ background update according to scrollview offset
            if let scrollID = newValue {
                withAnimation {
                    backgroundAnimal = animals[scrollID % animals.count]
                }
            }
        }
        .onAppear {
            animalsArray = [animals, animals, animals]
            startAnimations()
        }
    }

    func startAnimations() {
        guard !isCardsVisible, !isTextsVisible, !isTitleVisible else { return }
        startAnimation(delay: 0.5) { isCardsVisible = true }
        startAnimation(delay: 0.75) { isTextsVisible = true }
        startAnimation(delay: 0.8) { isTitleVisible = true }
    }

    private func startAnimation(delay: TimeInterval, block: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            withAnimation(.interpolatingSpring(duration: animationDuration)) { block() }
        }
    }
}

// MARK: - Subviews

private extension ContentView {
    /// Horizontal cards
    @ViewBuilder var cardsView: some View {
        let flattenAnimals = animalsArray.flatMap { $0.map { $0 } }
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(0..<flattenAnimals.count, id: \.self) { index in
                    let animal = flattenAnimals[index]
                    Image(animal.imageName)
                        .resizable()
                        .clipShape(.rect(cornerRadius: 16))
                        .aspectRatio(2.0 / 3.2, contentMode: .fill)
                        .frame(width: 200)
                        .scrollTransition(axis: .horizontal) { content, phase in
                            content
                                .rotationEffect(.degrees(phase.value * 2.5))
                                .offset(y: phase.isIdentity ? 0 : 16)
                        }
                        .shadow(radius: 5)
                        .id(animal)
                }
            }
            .scrollTargetLayout()
        }
        .defaultScrollAnchor(.center)
        .scrollClipDisabled()
        .scrollPosition(id: $scrollID, anchor: .center)
        .safeAreaPadding(.horizontal, 20.0)
    }

    /// Placeholder to hold cards size
    var placeholderCardsView: some View {
        EmptyView()
            .frame(height: 320)
    }

    /// 'Welcome to'
    var welcomeToText: some View {
        Text("Welcome to")
            .bold()
            .foregroundStyle(.white.opacity(0.45))
    }

    /// Description
    var descriptionText: some View {
        Text("Create beautiful invitations for all your events. Anyone can receive invitations. Sending included with Animal+")
            .font(.callout)
            .foregroundStyle(.white.opacity(0.45))
            .multilineTextAlignment(.center)
    }

    /// 'Create an Event'
    var createEventButton: some View {
        Button {
            print("create an event")
        } label: {
            Text("Create an Event")
                .fontWeight(.medium)
                .padding(.vertical, 12)
                .padding(.horizontal, 32)
                .background(Color.white)
                .foregroundStyle(.black)
                .clipShape(Capsule())
        }
        .padding(.vertical, 40)
    }
}

// MARK: - Preview

#Preview {
    ContentView()
        .environment(\.colorScheme, .dark)
}
