//
//  HTTPClient.swift
//  Pokesearch
//
//  Created by Nuno Silva on 30/12/2020.
//

import UIKit

final class HTTPClient{
    private var urlString = "https://pokeapi.co/api/v2/pokemon?limit=20&offset="
    
    func fetchPokemonsResource(offset:String, completion: @escaping (Result<[Res], Error>)->Void){
        let urlWithOffset = urlString + offset
        URLSession.shared.dataTask(with: URL(string: urlWithOffset)!) { (data, respone, error) in
            guard let data = data else { return }
            
            do{
                
                let jsonResources = try JSONDecoder().decode(Resource.self, from: data)
                
                return completion(.success( jsonResources.results))
                
                }catch let jsonErr{
                    print("Erro ao serializar o json:", jsonErr)
                }
            }.resume()
    }
    
    
    
    
    func fetchPokemons(url:URL, completion: @escaping (Result<Pokemon, Error>)->Void){
        
        URLSession.shared.dataTask(with: url) { (data, respone, error) in
        
            guard let data = data else { return }
            do{
                let jsonPokemons = try JSONDecoder().decode(ResourceForSpecificPokemon.self, from: data)
                            
                        //Create new pokemon object
                        let newPokemon:Pokemon?
                        
                        //Check whether pokemon has image url or not
                        if let imageUrlString = jsonPokemons.sprites.front_default{
                            let data = try Data(contentsOf: URL(string: imageUrlString)!)
                            let image = UIImage(data: data)
                            newPokemon = Pokemon(id: jsonPokemons.id, name: jsonPokemons.name, image: image!, weight: jsonPokemons.weight,heigt: jsonPokemons.height, base_experience: jsonPokemons.base_experience, ability: jsonPokemons.abilities.first!.ability.name)
                        }else{
                            newPokemon = Pokemon(id: jsonPokemons.id,name: jsonPokemons.name, image: UIImage(named: "pokemon")!, weight: jsonPokemons.weight, heigt: jsonPokemons.height,base_experience: jsonPokemons.base_experience,ability: jsonPokemons.abilities.first!.ability.name)
                        }
                
                completion(.success(newPokemon!))
            
            }catch let jsonErr{
                            print("Erro ao serializar o json:", jsonErr)
                        }
                    }.resume()
                
    }
    
    func postFavoritePokemonJSON(pokemondata: PokemonVM) {
        
        //Declare parameters
        let params = ["name":pokemondata.name, "experience":pokemondata.base_experience] as [String : Any]
        
        //Create Url
        let url = URL(string: "https://webhook.site/decdc200-b7e7-47d1-bedb-5ebfecc11bdf")
        
        //Create URL Request object using url
        var  request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        }catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            
            do{
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]{
                    print(json)
                }
            }catch let error{
                print(error.localizedDescription)
            }
        }.resume()
    }
    
}
