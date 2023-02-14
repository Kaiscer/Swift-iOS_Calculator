//
//  UIButtonExtension.swift
//  iOS-Calculator
//
//  Created by Kaiscer Vasquez on 13/2/23.
//

import UIKit

private let orange = UIColor(red: 254/255, green: 148/255, blue: 0/255, alpha: 1)

extension UIButton{
    // Esta funsion nos permite redondear cualquier button
    func round(){
        layer.cornerRadius = bounds.height / 2
        clipsToBounds = true
    }
    
    // Brillar
    func shine(){
        UIView.animate(withDuration: 0.1, animations: {
            self.alpha = 0.5
        }) {(completio)in
            UIView.animate(withDuration: 0.1, animations:{
                self.alpha = 1
            })
        }
    }
    
    // Apariencia boton de seleccion
    func selectOperation(_ selected: Bool){
        backgroundColor = selected ? .white : orange
        setTitleColor(selected ?  orange : .white, for: .normal)
    }
    
}
