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
        let venusaur = Pokemon(id: 1, name: "Venusaur", image: UIImage(), weight: 10, heigt: 10, base_experience: 100, ability: "")
        let metapod = Pokemon(id: 1, name: "metapod", image: UIImage(), weight: 10, heigt: 10, base_experience: 200, ability: "")
        let kakuna = Pokemon(id: 1, name: "kakuna", image: UIImage(), weight: 10, heigt: 10, base_experience: 300, ability: "")
        let pokemons = [venusaur,metapod,kakuna]
        
        sut.getTopByExperience(listOfPokemons:pokemons)
        let top = sut.listOfTopPokemons
        
        XCTAssertTrue(top.count == 1)
    }
    
    func testHelloWorld(){
        var helloWorld:String?
        
        XCTAssertNil(helloWorld)
        
        helloWorld = "hello world"
        XCTAssertEqual(helloWorld, "hello world")
    }

}
