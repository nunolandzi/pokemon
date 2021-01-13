//
//  PokemonVM.swift
//  Pokesearch
//
//  Created by Nuno Silva on 13/01/2021.
//

import Foundation
import UIKit

struct PokemonVM{
    let id: Int
    let name: String
    let image: UIImage
    let weight: Int
    let heigt: Int
    let base_experience: Int
    let ability: String
    
    
    //Dependency Injection
    init(pokemon: Pokemon){
        self.id = pokemon.id
        self.name = pokemon.name
        self.image = pokemon.image
        self.weight = pokemon.weight
        self.heigt = pokemon.heigt
        self.base_experience = pokemon.base_experience
        self.ability = pokemon.ability
    }
}

typealias PokemonVMData = (title: String, value: String)

extension PokemonVM {
  var tableRepresentation: [PokemonVMData] {
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
