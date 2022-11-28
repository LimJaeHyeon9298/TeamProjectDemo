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
        
        //모달의 높이를 중간으로 설정
        if #available(iOS 15.0, *) {
            if let sheetPresentationController = sheetPresentationController {
                sheetPresentationController.detents = [.medium()]
            }
        } else {
        }
//        baseView.layer.cornerRadius = 15
    }
    
    @IBAction func selectButtonTapped(_ sender: UIButton) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        
        print(formatter.string(from: datePicker.date))
        self.dismiss(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.dismiss(animated: true)
    }
}
