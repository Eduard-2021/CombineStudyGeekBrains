//
//  PracticalTask#3.swift
//  PracticalWorkOnCombine
//
//  Created by Eduard on 13.02.2022.
//

import UIKit
import Combine

class PracticalTaskNumber_3  {
    var delegate: ViewController?
    
    private func practicalWorkNumber_3(){
        guard let delegate = delegate else {return}
        print("*******  Практическое задание к третьему уроку ********\n")
        
        let publisherOfStrings = PassthroughSubject<String, Never>()
        let publisherOfCharacters = PassthroughSubject<Void, Never>()
        let publisherСompletedPublisherOfStrings = PassthroughSubject<String, Never>()
        let publisherСompletedPublisherOfCharacters = PassthroughSubject<String, Never>()
        let queueForGenerationPush = DispatchQueue(label: "QueueForGenerationPush")
        let symbolsForStrings = Constants.shared.symbolsForStrings
        let timeIntervalsForPublisherOfStrings = Constants.shared.timeIntervalsForPublisherOfStrings
        let timeIntervalsForPublisherOfCharacters = Constants.shared.timeIntervalsForPublisherOfCharacters
        let emojiRange = Constants.shared.emojiRange
        var isNeedInsertEmoji = false
        var resultWorkPublisherOfStrings = ""
        var resultWorkPublisherOfCharacters = ""
        
        //Издатель, который испускает строки, группирует данные каждые 0.5 секунды, сначала преобразует получившиеся массивы в массивы массивов символов типа Unicode.Scalar, потом в массив массивов символов типа Character, после этого преобразует все в массив букв и преобразует его в строку. Строку уже накапливает во внешнем хранилище
        
        publisherOfStrings
            .collect(.byTime(queueForGenerationPush, .seconds(0.5)))
            .map({stringArray -> [[Unicode.Scalar]] in
                var unicodeScalarArrays = [[Unicode.Scalar]]()
                for oneString in stringArray {
                    let unicodeScalarArray = oneString.unicodeScalars.map{value in
                        return  Unicode.Scalar(unicodeScalarLiteral: value)
                    }
                    unicodeScalarArrays.append(unicodeScalarArray)
                }
                return unicodeScalarArrays
            })
            .map({unicodeScalarArrays -> [[Character]] in
                var characterArrays = [[Character]]()
                for unicodeScalarArray in unicodeScalarArrays {
                    let characterArray = unicodeScalarArray.map{Character($0)}
                    characterArrays.append(characterArray)
                }
                return characterArrays
            })
            .map({characterArrays -> String in
                let lineInHalfSecond = characterArrays.compactMap({$0}).reduce("", +)
                return lineInHalfSecond
            })
            .sink(receiveCompletion: {_ in
                publisherСompletedPublisherOfStrings.send(resultWorkPublisherOfStrings)
            },
                receiveValue: {
                resultWorkPublisherOfStrings += $0 + "\n"
            })
            .store(in: &delegate.subscriptions)
        
        
        //Издатель, который состоит из двух частей - первая имеет подписку, которая меняет флаг isNeedInsertEmoji на true в случае если сообщения не приходят более 0.9 секунды, вторая часть - это подписка, которая реагирует на каждое сообщение и в зависимости от состояния флага добавляет во внешнее хранилище или эмодзи или пустую строку
        
        publisherOfCharacters
            .debounce(for: .seconds(0.9), scheduler: DispatchQueue.main)
            .share()
            .sink(receiveCompletion: {_ in
                publisherСompletedPublisherOfCharacters.send(resultWorkPublisherOfCharacters)
            },
                receiveValue: {_ in
                isNeedInsertEmoji = true
            })
            .store(in: &delegate.subscriptions)
        
        publisherOfCharacters
            .sink(receiveValue: {
                if isNeedInsertEmoji {
                    let emoji = emojiRange[Int.random(in: 0 ... emojiRange.count-1)]
                    resultWorkPublisherOfCharacters += String(UnicodeScalar(emoji)!)
                    isNeedInsertEmoji = false
                }
                else {
                    resultWorkPublisherOfCharacters += "\n"
                }
            })
            .store(in: &delegate.subscriptions)
        
        //Окончательный издатель, который состоит из 2 издателей - первый вызывается когда заканчивает работу издатель строк, второй - издатель эмодзи.
        
        publisherСompletedPublisherOfStrings
            .combineLatest(publisherСompletedPublisherOfCharacters)
            .map{resultWorkPublisherOfStrings, resultWorkPublisherOfCharacters -> String in
                let newResultWorkPublisherOfCharacters = resultWorkPublisherOfCharacters.replacingOccurrences(of: "\n", with: "")
                return "\n" + resultWorkPublisherOfStrings + newResultWorkPublisherOfCharacters
            }
            .sink(receiveValue: {result in
                print(result)
            })
            .store(in: &delegate.subscriptions)
        
        //Блок запуска и завершения работы издателей
       
        var timerForPublisherOfStrings: TimeInterval = 0
        
        for (index, value) in timeIntervalsForPublisherOfStrings.enumerated() {
            timerForPublisherOfStrings += value
            DispatchQueue.main.asyncAfter(deadline: .now() + timerForPublisherOfStrings){
                publisherOfStrings.send(symbolsForStrings[index])
            }
        }
        
        var timerForPublisherOfCharacters: TimeInterval = 0
        
        for value in timeIntervalsForPublisherOfCharacters {
            timerForPublisherOfCharacters += value
            DispatchQueue.main.asyncAfter(deadline: .now() + timerForPublisherOfCharacters){
                publisherOfCharacters.send()
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + timerForPublisherOfCharacters + 1){
            publisherOfStrings.send(completion: .finished)
            publisherOfCharacters.send(completion: .finished)
        }
    }
}
