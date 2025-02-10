//
//  Animal.swift
//  InvitesSplashScreen
//
//  Created by Ludovic R. on 07/02/2025.
//

import Foundation

enum Animal: String, CaseIterable {
    case lemur
    case parrot
    case eagle

    var imageName: String {
        "animal_\(rawValue)"
    }

    var category: String {
        switch self {
        case .lemur: "Monkey"
        case .parrot, .eagle: "Bird"
        }
    }

    var name: String {
        switch self {
        case .lemur: "Lemur"
        case .parrot: "Parrot"
        case .eagle: "Eagle"
        }
    }

    var place: String {
        switch self {
        case .lemur: "Madagascar"
        case .parrot: "Central America"
        case .eagle: "Arctic"
        }
    }
}
