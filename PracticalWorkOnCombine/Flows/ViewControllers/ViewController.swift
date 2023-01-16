//
//  ViewController.swift
//  PracticalWorkOnCombine
//
//  Created by Eduard on 02.02.2022.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    let practicalTaskNumber_1 = PracticalTaskNumber_1()
    let practicalTaskNumber_2 = PracticalTaskNumber_2()
    let practicalTaskNumber_3 = PracticalTaskNumber_3()
    let practicalTaskNumber_4 = PracticalTaskNumber_4()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        practicalTaskNumber_1.delegate = self
        practicalTaskNumber_2.delegate = self
        practicalTaskNumber_3.delegate = self
//        practicalTaskNumber_1.practicalWorkNumber_1()
//        practicalTaskNumber_2.practicalWorkNumber_2()
//        practicalTaskNumber_3.practicalWorkNumber_3()
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
   
}
