//
//  CustomSubscriber.swift
//  PracticalWorkOnCombine
//
//  Created by Eduard on 05.02.2022.
//

import UIKit
import Combine

class TransmittedTextSubscriberClass: Subscriber {
    let transmittedTextLabel: UILabel
    
    init(transmittedTextLabel: UILabel){
        self.transmittedTextLabel = transmittedTextLabel
    }
  
  func receive(subscription: Subscription) {
      subscription.request(.unlimited)
  }
  
  func receive(_ input: String) -> Subscribers.Demand {
      self.transmittedTextLabel.isHidden = false
      self.transmittedTextLabel.text = input
    return .none
  }
  
  func receive(completion: Subscribers.Completion<Never>) {
  }
}
