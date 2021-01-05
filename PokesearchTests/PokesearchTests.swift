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
        sut.setListOfPokemons()
        
        let number = sut.listOfTopPokemons.count
        
        XCTAssertEqual(number, 4)
    }
    
    func testHelloWorld(){
        var helloWorld:String?
        
        XCTAssertNil(helloWorld)
        
        helloWorld = "hello world"
        XCTAssertEqual(helloWorld, "hello world")
    }

}
