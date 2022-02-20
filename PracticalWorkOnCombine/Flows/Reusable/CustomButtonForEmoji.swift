//
//  CustomButtonForEmoji.swift
//  PracticalWorkOnCombine
//
//  Created by Eduard on 15.02.2022.
//

import UIKit
import SnapKit

class CustomButtonForEmoji: UIView {
    
    var shadowColor: UIColor = .black
    var shadowOffset: CGSize = CGSize(width: 2, height: 5)
    var shadowOpacity: Float = 0.9
    var shadowRadius: CGFloat = 3
    var duration: CFTimeInterval = 0.2
    var titleText = ""
    var buttonColor: UIColor = .red
    var delegate: CasinoEmojiVC?
    var isItStartButton = true
    
    override func awakeFromNib() {
        backgroundColor = buttonColor
        makeShadow(object:self, shadowOffset: shadowOffset, shadowRadius: shadowRadius)

        let titleLabel = UILabel()
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
          }
        titleLabel.textColor = .white
        titleLabel.text = titleText
        titleLabel.font = UIFont.systemFont(ofSize: self.bounds.height / 3, weight: .heavy)

        makeShadow(object: titleLabel, shadowOffset: CGSize(width: 0, height: -1), shadowRadius: 1)
        
        configureGesture()
    }
    
    private func makeShadow(object: UIView, shadowOffset: CGSize, shadowRadius: CGFloat){
        object.layer.shadowColor = shadowColor.cgColor
        object.layer.shadowOffset = shadowOffset
        object.layer.shadowOpacity = shadowOpacity
        object.layer.shadowRadius = shadowRadius
    }

    private func configureGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        self.addGestureRecognizer(tapGesture)
        self.isUserInteractionEnabled = true
        
    }
    
    @objc func didTap() {
        
        if isItStartButton {
            delegate?.startAnimationFunc()
        }
        else {
            delegate?.stopAnimationFunc()
        }
        
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        let animationX = CABasicAnimation()
        animationX.keyPath = "shadowOffset"
        animationX.fromValue = self.layer.shadowOffset
        animationX.toValue = CGSize(width: 0, height: 0)
        animationX.duration = self.duration
        animationX.fillMode = .forwards
        animationX.isRemovedOnCompletion = false
        self.layer.add(animationX, forKey: animationX.keyPath)
        
        animationX.keyPath = "shadowRadius"
        animationX.fromValue = self.layer.shadowRadius
        animationX.toValue = 0
        animationX.duration = self.duration
        self.layer.add(animationX, forKey: animationX.keyPath)
        
    
        DispatchQueue.main.asyncAfter(deadline: .now()+self.duration){
            animationX.keyPath = "shadowOffset"
            animationX.fromValue = CGSize(width: 0, height: 0)
            animationX.toValue = CGSize(width: 2, height: 5)
            animationX.duration = self.duration
            self.layer.add(animationX, forKey: animationX.keyPath)

            animationX.keyPath = "shadowRadius"
            animationX.fromValue = 0
            animationX.toValue = 3
            animationX.duration = self.duration
            self.layer.add(animationX, forKey: animationX.keyPath)
        }
        
        UIView.animate(withDuration: self.duration,
                       animations: {
                            self.transform = CGAffineTransform(translationX: 2, y: 2)
                       },
                       completion: {_ in
                            UIView.animate(withDuration: self.duration,
                                           animations: {
                                           self.transform = .identity
                                           },
                                           completion: nil)
                        })
    }
}
