//
//  CustomUISearchBar.swift
//  Way
//
//  Created by Olly Boon on 02/04/2017.
//  Copyright © 2017 Oliver Boon (i7263244). All rights reserved.
//

import UIKit

@IBDesignable class CustomUISearchBar: UISearchBar {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        
        didSet {
            layer.cornerRadius = cornerRadius
        }
        
    }

}
