//
//  ViewController.swift
//  DiceGame2
//
//  Created by 임재현 on 2022/09/30.
//

import UIKit

class ViewController: UIViewController {
    
    var no = 0
    
    @IBOutlet weak var firstIjmageView: UIImageView!
    
    
    @IBOutlet weak var secondImageView: UIImageView!
    
    var diceArray:[UIImage] = [#imageLiteral(resourceName: "black1"), #imageLiteral(resourceName: "black2") , #imageLiteral(resourceName: "black3"), #imageLiteral(resourceName: "black4"), #imageLiteral(resourceName: "black5"), #imageLiteral(resourceName: "black6")]
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func rollButtonTapped(_ sender: UIButton) {
        
        firstIjmageView.image = diceArray.randomElement()
        
        secondImageView.image = diceArray.randomElement()
        
    }
    
}

