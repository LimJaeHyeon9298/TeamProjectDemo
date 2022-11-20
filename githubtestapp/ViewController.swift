//
//  ViewController.swift
//  githubtestapp
//
//  Created by 임재현 on 2022/11/20.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
        
        configeUI()
        
        
    }
    
    func configeUI(){
        
        imageView.image = #imageLiteral(resourceName: "black1")
    }
    
    
    
}

