//
//  PokesearchTests.swift
//  PokesearchTests
//
//  Created by Nuno Silva on 04/01/2021.
//

import XCTest
@testable import Pokesearch

var sut: SwipingCollectionViewController!

class PokesearchTests: XCTestCase {
    
    func testTopPokemonsList(){
        sut = SwipingCollectionViewController()
        let pokemon1 = Pokemon(id: 1, name: "Venusaur", image: UIImage(), weight: 10, heigt: 10, base_experience: 100, ability: "")
        let venusaur = PokemonVM(pokemon: pokemon1)
        let pokemon2 = Pokemon(id: 1, name: "metapod", image: UIImage(), weight: 10, heigt: 10, base_experience: 200, ability: "")
        let metapod = PokemonVM(pokemon: pokemon2)
        let pokemon3 = Pokemon(id: 1, name: "kakuna", image: UIImage(), weight: 10, heigt: 10, base_experience: 300, ability: "")
        let kakuna = PokemonVM(pokemon: pokemon3)
        let pokemons = [venusaur,metapod,kakuna]
        
        sut.getTopByExperience(listOfPokemons:pokemons)
        let top = sut.listOfTopPokemons
        
        XCTAssertTrue(top.count == 1)
    }
    
    func testPokemonVM() {
        let pokemon = Pokemon(id: 123, name: "myPokemon", image: UIImage(), weight: 2, heigt: 4, base_experience: 20, ability: "myAbility")
        
        let pokemonVM = PokemonVM(pokemon: pokemon)
        
        XCTAssertEqual(pokemon.name, pokemonVM.name)
    }
    
    func testHelloWorld(){
        var helloWorld:String?
        
        XCTAssertNil(helloWorld)
        
        helloWorld = "hello world"
        XCTAssertEqual(helloWorld, "hello world")
    }

}
