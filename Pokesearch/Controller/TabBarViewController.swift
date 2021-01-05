//
//  TabBarViewController.swift
//  Pokesearch
//
//  Created by Nuno Silva on 30/12/2020.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //Set tabBar entries for search and top pokemons controllers
        let searchVC = UINavigationController(rootViewController: SearchPokemonViewController())
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let swipeVC = UINavigationController(rootViewController: SwipingCollectionViewController(collectionViewLayout: layout))
        
        searchVC.tabBarItem.title = "Search"
        swipeVC.tabBarItem.title = "Top"
        
        viewControllers = [swipeVC,searchVC]
    }

}
