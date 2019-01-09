//
//  ViewController.swift
//  RealmApp
//
//  Created by Rahul Chopra on 09/01/2018.
//  Copyright © 2018 Rahul Chopra. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    var tableView: UITableView = {
        let table = UITableView()
        table.rowHeight = 80
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    var addButton = UIBarButtonItem()
    
    var realm: Realm!                    // Declare realm object
    var objectsArray: Results<Item> {
        get {
            return realm.objects(Item.self)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        realm = try! Realm()             // Initialize realm object
        
        setup()
        setupTableView()
    }
    
    func setup() {
        view.backgroundColor = .white
        navigationItem.title = "Things"
        navigationController?.navigationBar.prefersLargeTitles = true
        addButton = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(addNewItem))
        navigationItem.rightBarButtonItem = addButton
        navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MyCell.self, forCellReuseIdentifier: MyCell.reuseIdentifier)
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    @objc func addNewItem() {
        let alertVC = UIAlertController(title: "Add New Item", message: "What do you want to do?", preferredStyle: .alert)
        alertVC.addTextField(configurationHandler: nil)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default) { (UIAlertAction) -> Void in
            let myTextField = (alertVC.textFields?.first)! as UITextField
            
            // Create 'Item' object
            let item = Item()
            item.name = myTextField.text!
            
            // Add and write 'Item' object into realm
            try! self.realm.write {
                self.realm.add(item)
                self.tableView.insertRows(at: [IndexPath(row: self.objectsArray.count-1, section: 0)], with: .automatic)
            }
        }
        
        alertVC.addAction(cancelAction)
        alertVC.addAction(addAction)
        present(alertVC, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyCell.reuseIdentifier, for: indexPath) as! MyCell
        
        let item = objectsArray[indexPath.row]
        cell.todoImageView.image = UIImage(named: item.picture)
        cell.todoLabel.text = item.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let item = objectsArray[indexPath.row]
            
            // Delete 'Item' object from realm
            try! self.realm.write {
                self.realm.delete(item)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
}

class MyCell: UITableViewCell {
    
    static let reuseIdentifier = "cell"
    
    let todoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let todoLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        addSubview(todoImageView)
        addSubview(todoLabel)
        
        todoImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        todoImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        todoImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        todoImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        todoLabel.leftAnchor.constraint(equalTo: todoImageView.rightAnchor, constant: 10).isActive = true
        todoLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
}


