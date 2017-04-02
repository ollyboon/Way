//
//  CustomSegue.swift
//  Way
//
//  Created by Olly Boon on 02/04/2017.
//  Copyright © 2017 Oliver Boon (i7263244). All rights reserved.
//

import UIKit

class CustomSegue: UIStoryboardSegue {
    
    override func perform() {
        
    }
    
    func scale () {
        let toViewController = self.destination
        let fromViewController = self.source
        let containerView = fromViewController.view.superview
    }

}
