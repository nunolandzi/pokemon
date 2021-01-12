//
//  DecodableStructs.swift
//  Pokesearch
//
//  Created by Nuno Silva on 05/01/2021.
//

import Foundation

struct Resource: Decodable {
    let count: Int
    let next: String
    let results: [Res]
}

struct Res: Decodable {
    let name: String
    let url: URL
}

struct ResourceForSpecificPokemon: Decodable {
    let id: Int
    let name: String
    let sprites: Sprites
    let weight: Int
    let height: Int
    let base_experience: Int
    let abilities: [Abilities]
}

struct Sprites: Decodable {
    let front_default: String?
}

struct Abilities: Decodable {
    let ability: Ability
}

struct Ability: Decodable {
    let name: String
}
