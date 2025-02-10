//
//  SplashScreenView.swift
//  InvitesSplashScreen
//
//  Created by Ludovic R. on 10/02/2025.
//

import SwiftUI

/// Jump to ✨ marks to see tips & tricks
struct SplashScreenView: View {
    @State private var isCardsVisible = false
    @State private var isTitleVisible = false
    @State private var isTextsVisible = false

    @State private var animalsArray: [[Animal]] = []
    @State private var scrollID: Int? = 0
    @State private var backgroundAnimal: Animal = .parrot

    @State private var xOffset: CGFloat = .zero
    @State private var timer: Timer?

    private let animals = Animal.allCases

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
                            titleText("Animal Invites")
                                .customAttribute(EmphasisAttribute())
                                .transition(TextTransition(duration: Self.animationDuration))
                        } else {
                            titleText("")
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
}

// MARK: - Constants

private extension SplashScreenView {
    static let animationDuration: TimeInterval = 1.0
    static let cardSpacing: CGFloat = 16
    static let cardsContainerHeight: CGFloat = 320
    static let cardWidth: CGFloat = 200
}

// MARK: - Animations

private extension SplashScreenView {
    func startAnimations() {
        guard !isCardsVisible, !isTextsVisible, !isTitleVisible else { return }
        startAnimation(delay: 0.5) { isCardsVisible = true }
        startAnimation(delay: 0.75) { isTextsVisible = true }
        startAnimation(delay: 0.8) { isTitleVisible = true }
    }

    func startAnimation(delay: TimeInterval, block: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            withAnimation(.interpolatingSpring(duration: Self.animationDuration)) { block() }
        }
    }

    func startAutoScrollAnimation(_ viewWidth: CGFloat) {
        timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
            Task { @MainActor in
                withAnimation {
                    xOffset -= 1
                    if xOffset <= -viewWidth * CGFloat(animalsArrayCount - 1) {
                        xOffset = 0
                    }
                }
            }
        }
    }
}

// MARK: - Subviews

private extension SplashScreenView {
    /// Horizontal cards
    @ViewBuilder var cardsView: some View {
        let flattenAnimals = animalsArray.flatMap { $0.map { $0 } }
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Self.cardSpacing) {
                    ForEach(0..<flattenAnimals.count, id: \.self) { index in
                        let animal = flattenAnimals[index]
                        AnimalCard(animal: animal)
                            .aspectRatio(
                                Self.cardWidth / Self.cardsContainerHeight,
                                contentMode: .fill
                            )
                            .frame(width: Self.cardWidth)
                            .scrollTransition(axis: .horizontal) { content, phase in
                                content
                                    .rotationEffect(.degrees(phase.value * 2.5))
                                    .offset(y: phase.isIdentity ? 0 : 16)
                            }
                            .shadow(radius: 4)
                    }
                }
                .offset(x: xOffset)
                .onAppear {
                    startAutoScrollAnimation(geometry.size.width)
                }
                .onDisappear {
                    timer?.invalidate()
                    isCardsVisible = false
                    isTextsVisible = false
                    isTitleVisible = false
                }
                .onChange(of: currentIndex, initial: false) { _, index in
                    backgroundAnimal = flattenAnimals[index]
                    withAnimation(nil) {
                        if index >= animalsArrayCount - 3 {
                            animalsArray.append(animals)
                        }
                    }
                }
            }
            .disabled(true)
            .frame(height: Self.cardsContainerHeight)
            .scrollClipDisabled()
            .safeAreaPadding(.horizontal, 20.0)
        }
        .frame(height: Self.cardsContainerHeight)
    }

    var animalsArrayCount: Int {
        animalsArray.flatMap { $0.map { $0 } }.count
    }

    var currentIndex: Int {
        let imageWidth: CGFloat = Self.cardWidth + Self.cardSpacing
        return Int((-xOffset + imageWidth / 2) / imageWidth)
    }

    /// Placeholder to hold cards size
    var placeholderCardsView: some View {
        EmptyView()
            .frame(height: Self.cardsContainerHeight)
    }

    /// 'Welcome to'
    var welcomeToText: some View {
        Text("Welcome to")
            .bold()
            .foregroundStyle(.white.opacity(0.45))
    }

    /// Title text
    func titleText(_ text: String) -> Text {
        Text(text)
            .font(.system(size: 40, weight: .bold))
            .foregroundStyle(.white)
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
    SplashScreenView()
        .environment(\.colorScheme, .dark)
}
