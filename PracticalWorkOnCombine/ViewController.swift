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
        configureTableView()
        practicalWorkNumber_1()
        practicalWorkNumber_2()
    }
    
    let transmittedTextPublisher = PassthroughSubject<String, Never>()
    let searchingPhoneNumberPublisher = PassthroughSubject<String, Never>()
    var subscriptions = Set<AnyCancellable>()
    var baseOfPhoneNumber = [(String, Int)]()
   
    @IBOutlet weak var transmittedTextUITextField: UITextField!
    @IBOutlet weak var transmittedTextLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var phoneNumberForSearchTextField: UITextField!
    @IBOutlet weak var searchResultsLabel: UILabel!
    @IBOutlet weak var titleResultSearchLabel: UILabel!
    

    @IBAction func transferButton(_ sender: Any) {
        guard let transmittedText = transmittedTextUITextField.text else {return}
        transmittedTextPublisher.send(transmittedText)
    }
    @IBAction func startSearchingButton(_ sender: Any) {
        guard let phoneNumberForSearchTextField = phoneNumberForSearchTextField.text else {return}
        searchingPhoneNumberPublisher.send(phoneNumberForSearchTextField)
    }
    
    
    //MARK: Practical task #1
    private func practicalWorkNumber_1(){
        print("*******  Практическое задание к первому уроку ********\n")
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
        
        let transmittedTextSubscriberClass = TransmittedTextSubscriberClass(transmittedTextLabel: transmittedTextLabel)
        transmittedTextPublisher.subscribe(transmittedTextSubscriberClass)
    }
    
    
    //MARK: Practical task #2
    private func practicalWorkNumber_2(){
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
            .store(in: &subscriptions)
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
            .store(in: &subscriptions)
        print("\n")
        
        //Третье задание - поиск в телефонной базе
        //Создание базы
        baseOfPhoneNumber = Array(repeating: 0, count: numberOfElementsInArray).map{_ -> (String, Int) in
            let phoneNumberCodes = Constants.shared.phoneNumberCodes
            let firstName = Constants.shared.firstNames
            let secondName = Constants.shared.secondNames
            let randomFirstName = firstName[Int.random(in: 0 ... firstName.count-1)]
            let randomSecondName = secondName[Int.random(in: 0 ... secondName.count-1)]
            let randomCode = phoneNumberCodes[Int.random(in: 0 ... phoneNumberCodes.count-1)]
            let phoneNumberWithoutCode = String(Int.random(in: 1111111...9999999))
            return (randomFirstName + "\n" + randomSecondName, Int(randomCode+phoneNumberWithoutCode)!)
        }
        
        searchingPhoneNumberPublisher.map({ value -> String in
            if let phoneNumberInInt = Int(value) {
                if let indexOfRow = self.baseOfPhoneNumber.firstIndex(where: {$0.1 == phoneNumberInInt}) {
                    var fullName = self.baseOfPhoneNumber[indexOfRow].0
                    fullName = fullName.replacingOccurrences(of: "\n", with: " ")
                    return "Номер принадлежит:\n\(fullName)"
                }
            }
            else {return "Ошибка! В запросе могут быть только цифры"}
            
            return "Такой номер не найден!"
        }).sink(receiveValue: {result in
            self.titleResultSearchLabel.isHidden = false
            self.searchResultsLabel.isHidden = false
            self.searchResultsLabel.text = result
        })
            .store(in: &subscriptions)
    }
}
