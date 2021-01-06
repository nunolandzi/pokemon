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
        
        let client = sut.httpClient
        let exp = expectation(description: "Loading pokemons")

        client.getPokemonsResource { (data) in
            if let _ = data{
                
                exp.fulfill()
            }
        }
        let number = client.getResources().count
        waitForExpectations(timeout: 10)
        XCTAssertNotNil(number)
    }
    
    func testHelloWorld(){
        var helloWorld:String?
        
        XCTAssertNil(helloWorld)
        
        helloWorld = "hello world"
        XCTAssertEqual(helloWorld, "hello world")
    }

}
