//
//  PracticalTask#2.swift
//  PracticalWorkOnCombine
//
//  Created by Eduard on 13.02.2022.
//

import UIKit
import Combine

class PracticalTaskNumber_2  {
    var delegate: ViewController?
    
    private func practicalWorkNumber_2(){
        guard let delegate = delegate else {return}
        print("\n\n*******  Практическое задание ко второму уроку ********")
        
        //Первое задание - публикация коллекции чисел ...
        let publisherNumbers = (1...100).publisher
        print("\nВыборка четных чисел с 50-й по 70-ю позицию в последовательности от 1 до 100: ")
        publisherNumbers
            .dropFirst(50)
            .prefix(20)
            .filter({$0%2 == 0})
            .sink(receiveValue:
                    {value in
                        print(value, separator: " ", terminator: " ")
                    })
            .store(in: &delegate.subscriptions)
        print("\n")
        
        //Второе задание - вычисление среднеарифметического значения
        let numberOfElementsInArray = 50
        var sumOfNumbers = 0
        
        let arrayOfNumberInStringFormat = Array(repeating: 0, count: numberOfElementsInArray).map{_ in String(Int.random(in: 0...1000))}
        
        let publisherNumbersInStringFormat = arrayOfNumberInStringFormat.publisher
        
        publisherNumbersInStringFormat
            .map({Int($0)!})
            .sink(receiveCompletion: { _ in
                let average = sumOfNumbers/numberOfElementsInArray
                print("Среднее арифметическое \(numberOfElementsInArray) случайных чисел в диапазоне от 1 до 1000 равно: \(average)\n\n")
                
            }, receiveValue: {value in
                sumOfNumbers += value
            })
            .store(in: &delegate.subscriptions)
        print("\n")
        
        //Третье задание - поиск в телефонной базе
        //Создание базы
        delegate.baseOfPhoneNumber = Array(repeating: 0, count: numberOfElementsInArray).map{_ -> (String, Int) in
            let phoneNumberCodes = Constants.shared.phoneNumberCodes
            let firstName = Constants.shared.firstNames
            let secondName = Constants.shared.secondNames
            let randomFirstName = firstName[Int.random(in: 0 ... firstName.count-1)]
            let randomSecondName = secondName[Int.random(in: 0 ... secondName.count-1)]
            let randomCode = phoneNumberCodes[Int.random(in: 0 ... phoneNumberCodes.count-1)]
            let phoneNumberWithoutCode = String(Int.random(in: 1111111...9999999))
            return (randomFirstName + "\n" + randomSecondName, Int(randomCode+phoneNumberWithoutCode)!)
        }
        
        delegate.searchingPhoneNumberPublisher.map({ value -> String in
            if let phoneNumberInInt = Int(value) {
                if let indexOfRow = delegate.baseOfPhoneNumber.firstIndex(where: {$0.1 == phoneNumberInInt}) {
                    var fullName = delegate.baseOfPhoneNumber[indexOfRow].0
                    fullName = fullName.replacingOccurrences(of: "\n", with: " ")
                    return "Номер принадлежит:\n\(fullName)"
                }
            }
            else {return "Ошибка! В запросе могут быть только цифры"}
            
            return "Такой номер не найден!"
        }).sink(receiveValue: {result in
            delegate.titleResultSearchLabel.isHidden = false
            delegate.searchResultsLabel.isHidden = false
            delegate.searchResultsLabel.text = result
        })
            .store(in: &delegate.subscriptions)
    }
}
