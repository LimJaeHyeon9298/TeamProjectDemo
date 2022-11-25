//
//  CalenderViewController.swift
//  weatherProject
//
//  Created by 표현수 on 2022/11/23.
//

import UIKit

class CalenderViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func selectButtonTapped(_ sender: UIButton) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        
        print(formatter.string(from: datePicker.date))
        self.dismiss(animated: true)
    }
}
