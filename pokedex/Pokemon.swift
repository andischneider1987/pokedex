//
//  Pokemon.swift
//  pokedex
//
//  Created by Andreas Schneider on 16.10.16.
//  Copyright © 2016 Andreas Schneider. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    
    private var _nextEvoText: String!
    private var _nextEvoName: String!
    private var _nextEvoId: String!
    private var _nextEvoLevel: String!
    private var _pokemonURL: String!
    
    
    private var _height: String!
    private var _weight: String!
    private var _attack: Int!
    private var _defense: Int!
    private var _type: String!
    
    
    var nextEvoText: String {
        if _nextEvoText == nil {
            _nextEvoText = ""
        }
        return _nextEvoText
    }
    
    var nextEvoName: String {
        if _nextEvoName == nil {
            _nextEvoName = ""
        }
        return _nextEvoName
    }
    
    var nextEvoId: String {
        if _nextEvoId == nil {
            _nextEvoId = ""
        }
        return _nextEvoId
    }
    
    var nextEvoLevel: String {
        if _nextEvoLevel == nil {
            _nextEvoLevel = ""
        }
        return _nextEvoLevel
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var defense: Int {
        if _defense == nil {
            _defense = 0
        }
        return _defense
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var attack: Int {
        if _attack == nil {
            _attack = 0
        }
        return _attack
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var name: String {
        return _name
    }
    var pokedexId: Int {
        return _pokedexId
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: @escaping DownloadComplete) {
        Alamofire.request(_pokemonURL).responseJSON { (response) in
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                if let height = dict["height"] as? String {
                    self._height = height
                }
                if let attack = dict["attack"] as? Int {
                    self._attack = attack
                }
                if let defense = dict["defense"] as? Int {
                    self._defense = defense
                }
                if let types = dict["types"] as? [Dictionary<String, AnyObject>] , types.count > 0 {
                    for index in 0..<types.count {
                        if let type = types[index]["name"] as? String {
                            if index==0 {
                                self._type = type.capitalized
                            } else {
                                self._type = self._type + "/ " + type.capitalized
                            }
                            
                        }
                    }
                    
                }
                if let descriptions = dict["descriptions"] as? [Dictionary<String, AnyObject>] , descriptions.count > 0 {
                    if let descreptionUrl = descriptions[0]["resource_uri"] as? String {
                        let newUrl = URL_BASE + descreptionUrl                        
                        Alamofire.request(newUrl).responseJSON(completionHandler: { (response) in
                            if let descriptionDict = response.result.value as? Dictionary<String, AnyObject> {
                                if let desc = descriptionDict["description"] as? String {
                                    let newDesc = desc.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    self._description = newDesc
                                    
                                }
                            }
                            completed()
                        })
                    }
                } else {
                    self._description = "NO DESC AVAILABLE AT THE MOMENT"
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] , evolutions.count > 0 {
                    if let nextEvo = evolutions[0]["to"] as? String {
                        if nextEvo.range(of: "mega") == nil {
                            self._nextEvoName = nextEvo
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon", with: "")
                                let nextEvoId = newStr.replacingOccurrences(of: "/", with: "")
                                
                                self._nextEvoId = nextEvoId
                                
                                if let lvlExist = evolutions[0]["level"] {
                                    if let lvl = lvlExist as? Int {
                                        self._nextEvoLevel = "\(lvl)"
                                    }
                                } else {
                                    self._nextEvoLevel = ""
                                }
                            }
                        }
                    }
                }
                
            }
            
        }
    }
    
}
