//
//  ViewController.swift
//  PracticalWorkOnCombine
//
//  Created by Eduard on 02.02.2022.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        practicalWorkNumber_1()
    }
    
    var subscribers = Set<AnyCancellable>()

    
    private func practicalWorkNumber_1(){
        let publisher1 = [2,3,4,5,8,10,4,1,7].publisher
        let subscriber1 = publisher1.sink{receiveValue in
            if (3...6).contains(receiveValue) {
                print("Получено следующее число в диапазоне от 3 до 6: ", receiveValue)
            }
        }
        subscriber1.cancel()
        
        let notificationName = Notification.Name("Simple1")
        let publisher2 = NotificationCenter.default.publisher(for: notificationName, object: nil)
        let subscriber2 = publisher2.sink{receiveValue in
            guard let message = receiveValue.object else {return}
            print("\nЧерез NotificationCenter получено сообщение: ", message)
        }
        NotificationCenter.default.post(name: notificationName, object: "Hello world!")
        subscriber2.cancel()
    }
        
}
