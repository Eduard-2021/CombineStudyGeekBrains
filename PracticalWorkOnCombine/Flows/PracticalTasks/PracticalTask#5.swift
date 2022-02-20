//
//  PracticalTask#5.swift
//  PracticalWorkOnCombine
//
//  Created by Eduard on 15.02.2022.
//

import UIKit
import SwiftUI
import Combine
import SnapKit

class CasinoEmojiVC: UIViewController {

    var durationFirstPublisher: CFTimeInterval = 0.2
    var durationSecondPublisher: CFTimeInterval = 0.4
    var durationThirdPublisher: CFTimeInterval = 0.6
    var firstColumnOfEmojis=[UILabel]()
    var secondColumnOfEmojis=[UILabel]()
    var thirdColumnOfEmojis=[UILabel]()
    var subscriptions: Set<AnyCancellable> = []
    var isGameStart = false
    
    @IBOutlet weak var groundviewForEmojiUIView: UIView!
    @IBOutlet weak var topLineView: UIImageView!
    @IBOutlet weak var bottonLineView: UIImageView!
    
    @IBOutlet weak var startButton: CustomButtonForEmoji!
    @IBOutlet weak var stopButton: CustomButtonForEmoji!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        defaultConfigure()
    }
    
    func defaultConfigure(){
        
        let widthColumn = groundviewForEmojiUIView.frame.width/3
        let heightOneEmoji = groundviewForEmojiUIView.frame.height/5
        
        for indexColumn in 0 ... 2 {
            for indexRow in 0...3 {
                let xPosition = CGFloat(indexColumn) * widthColumn
                let oneEmoji = UILabel(frame: CGRect(x: xPosition, y: heightOneEmoji*CGFloat(indexRow), width: widthColumn, height: heightOneEmoji))
                oneEmoji.textAlignment = .center
                oneEmoji.font = UIFont.boldSystemFont(ofSize: 50)
                let randomEmoji = Constants.shared.emojiRangeForCasino[Int.random(in: 0...14)]
                oneEmoji.text = String(UnicodeScalar(randomEmoji)!)
                groundviewForEmojiUIView.insertSubview(oneEmoji, at: 0)
                switch indexColumn {
                    case 0:
                    firstColumnOfEmojis.append(oneEmoji)
                    oneEmoji.backgroundColor = .green
                    case 1:
                    secondColumnOfEmojis.append(oneEmoji)
                    oneEmoji.backgroundColor = .brown
                    case 2:
                    thirdColumnOfEmojis.append(oneEmoji)
                    oneEmoji.backgroundColor = .white
                default:
                    break
                }
            }
        }
        
        topLineView.image = UIImage(named: "emojiBackground2")
        bottonLineView.image = UIImage(named: "emojiBackground2")
        
        startButton.titleText = "Start"
        startButton.buttonColor = .blue
        stopButton.titleText = "Stop"
        startButton.awakeFromNib()
        stopButton.awakeFromNib()
        
        startButton.delegate = self
        stopButton.delegate = self
        stopButton.isItStartButton = false
    }
    
    
    func startAnimationFunc(){
        
        guard !isGameStart else {return}
        isGameStart = true
        
        let firstColumnPublisher = Timer.publish(every: durationFirstPublisher+0.1, on: .main, in: .common).autoconnect()
        let secondColumnPublisher = Timer.publish(every: durationSecondPublisher+0.1, on: .main, in: .common).autoconnect()
        let thirdColumnPublisher = Timer.publish(every: durationThirdPublisher+0.1, on: .main, in: .common).autoconnect()
        
        
        firstColumnPublisher.sink(receiveValue: {_ in
            for indexRow in 0 ... 3 {
                self.animateOneEmoji(duration: self.durationFirstPublisher, emojiForAnimation: self.firstColumnOfEmojis[indexRow], indexRow: indexRow) {index in
                    if index == 3 {
                        self.creatingLoopFromArray(columnOfEmojis: &self.firstColumnOfEmojis)
                    }
                }
            }
        }).store(in: &subscriptions)
        
        
        secondColumnPublisher.sink(receiveValue: {_ in
            for indexRow in 0 ... 3 {
                self.animateOneEmoji(duration: self.durationFirstPublisher, emojiForAnimation: self.secondColumnOfEmojis[indexRow], indexRow: indexRow) {index in
                    if index == 3 {
                        self.creatingLoopFromArray(columnOfEmojis: &self.secondColumnOfEmojis)
                    }
                }
            }
        }).store(in: &subscriptions)
        
        
        thirdColumnPublisher.sink(receiveValue: {_ in
            for indexRow in 0 ... 3 {
                self.animateOneEmoji(duration: self.durationFirstPublisher, emojiForAnimation: self.thirdColumnOfEmojis[indexRow], indexRow: indexRow) {index in
                    if index == 3 {
                        self.creatingLoopFromArray(columnOfEmojis: &self.thirdColumnOfEmojis)
                    }
                }
            }
        }).store(in: &subscriptions)
    }
    
    
    private func creatingLoopFromArray(columnOfEmojis: inout [UILabel]){
        columnOfEmojis.last!.frame.origin.y = 0
        columnOfEmojis.insert(contentsOf: [columnOfEmojis.last!], at: 0)
        let randomEmoji = Constants.shared.emojiRangeForCasino[Int.random(in: 0...14)]
        columnOfEmojis[0].text = String(UnicodeScalar(randomEmoji)!)
        columnOfEmojis.removeLast()
    }
    
    
    func animateOneEmoji(duration: CFTimeInterval, emojiForAnimation: UILabel, indexRow: Int, completion: @escaping (Int) -> Void){
        let heightOneEmoji = groundviewForEmojiUIView.frame.height/5
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: [],
                       animations: {
                        let frameEmoji = emojiForAnimation.frame
                        emojiForAnimation.frame = CGRect(x: frameEmoji.origin.x, y: frameEmoji.origin.y + heightOneEmoji, width: frameEmoji.width, height: frameEmoji.height)
                       },
                       completion: {_ in
                            completion(indexRow)
                       }
        )
    }
    
    func stopAnimationFunc(){
        
        guard isGameStart else {return}
        isGameStart = false
        
        subscriptions = []
        
        if (firstColumnOfEmojis[1].text == secondColumnOfEmojis[1].text) && (secondColumnOfEmojis[1].text == thirdColumnOfEmojis[1].text) ||
            (firstColumnOfEmojis[2].text == secondColumnOfEmojis[2].text) && (secondColumnOfEmojis[2].text == thirdColumnOfEmojis[2].text) ||
            (firstColumnOfEmojis[3].text == secondColumnOfEmojis[3].text) && (secondColumnOfEmojis[3].text == thirdColumnOfEmojis[3].text) {
            gameResultNotification(message1: "Поздравляем!", message2: "Вы выиграли")
        } else {
            gameResultNotification(message1: "Сожалеем!", message2: "Вы проиграли")
        }
    }
    
    
    func gameResultNotification(message1: String, message2: String) {
        let alertController = UIAlertController(title: message1,
                                                message: message2,
                                                preferredStyle: .alert)
        let buttonOk = UIAlertAction(title: "Ok", style: .default, handler:{ _ in})
        alertController.addAction(buttonOk)
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
}

