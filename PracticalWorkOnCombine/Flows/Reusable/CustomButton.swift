//
//  CustomButton.swift
//  PracticalWorkOnCombine
//
//  Created by Eduard on 09.02.2022.
//

import UIKit
import SnapKit

class CustomButton: UIView {
    
    var shadowColor: UIColor = .black
    var shadowOffset: CGSize = CGSize(width: 2, height: 5)
    var shadowOpacity: Float = 0.9
    var shadowRadius: CGFloat = 3
    var gradientLayer: CAGradientLayer?
    var duration: CFTimeInterval = 0.2
    var titleText = ""
    var subTitletext = ""

    override open class var layerClass: AnyClass {
         return CAGradientLayer.classForCoder()
      }
    
    override func awakeFromNib() {
        backgroundColor = .clear
        makeShadow(object:self, shadowOffset: shadowOffset, shadowRadius: shadowRadius)

        let titleLabel = UILabel()
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY).offset(-self.bounds.height/6)
          }
        titleLabel.textColor = .white
        titleLabel.text = titleText
        titleLabel.font = UIFont.systemFont(ofSize: self.bounds.height / 1.8, weight: .heavy)

        makeShadow(object: titleLabel, shadowOffset: CGSize(width: 0, height: -1), shadowRadius: 1)
        
        let subTitleLabel = UILabel()
        self.addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(titleLabel.snp.bottom).offset(-5)
          }
        subTitleLabel.textColor = .lightGray
        subTitleLabel.text = subTitletext
        subTitleLabel.font = UIFont.systemFont(ofSize: self.bounds.height/4, weight: .heavy)
        
        configureGesture()
    }
    
    private func makeShadow(object: UIView, shadowOffset: CGSize, shadowRadius: CGFloat){
        object.layer.shadowColor = shadowColor.cgColor
        object.layer.shadowOffset = shadowOffset
        object.layer.shadowOpacity = shadowOpacity
        object.layer.shadowRadius = shadowRadius
    }

    private func configureGesture(){
        gradientLayer = layer as? CAGradientLayer
        guard let gradientLayer = gradientLayer else {return}
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.black.cgColor]
        gradientLayer.opacity = 0.9
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        self.addGestureRecognizer(tapGesture)
        self.isUserInteractionEnabled = true
        
    }
    
    @objc func didTap() {
        
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

