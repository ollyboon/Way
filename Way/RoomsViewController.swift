//
//  TableViewController.swift
//  Way
//
//  Created by Olly Boon on 31/03/2017.
//  Copyright © 2017 Oliver Boon (i7263244). All rights reserved.
//

import UIKit
import Foundation


protocol RoomsViewControllerDelegate {
    
    func didSelect(_ room: Room)
    
}


class RoomsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    
    var rooms = RoomManager.shared.rooms
    let request = Request()
    var delegate: RoomsViewControllerDelegate?


    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    
        
        
        

        
        self.tableView.reloadData()
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        self.tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.0)
        return rooms.count

        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCellTableViewCell
        

        cell.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.0)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.alpha = 0
        
        UIView.animate(withDuration: 0.5, animations: {
            cell.alpha = 1
        })
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let room = RoomManager.shared.rooms[indexPath.row]
        delegate?.didSelect(room)
        dismiss(animated: true, completion: nil)
        //
        //tableView.deselectRow(at: indexPath, animated: true)
        //performSegue(withIdentifier: "mapSegue", sender: room)
        
    }
    

}
