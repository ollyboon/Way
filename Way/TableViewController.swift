//
//  TableViewController.swift
//  Way
//
//  Created by Olly Boon on 31/03/2017.
//  Copyright © 2017 Oliver Boon (i7263244). All rights reserved.
//

import UIKit
import Foundation


class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{

    
    var rooms = RoomManager.shared.rooms
    let request = Request()
    let gradientLayer = CAGradientLayer()



    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "mapSegue" {
            
            //guard let cell = sender as? CustomCellTableViewCell  else { return }
            //guard let room = cell.room else { return }
            
            if let destination = segue.destination as? ViewController {
                destination.room = sender as! Room
                
                
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        let searchBar = self.searchBar
        searchBar?.delegate = self
        
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            
            filterTableView(text: searchText)
            
        }
        
        func filterTableView(text: String) {
            
            rooms = rooms.filter({ (rooms) -> Bool in
                
                return rooms.roomName.lowercased().contains(text.lowercased())
                
            })
            self.tableView.reloadData()
            
        }
        
            

        
        

        
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        self.tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.0)
        return rooms.count

        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCellTableViewCell
        
        cell.tableLabel.text = rooms[indexPath.row].roomNumber
        cell.tableLabel2.text = rooms[indexPath.row].roomName
        cell.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.0)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.alpha = 0
        
        UIView.animate(withDuration: 0.8, animations: {
            cell.alpha = 1
        })
    }
    

}
