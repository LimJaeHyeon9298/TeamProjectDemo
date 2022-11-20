//
//  ViewController.swift
//  DiceGame2
//
//  Created by 임재현 on 2022/09/30.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var firstview: UIView!
    @IBOutlet weak var tempLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        //view를 클릭 가능하도록 설정
        self.firstview.isUserInteractionEnabled = true
        //제쳐스 추가
        self.firstview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.firstViewTapped)))
    }
    
    func setupUI() {
        firstview.backgroundColor = .gray
        firstview.layer.cornerRadius = 8
    }
    
    @objc func firstViewTapped(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "showFirstView", sender: nil)
    }
    
}

