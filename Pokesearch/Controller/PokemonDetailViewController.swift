//
//  PokemonDetailViewController.swift
//  Pokesearch
//
//  Created by Nuno Silva on 31/12/2020.
//

import UIKit


class PokemonDetailViewController: UIViewController {

    private let httpClient = HTTPClient()
    private var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .clear
        //table.contentInset = .init(top: 20, left: 16, bottom: 16, right: 16)
        //table.separatorColor = UIColor.lightGray.withAlphaComponent(0.4)
        table.translatesAutoresizingMaskIntoConstraints = false
        
        return table
    }()
    
    let headerImage: UIImageView = {
        let imageview = UIImageView(image: UIImage(named: "pokemon"))
        imageview.contentMode = .scaleAspectFit
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    private var favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.addTarget(self, action: #selector(handleFavoritePokemon(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let cellIdentifier = "elementosCell"
    var selectedPokemon:[PokemonData]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.alwaysBounceHorizontal = false
        //tableView.bounces = false
        //tableView.alwaysBounceVertical = false
        setViews()
        // Do any additional setup after loading the view.
    }
    
    @objc func handleFavoritePokemon(sender:UIButton)  {
        
        if sender.tag == 0{
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            sender.tag = 1
            
            //Post info
            httpClient.postFavoritePokemonJSON(pokemondata: selectedPokemon!)
        }else{
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            sender.tag = 0
        }
        
    
    }
    

    func setViews(){
        view.backgroundColor = .systemGroupedBackground
        //navigationController?.navigationBar.alpha = 0
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }

}

extension PokemonDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedPokemon!.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //Retorna apenas o numero de codigos postais filtrados
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: cellIdentifier)
        cell.backgroundColor = .clear
        if let pokemonData = selectedPokemon {
            let row = indexPath.row
            cell.textLabel!.text = pokemonData[row].title
            cell.detailTextLabel!.text = pokemonData[row].value
          }
          
        return cell
    }
}


extension PokemonDetailViewController: UITableViewDelegate{
    
    func imageFromColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()

        context!.setFillColor(color.cgColor)
        context!.fill(rect)

        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        UIGraphicsBeginImageContext(size)
        image?.draw(in: rect)
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image!
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width/2))
        
        headerView.addSubview(headerImage)
        headerView.addSubview(favoriteButton)
        
        headerImage.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 60).isActive = true
        headerImage.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0).isActive = true
        headerImage.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 0).isActive = true
        headerImage.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: 0).isActive = true
        
        favoriteButton.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 30).isActive = true
        favoriteButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        favoriteButton.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -40).isActive = true
        
        
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return view.frame.width/2
    }
}
