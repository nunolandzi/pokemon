//
//  PageCell.swift
//  Pokesearch
//
//  Created by Nuno Silva on 30/12/2020.
//

import UIKit

class PageCell: UICollectionViewCell {
    
    var pokemon: Pokemon?{
        didSet{
            guard let unrappedPokemon = pokemon else {return}
            pokemonImageView.image = unrappedPokemon.image
            titleLabel.text = unrappedPokemon.name
        }
    }
    
    private let pokemonImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "pokemon"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let titleLabel:UILabel = {
        let label = UILabel()
        label.text = "Pokemon"
        //label.backgroundColor = .blue
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let topImageContainerView: UIView = {
        let topview = UIView()
        //topview.backgroundColor = .red
        topview.translatesAutoresizingMaskIntoConstraints = false
        return topview
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupViews() {
        //backgroundColor = .red
        addSubview(topImageContainerView)
        addSubview(titleLabel)
        
        topImageContainerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        topImageContainerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        topImageContainerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        topImageContainerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        topImageContainerView.addSubview(pokemonImageView)
        pokemonImageView.centerXAnchor.constraint(equalTo: topImageContainerView.centerXAnchor).isActive = true
        pokemonImageView.centerYAnchor.constraint(equalTo: topImageContainerView.centerYAnchor).isActive = true
        pokemonImageView.heightAnchor.constraint(equalTo: topImageContainerView.heightAnchor, multiplier: 2/3).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: topImageContainerView.bottomAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: frame.height/4).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
    }
}
