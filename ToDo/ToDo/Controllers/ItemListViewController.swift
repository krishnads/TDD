//
//  ItemListViewController.swift
//  ToDo
//
//  Created by Apple on 06/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class ItemListViewController: UIViewController {

    @IBOutlet var tableView: UITableView?
    @IBOutlet var dataProvider: (UITableViewDataSource & UITableViewDelegate)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView!.dataSource = dataProvider
        tableView!.delegate = dataProvider
        
        
        
//        let array = [1, 2, 3, 4, 5, 6]
//        
//        let newArray = array.map { (number) -> Int in
//            let farray = array.filter { (num) -> Bool in
//                num != number
//            }
//            let multiply = farray.reduce(1) { (result, num) -> Int in
//                result * num
//            }
//            return multiply
//        }
//        
//        print(newArray)
    }
}
