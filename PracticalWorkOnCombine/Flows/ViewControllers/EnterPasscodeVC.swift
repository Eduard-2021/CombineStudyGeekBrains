//
//  EnterPasscodeVC.swift
//  PracticalWorkOnCombine
//
//  Created by Eduard on 07.02.2022.
//

import UIKit

class EnterPasscodeVC: UIViewController {
    
    let distance: CGFloat = 1
    var shadowColor: UIColor = .black
    var shadowOffset: CGSize = CGSize(width: 2, height: 5)
    var shadowOpacity: Float = 0.9
    var shadowRadius: CGFloat = 3
    
    @IBOutlet weak var enterPasscodeLabel: UILabel!
    @IBOutlet weak var circleInCenterUIView: UIView!
    
    @IBOutlet weak var frameForButtonsUIView: UIView!
    
    @IBOutlet weak var testButton: UIButton!
    @IBAction func testButtonPressed(_ sender: Any) {
        
        let yyy = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeShadow(object: enterPasscodeLabel, shadowOffset: CGSize(width: 2, height: 5), shadowRadius: 3)
        makeShadow(object: circleInCenterUIView, shadowOffset: CGSize(width: 2, height: 5), shadowRadius: 3)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        makeButtons()
    }
    
    private func makeButtons(){
        let widthButton = frameForButtonsUIView.frame.width/3 - distance
        let heightButton = frameForButtonsUIView.frame.height/4 - distance
        var offsetX: Double = 0
        var offsetY: Double = 0
        let alphabet = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O",]
        
        for index in 1...12 {
            let customButton = CustomButtonForAuth()

            customButton.frame = CGRect(x: offsetX, y: offsetY, width: widthButton, height: heightButton)
            switch index {
            case 1:
                customButton.titleText = "\(index)"
            case 2...6:
                customButton.titleText = "\(index)"
                customButton.subTitletext = "\(alphabet[(index-2)*3])\(alphabet[(index-2)*3+1])\(alphabet[(index-2)*3+2])"
            case 7:
                customButton.titleText = "\(index)"
                customButton.subTitletext = "PQRS"
            case 8:
                customButton.titleText = "\(index)"
                customButton.subTitletext = "TUV"
            case 9:
                customButton.titleText = "\(index)"
                customButton.subTitletext = "WXYZ"
            case 10:
                customButton.subTitletext = "Cancel"
            case 11:
                customButton.titleText = "0"
            default:
                customButton.subTitletext = "Ok"
            }
            
            if index % 3 == 0 {
                offsetX = 0
                offsetY += (heightButton + distance)
            } else {
                offsetX += (widthButton + distance)
            }

            customButton.awakeFromNib()
            frameForButtonsUIView.addSubview(customButton)
        }
    }
    
    private func makeShadow(object: UIView, shadowOffset: CGSize, shadowRadius: CGFloat){
        object.layer.shadowColor = shadowColor.cgColor
        object.layer.shadowOffset = shadowOffset
        object.layer.shadowOpacity = shadowOpacity
        object.layer.shadowRadius = shadowRadius
    }

}

