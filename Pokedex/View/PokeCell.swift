//
//  PokeCell.swift
//  Pokedex
//
//  Created by Jon on 10/12/17.
//  Copyright © 2017 Jon. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    @IBOutlet weak var thumbIma: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5.0
    }
    var pokemon: Pokenmon!
    func configureCell(pokemon: Pokenmon) {
        self.pokemon = pokemon
        self.thumbIma.image = UIImage(named: "\(self.pokemon.pokedexId)")
        self.nameLabel.text = self.pokemon.name.capitalized
    }
}
