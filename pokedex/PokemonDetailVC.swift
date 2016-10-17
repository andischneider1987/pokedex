//
//  PokemonDetailVC.swift
//  pokedex
//
//  Created by Andreas Schneider on 16.10.16.
//  Copyright © 2016 Andreas Schneider. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    var pokemon: Pokemon!
    
    
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenceLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokedexLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var backAttackLbl: UILabel!
    @IBOutlet weak var currEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var evoLbl: UILabel!
    @IBOutlet weak var backImage: UIImageView!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLbl.text = pokemon.name
        mainImg.image = UIImage(named: "\(pokemon.pokedexId)")
        currEvoImg.image = UIImage(named: "\(pokemon.pokedexId)")
        pokedexLbl.text = "\(pokemon.pokedexId)"
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(imageTapped))
        backImage.isUserInteractionEnabled = true
        backImage.addGestureRecognizer(tapGestureRecognizer)
        
        pokemon.downloadPokemonDetails {
            // Whatever we write will only be called after the network call is complete!
            print("Did arrive here?")
            self.updateUI()
        }
    }
    
    func updateUI() {
        
        backAttackLbl.text = String(pokemon.attack)
        heightLbl.text = pokemon.height
        weightLbl.text = pokemon.weight
        typeLbl.text = pokemon.type
        defenceLbl.text = String(pokemon.defense)
        descLbl.text = pokemon.description
        if pokemon.nextEvoId == "" {
            evoLbl.text = ""
            nextEvoImg.isHidden = true
        } else {
            nextEvoImg.isHidden = false
            nextEvoImg.image = UIImage(named: pokemon.nextEvoId)
            evoLbl.text = "Next Evolution: \(pokemon.nextEvoName) LVL: \(pokemon.nextEvoLevel)"
        }
        
        
        
    }
    
    func imageTapped(img: AnyObject)
    {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backBtnPressed(_ sender: UIImage) {
        
    }

}
