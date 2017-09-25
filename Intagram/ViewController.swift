//
//  ViewController.swift
//  Intagram
//
//  Created by Jorge Casariego on 22/9/17.
//  Copyright © 2017 Jorge Casariego. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let plusButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(plusButton)
        
        plusButton.heightAnchor.constraint(equalToConstant: 140).isActive = true
        plusButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        plusButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        plusButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
    }
}

