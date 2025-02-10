//
//  AnimalCard.swift
//  InvitesSplashScreen
//
//  Created by Ludovic R. on 10/02/2025.
//

import SwiftUI

struct AnimalCard: View {
    let animal: Animal

    var body: some View {
        ZStack(alignment: .topLeading) {
            Image(animal.imageName)
                .resizable()
                .clipShape(.rect(cornerRadius: 16))
            Text(animal.category)
                .font(.caption2)
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
                .padding(10)
        }
    }
}
