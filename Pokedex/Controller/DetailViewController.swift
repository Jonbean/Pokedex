//
//  DetailViewController.swift
//  Pokedex
//
//  Created by Jon on 10/14/17.
//  Copyright © 2017 Jon. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var currentEvlImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var TypeLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var PokedexIDLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var baseAttLabel: UILabel!
    @IBOutlet weak var NextEvlLabel: UILabel!
    @IBOutlet weak var nextEvlImage: UIImageView!
    
    @IBOutlet weak var beforeEvlImage: UIImageView!
    var poke : Pokenmon!
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = poke.name.capitalized
        PokedexIDLabel.text = "\(poke.pokedexId)"
        let image = UIImage(named: "\(poke.pokedexId)")
        currentEvlImage.image = image
        beforeEvlImage.image = image
        
        // Do any additional setup after loading the view.
        poke.dowloadPokemonDetail(){
            //
            self.updateUI()
        }
        
    }
    func updateUI() {
        // TODO: update UI after download
        defenseLabel.text = poke.defense
        heightLabel.text = poke.height
        weightLabel.text = poke.weight
        baseAttLabel.text = poke.attack
        TypeLabel.text = poke.type
        descriptionLabel.text = poke.description
        NextEvlLabel.text = "Next Evolution: \(poke.nextEvlPokeName) \(poke.nextEvlLvl)"
        if poke.nextEvlPokeId != ""{
            nextEvlImage.image = UIImage(named: poke.nextEvlPokeId)
        }else{
            nextEvlImage.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
