//
//  CustomUISearchBar.swift
//  Way
//
//  Created by Olly Boon on 02/04/2017.
//  Copyright © 2017 Oliver Boon (i7263244). All rights reserved.
//

import UIKit

class CustomUISearchBar: UISearchBar {
    

    var preferredFont: UIFont!
    
    var preferredTextColor: UIColor!

    init(frame: CGRect, font: UIFont, textColor: UIColor) {
        super.init(frame: frame)
        
        self.frame = frame
        preferredFont = font
        preferredTextColor = textColor
        searchBarStyle = UISearchBarStyle.prominent
        isTranslucent = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func indexOfSearchFieldInSubviews() -> Int! {
        var index: Int!
        let searchBarView = subviews[0] as UIView!
        
        for i in 0 ..< (searchBarView?.subviews.count)! {
            if (searchBarView?.subviews[i].isKind(of: UITextField.self))! {
                index = i
                break
            }
        }
        
        return index
    }
    
     func drawRect(rect: CGRect) {
        // Find the index of the search field in the search bar subviews.
        if let index = indexOfSearchFieldInSubviews() {
            // Access the search field
            let searchField: UITextField = (subviews[0] ).subviews[index] as! UITextField
            
            // Set its frame.
            searchField.frame = CGRect(x: 5, y: 5, width: 300, height: 50)
            
            // Set the font and text color of the search field.
            searchField.font = preferredFont
            searchField.textColor = preferredTextColor
            
            // Set the background color of the search field.
            searchField.backgroundColor = barTintColor
        }
        
        super.draw(rect)
    }
    

    

}
