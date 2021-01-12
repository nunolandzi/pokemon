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
    private var isFetching = false
    private var offset = 0
    
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
        pokemonsColectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footerId")
        
        setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //Setup collectionview frame and begin fetching data
        pokemonsColectionView.frame = view.bounds
        beginFetch()
    }
    
    private func beginFetch() {
        
        httpClient.fetchPokemonsResource(offset: offset.description) { resource in
            switch resource {
            case .success(let resourcedata):
                    var index = 1
                    resourcedata.forEach { (result) in
                        self.httpClient.fetchPokemons(url: result.url) { pokemonData in
                            switch pokemonData {
                            case .success(let pokemon):
                                self.listOfPokemons.append(pokemon)
                                //Display pokemons after loading list of pokemons
                                if index == resourcedata.count{
                                    DispatchQueue.main.async {
                                        self.pokemonsColectionView.reloadData()
                                    }
                                }
                                index += 1
                            case .failure(_):
                                    break
                            }
                        }
                    }
                case .failure(_):
                        break
                }
        }
    }

    fileprivate func setupViews(){
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        //Add searchBar to navBar
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        view.backgroundColor = .systemGroupedBackground
        
        view.addSubview(pokemonsColectionView)
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

extension SearchPokemonViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        //Show footer with spinner only if not fetching results
        if !isFetching{
            return .init(width: view.frame.width, height: 200)
            
        }else{
            return CGSize.zero
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let  height = scrollView.frame.size.height
        let contentHeight = scrollView.contentSize.height
           let contentYoffset = scrollView.contentOffset.y
           
        if contentYoffset > contentHeight - height { // when you reach the bottom
            if !isFetching{
                //Set flag to true to avoid multiple fetching
                isFetching = true
                
                //Offset for the next 20 pokemons
                offset += 20
                
                beginFetch()
            }
        }
        
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        
        case UICollectionView.elementKindSectionHeader:
            let header = pokemonsColectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath)
           
            return header
        
        case UICollectionView.elementKindSectionFooter:
            let footer = pokemonsColectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footerId", for: indexPath)
           
            let spinner = UIActivityIndicatorView(style: .large)
            spinner.center = footer.center
            spinner.startAnimating()
            footer.addSubview(spinner)

            return footer
        default:
            assert(false, "Unexpected kind")
        }
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

