//
//  CustomGradientView.swift
//  Way
//
//  Created by Olly Boon on 02/04/2017.
//  Copyright © 2017 Oliver Boon (i7263244). All rights reserved.
//

import UIKit

@IBDesignable class CustomGradientView: UIView {

    @IBInspectable var FirstColor: UIColor = UIColor.clear {
        didSet{
            updateView()
        }
    }
    
    @IBInspectable var SecondColor: UIColor = UIColor.clear {
        didSet{
            updateView()
        }
    }
    
   // @IBInspectable var startPoint: CGPoint {

   // }
    
    override class var layerClass: AnyClass {
        get{
            return CAGradientLayer.self
        }
    }
    
    func updateView() {
        let layer = self.layer as! CAGradientLayer
        layer.colors = [FirstColor.cgColor , SecondColor.cgColor]
        
    }

}
