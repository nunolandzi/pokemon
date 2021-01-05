//
//  SearchPokemonViewController.swift
//  Pokesearch
//
//  Created by Nuno Silva on 30/12/2020.
//

import UIKit

class SearchPokemonViewController: UIViewController {
    
    private let cellIdentifier = "collectionCell"
    private let httpClient = HTTPClient()
    private let isOnline = true
    private var listOfPokemons:[Pokemon] = []
    private var filteredPokemons:[Pokemon] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    lazy var pokemonsColectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionview.backgroundColor = .clear
        collectionview.dataSource = self
        collectionview.delegate = self
        
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        return collectionview
    }()
    
    
    private var isSearchBarEmpty: Bool {
        //Return true if the text typed in the search bar is empty otherwise, return false
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private var isFiltering: Bool {
        //Return true if text is being filtered
        return searchController.isActive && !isSearchBarEmpty
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set searchbar delegate
        searchController.searchBar.delegate = self
        
        pokemonsColectionView.register(PageCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        //Get list of all pokemons from server
        httpClient.getPokemonsResource { (data) in
            if let _ = data{
                self.httpClient.getListOfPokemonsJSON { (pokedata) in
                    if let _ = pokedata{
                        self.listOfPokemons = self.httpClient.getPokemons()
                        //Reload data to show pokemons after getting them from server
                        DispatchQueue.main.async {
                            self.pokemonsColectionView.reloadData()
                        }
                    }
                }
            }
        }
        
        setupViews()
    }

    fileprivate func setupViews(){
        
        //Informar a class de qualquer alteracao de texto dentro do UISearchBar
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        //Add searchBar to navBar
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        view.backgroundColor = .systemGroupedBackground
        
        view.addSubview(pokemonsColectionView)
    
        pokemonsColectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        pokemonsColectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        pokemonsColectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        pokemonsColectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}


extension SearchPokemonViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //Set size to show only two pokemons per row
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (pokemonsColectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: size)
    }
}

extension SearchPokemonViewController: UICollectionViewDataSource{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if isFiltering {
            return filteredPokemons.count
          }
    
        return listOfPokemons.count
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = pokemonsColectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? PageCell

        cell?.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        cell?.layer.masksToBounds = true
        cell?.layer.cornerRadius = 10
        
        //Set pokemon 
        let pokemon:Pokemon
        if isFiltering{
            pokemon = filteredPokemons[indexPath.item]
        }else{
            pokemon = listOfPokemons[indexPath.item]
        }
        
        cell?.pokemon = pokemon
       
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsVC = PokemonDetailViewController()
        
        let pokemon: Pokemon
        if isFiltering{
            pokemon = filteredPokemons[indexPath.item]
        }else{
            pokemon = listOfPokemons[indexPath.item]
        }
        
        detailsVC.navigationItem.title = pokemon.name
        detailsVC.selectedPokemon = pokemon.tableRepresentation
        detailsVC.headerImage.image = pokemon.image
        
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
}


extension SearchPokemonViewController: UISearchBarDelegate{

    
    func filterContentForSearchText(_ searchText: String, status: String? = nil) {
        //Filter reports based on searchText and puts the results in filteredReports
        filteredPokemons = listOfPokemons.filter { (pokemon: Pokemon) -> Bool in
            
        return pokemon.name.lowercased().contains(searchText.lowercased())
      }
      pokemonsColectionView.reloadData()
    }
}

extension SearchPokemonViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        
        filterContentForSearchText(searchController.searchBar.text!)
        
    }
}

