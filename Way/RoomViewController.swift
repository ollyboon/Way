//
//  RoomViewController.swift
//  Way
//
//  Created by Olly Boon on 04/04/2017.
//  Copyright © 2017 Oliver Boon (i7263244). All rights reserved.
//

import UIKit

protocol RoomViewControllerDelegate {
    
    func didSelect(_ room: Room)
    
}

class RoomViewController: UITableViewController,  UISearchBarDelegate, UISearchResultsUpdating  {
    
    @IBOutlet var tblSearchResults: UITableView!
    
    var rooms = RoomManager.shared.rooms
    let request = Request()
    var delegate: RoomViewControllerDelegate?
    var searchController: UISearchController!
    var filteredArray = [String]()
    var shouldShowSearchResults = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configureSearchController()
        self.tableView.reloadData()

        
    }
    
    func configureSearchController() {
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self as UISearchResultsUpdating
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        
        tblSearchResults.tableHeaderView = searchController.searchBar
        
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        tblSearchResults.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        tblSearchResults.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            tblSearchResults.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {


    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        self.tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.0)
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.view.frame
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.colors = [UIColor(red: 255/255.5, green: 0/255.5, blue: 128/255.5, alpha: 1.0).cgColor, UIColor(red: 255/255.5, green: 156/255.5, blue: 0/255.5, alpha: 1.0).cgColor]
        
        let backgroundView = UIView(frame: tableView.bounds)
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        tableView.backgroundView = backgroundView
        
        return rooms.count
        
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        
        cell.roomNumber.text = rooms[indexPath.row].roomNumber
        cell.roomName.text = rooms[indexPath.row].roomName
        cell.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.0)
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        cell.alpha = 0
        
        
        UIView.animate(withDuration: 0.5, animations: {
            cell.alpha = 1
        })
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let room = RoomManager.shared.rooms[indexPath.row]
        delegate?.didSelect(room)
        dismiss(animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }



}
