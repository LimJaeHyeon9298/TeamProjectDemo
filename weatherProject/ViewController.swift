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
    @IBOutlet weak var tempLYView: UIView!
    @IBOutlet weak var calenderView: UIView!
    @IBOutlet weak var otherOptionView: UIView!
    @IBOutlet weak var regionView: UIView!
    
    
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
        firstview.layer.cornerRadius = 15
        tempLYView.layer.cornerRadius = 15
        calenderView.layer.cornerRadius = 15
        otherOptionView.layer.cornerRadius = 15
        regionView.layer.cornerRadius = 15
    }
    
    @objc func firstViewTapped(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "showFirstView", sender: nil)
    }
    
}

