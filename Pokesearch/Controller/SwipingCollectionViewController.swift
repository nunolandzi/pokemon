//
//  SwipingCollectionViewController.swift
//  Pokesearch
//
//  Created by Nuno Silva on 30/12/2020.
//

import UIKit

class SwipingCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private let reuseIdentifier = "Cell"
    let httpClient = HTTPClient()
    var listOfTopPokemons:[PokemonVM] = []
    private let topExperienceLevel:Int = 220
    private let spinner = UIActivityIndicatorView(style: .large)
    
    private let pageControl: UIPageControl = {
        let page = UIPageControl()
        page.currentPage = 0
        page.numberOfPages = 1
        page.currentPageIndicatorTintColor = .red
        page.pageIndicatorTintColor = UIColor.red.withAlphaComponent(0.4)
        page.translatesAutoresizingMaskIntoConstraints = false
        return page
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBottomControls()
        
        navigationItem.title = "Top Pokemons"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        collectionView.backgroundColor = .clear
        collectionView!.register(PageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        collectionView.isPagingEnabled = true
        
       setListOfPokemons()
    }
    
    
    func setListOfPokemons() {
        var allPokemons:[PokemonVM] = []
        httpClient.fetchPokemonsResource(offset: "0") { resource in
            DispatchQueue.main.async {
                self.spinner.startAnimating()
            }
            
            switch resource {
            case .success(let resourcedata):
                    var index = 1
                    resourcedata.forEach { (result) in
                        self.httpClient.fetchPokemons(url: result.url) { pokemonData in
                            switch pokemonData {
                            case .success(let pokemon):
                                allPokemons.append(PokemonVM(pokemon: pokemon))
                                //Display pokemons after loading list of pokemons
                                if index == resourcedata.count{
                                    self.getTopByExperience(listOfPokemons: allPokemons)
                                    DispatchQueue.main.async {
                                        self.spinner.stopAnimating()
                                        self.pageControl.numberOfPages = self.listOfTopPokemons.count
                                        self.collectionView.reloadData()
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
    
    
    func getTopByExperience(listOfPokemons:[PokemonVM]){
        //Filter pokemons based on experience level
        listOfTopPokemons = listOfPokemons.filter { (pokemon: PokemonVM) -> Bool in
            return pokemon.base_experience > topExperienceLevel
          }
    }
    
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        //Set pagecontrol according to number of top pokemons
        pageControl.currentPage = Int(x/view.frame.width)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfTopPokemons.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PageCell
        
        let pokemon = listOfTopPokemons[indexPath.item]
        //cell!.backgroundColor = .blue
        cell?.pokemonVM = pokemon
        
        return cell!
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailsVC = PokemonDetailViewController()
        let pokemon = listOfTopPokemons[indexPath.item]
        
        detailsVC.selectedPokemon = pokemon
        detailsVC.headerImage.image = pokemon.image
        
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: view.frame.height/2)
    }
    
    fileprivate func setupBottomControls(){
        spinner.center = view.center
        
        view.backgroundColor = .systemGroupedBackground
        view.addSubview(pageControl)
        view.addSubview(spinner)
        pageControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        pageControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pageControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
   
}
