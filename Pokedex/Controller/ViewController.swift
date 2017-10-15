//
//  ViewController.swift
//  Pokedex
//
//  Created by Jon on 10/11/17.
//  Copyright © 2017 Jon. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var collection: UICollectionView!
    
    var pokemons = [Pokenmon]()
    var filteredPokemons = [Pokenmon]()
    var insearchmode = false
    var musicplayer : AVAudioPlayer!
    @IBOutlet weak var musicBttn: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        let charmander = Pokenmon(name: "Charmander", pokedexId: 4)
        collection.delegate = self
        collection.dataSource = self
        searchBar.delegate = self
        parsePokemonCSV()
        searchBar.returnKeyType = UIReturnKeyType.done
        initAudio()
    }
    
    func initAudio(){
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        
        do{
            musicplayer = try AVAudioPlayer(contentsOf: URL(string: path)! )
            musicplayer.prepareToPlay()
            musicplayer.numberOfLoops = -1
            musicplayer.play()
        }catch let err as NSError{
            print(err.debugDescription)
        }
    }
    
    func parsePokemonCSV(){
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        do{
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            
            for row in rows{
                let pokeID = Int(row["id"]!)!
                let name = row["identifier"]!
                
                let pokemon = Pokenmon(name: name, pokedexId: pokeID)
                pokemons.append(pokemon)
            }
        }catch let err as NSError{
            print(err.debugDescription)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell{
            
            let pokemon: Pokenmon!
            if insearchmode {
                pokemon = filteredPokemons[indexPath.row]
                cell.configureCell(pokemon: pokemon)
                
            }else{
                let pokemon = pokemons[indexPath.row]
                cell.configureCell(pokemon: pokemon)
            }
            return cell
        }else{
            return UICollectionViewCell()
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if insearchmode{
            return filteredPokemons.count
        }
        return pokemons.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var poke: Pokenmon!
        if insearchmode{
            poke = filteredPokemons[indexPath.row]
        }else{
            poke = pokemons[indexPath.row]
        }
        performSegue(withIdentifier: "DetailViewController", sender: poke)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 75, height: 75)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func musicBtnAct(_ sender: UIButton) {
        if musicplayer.isPlaying {
            musicplayer.pause()
            sender.alpha = 0.2
        }else{
            musicplayer.play()
            sender.alpha = 1.0
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == ""{
            insearchmode = false
            collection.reloadData()
            view.endEditing(true)
        }else{
            insearchmode = true
            let lower = searchBar.text!.lowercased()
            filteredPokemons = pokemons.filter({$0.name.range(of: lower) != nil })
            collection.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailViewController" {
            if let detailsVC = segue.destination as? DetailViewController{
                if let poke = sender as? Pokenmon{
                    detailsVC.poke = poke
                }
            }
        }
    }
}

