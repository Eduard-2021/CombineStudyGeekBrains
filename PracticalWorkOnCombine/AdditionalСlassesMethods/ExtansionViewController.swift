//
//  ExtansionViewController.swift
//  PracticalWorkOnCombine
//
//  Created by Eduard on 05.02.2022.
//

import UIKit

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        let cellName = UINib(nibName: "TableViewCellForPhoneNumberBase", bundle: nil)
        tableView.register(cellName, forCellReuseIdentifier: "TableViewCellForPhoneNumberBase")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return baseOfPhoneNumber.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCellForPhoneNumberBase", for: indexPath) as? TableViewCellForPhoneNumberBase else {return UITableViewCell()}
        cell.nameLabel.text = String(baseOfPhoneNumber[indexPath.row].0)
        cell.cellWithPhoneNumberLabel.text = String(baseOfPhoneNumber[indexPath.row].1)
        return cell
    }
}
