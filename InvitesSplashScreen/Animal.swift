//
//  Animal.swift
//  InvitesSplashScreen
//
//  Created by Ludovic Riviere on 07/02/2025.
//

import Foundation

enum Animal: String, CaseIterable {
    case lemur
    case parrot
    case eagle

    var imageName: String {
        "animal_\(rawValue)"
    }
}
