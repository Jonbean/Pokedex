//
//  Pokemon.swift
//  Pokedex
//
//  Created by Jon on 10/11/17.
//  Copyright © 2017 Jon. All rights reserved.
//

import Foundation
import Alamofire

class Pokenmon{
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _height: String!
    private var _type: String!
    private var _attack: String!
    private var _weight: String!
    private var _defense: String!
    
    private var _nextEvlTxt: String!
    private var _nextEvlLvl: String!
    private var _nextEvlPokeId: String!
    private var _nextEvlPokeName: String!
    
    private var _pokemonURL: String!
    
    var nextEvlPokeName : String{
        if _nextEvlPokeName == nil{
            _nextEvlPokeName = ""
        }
        return _nextEvlPokeName
    }
    
    var nextEvlPokeId : String{
        if _nextEvlPokeId == nil{
            _nextEvlPokeId = ""
        }
        return _nextEvlPokeId
    }
    
    var nextEvlLvl: String{
        if _nextEvlLvl == nil{
            _nextEvlLvl = ""
        }
        return _nextEvlLvl
    }
    
    var description: String{
        if _description == nil{
            _description = ""
            
        }
        return _description
    }
    var height: String{
        if _height == nil{
            _height = ""
        }
        return _height
    }
    
    var type: String{
        if _type == nil{
            _type = ""
        }
        return _type
    }
    
    var attack: String{
        if _attack == nil{
            _attack = ""
        }
        return _attack
    }
    
    var weight: String{
        if _weight == nil{
            _weight = ""
        }
        return _weight
    }
    
    var defense: String{
        if _defense == nil{
            _defense = ""
        }
        return _defense
    }
    
    var nextEvlTxt: String{
        if _nextEvlTxt == nil{
            _nextEvlTxt = ""
        }
        return _nextEvlTxt
    }
    
    var name: String{
        return _name
    }
    
    var pokedexId: Int{
        return _pokedexId
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        self._pokemonURL = "\(URL_PREFIX)\(URL_pokemon)\(Int(self._pokedexId))"
    }
    
    func dowloadPokemonDetail(completed: @escaping completed) {
        Alamofire.request(self._pokemonURL).responseJSON{response in
            if let dict = response.result.value as? Dictionary<String, AnyObject>{
                if let weight = dict["weight"] as? String{
                    self._weight = weight
                }
                if let height = dict["height"] as? String{
                    self._height = height
                }
                if let attack = dict["attack"] as? Int{
                    self._attack = "\(attack)"
                }
                if let defense = dict["defense"] as? Int{
                    self._defense = "\(defense)"
                }
                
                if let types = dict["types"] as? [Dictionary<String, String>], types.count > 0 {
                    if let name = types[0]["name"]{
                        self._type = name.capitalized
                    }
                    if types.count > 1{
                        for x in 1..<types.count {
                            if let name = types[x]["name"]{
                                self._type! += "/\(name.capitalized)"
                            }
                        }
                    }
                }else{
                    self._type = ""
                }
                
                if let descriptions = dict["descriptions"] as? [Dictionary<String, String>], descriptions.count > 0{
                    if let description_URI = descriptions[0]["resource_uri"]{
                        Alamofire.request("\(URL_PREFIX)\(description_URI)").responseJSON(completionHandler: {(response) in
                            if let description_dict = response.result.value as? Dictionary<String, AnyObject>{
                                if let description_txt = description_dict["description"] as? String{
                                    self._description = description_txt
                                }
                            }
                            completed()
                        })
                    }
                } else {
                    self._description = ""
                }
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>], evolutions.count > 0{
                    if let lvl = evolutions[0]["level"] as? Int{
                        self._nextEvlLvl = "\(lvl)"
                    }else{
                        self._nextEvlLvl = ""
                    }
                    if let nextName = evolutions[0]["to"] as? String{
                        self._nextEvlPokeName = nextName
                    }else{
                        self._nextEvlPokeName = ""
                    }
                    if let nextID = evolutions[0]["resource_uri"] as? String{
                        let uriString = nextID.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                        self._nextEvlPokeId = uriString.replacingOccurrences(of: "/", with: "")
                    }else{
                        self._nextEvlPokeId = ""
                    }
                }else{
                    self._nextEvlLvl = ""
                    self._nextEvlPokeName = "no more"
                    self._nextEvlPokeId = ""
                }
                
                
            }
            completed()
        }
    }
}
