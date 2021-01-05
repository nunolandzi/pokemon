//
//  Pokemon.swift
//  Pokesearch
//
//  Created by Nuno Silva on 30/12/2020.
//

import UIKit

struct Pokemon {
    let id: Int
    let name: String
    let image: UIImage
    let weight: Int
    let heigt: Int
    let base_experience: Int
    let ability: String
}


typealias PokemonData = (title: String, value: String)

extension Pokemon {
  var tableRepresentation: [PokemonData] {
    return [
        ("ID", id.description),
        ("Name", name),
        ("Weight", weight.description),
        ("Height", heigt.description),
        ("Base Experience", base_experience.description),
        ("Ability", ability)
    ]
  }
}

