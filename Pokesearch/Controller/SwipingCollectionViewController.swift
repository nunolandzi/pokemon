//
//  SwipingCollectionViewController.swift
//  Pokesearch
//
//  Created by Nuno Silva on 30/12/2020.
//

import UIKit

class SwipingCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private let reuseIdentifier = "Cell"
    private let httpClient = HTTPClient()
    private var listOfTopPokemons:[Pokemon] = []
    private let topExperienceLevel:Int = 227
    
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
        httpClient.getPokemonsResource { (data) in
            if let _ = data{
                self.httpClient.getListOfPokemonsJSON { (pokedata) in
                    if let _ = pokedata{
                        let list = self.httpClient.getPokemons()
                        self.getTopByExperience(listOfPokemons: list)
                        //Reload data to show pokemons after getting them from server
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                            self.pageControl.numberOfPages = self.listOfTopPokemons.count
                        }
                    }
                }
            }
        }
       /* httpClient.getTopPokemonsJSON { (data) in
            if let _ = data{
                self.listOfTopPokemons = self.httpClient.getTopPokemons()
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.pageControl.numberOfPages = self.listOfTopPokemons.count
                }
            }
        }*/
    }
    
    
    fileprivate func getTopByExperience(listOfPokemons:[Pokemon]){
        listOfTopPokemons = listOfPokemons.filter { (pokemon: Pokemon) -> Bool in
            return pokemon.base_experience > topExperienceLevel
          }
    }
    
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        
        pageControl.currentPage = Int(x/view.frame.width)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfTopPokemons.count
        //return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PageCell
        
        let pokemon = listOfTopPokemons[indexPath.item]
        //cell!.backgroundColor = .blue
        cell?.pokemon = pokemon
        
        return cell!
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailsVC = PokemonDetailViewController()
        let pokemon = listOfTopPokemons[indexPath.item]
        detailsVC.navigationItem.title = pokemon.name
        detailsVC.selectedPokemon = pokemon.tableRepresentation
        detailsVC.headerImage.image = pokemon.image
        
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: view.frame.height/2)
    }
    
    fileprivate func setupBottomControls(){
        view.backgroundColor = .systemGroupedBackground
        view.addSubview(pageControl)
        pageControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        pageControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pageControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
   
}
