//
//  TestViewController.swift
//  PracticalWorkOnCombine
//
//  Created by Eduard on 11.02.2022.
//

import UIKit
import SnapKit

class TestViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let customButton = CustomButton()
        customButton.frame = CGRect(x: 50, y: 300, width: 200, height: 100)
        customButton.titleText = "2"
        customButton.subTitletext = "ABC"
        customButton.awakeFromNib()
        self.view.addSubview(customButton)
        
    }
}
