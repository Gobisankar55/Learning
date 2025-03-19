//
//  ViewController.swift
//  MyCoreDataTwo
//
//  Created by Gobisankar M M on 15/03/25.
//

import UIKit
import SwiftUI

enum FilterType: String {
    case all = ""
    case fruit
    case veg
}

class ToDoItemCell: UITableViewCell {
    
    let lblName = UILabel()
    let lblItemType = UILabel()
    
    var item: ToDoItems? {
        didSet {
            lblName.text = item?.name ?? ""
            lblItemType.text = item?.itemType?.name ?? ""
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //add subviews here
        lblName.translatesAutoresizingMaskIntoConstraints = false
        lblItemType.translatesAutoresizingMaskIntoConstraints = false
        
        let vStackView = UIStackView(arrangedSubviews: [lblName, lblItemType])
        vStackView.axis = .vertical
        vStackView.distribution = .fillEqually
        vStackView.spacing = 10
        
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(vStackView)

        NSLayoutConstraint.activate([
            vStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            vStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            vStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 8),
            vStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            vStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 70)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class ViewController: UIViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //let context = CoreDataStack.sharedInstance.mainContext
    
    private let utility = Utilities.shared
    private let tableView = UITableView()
    
    private var toDoItems: [ToDoItems] = []
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    

    private func setupLayout() {
        
        let baseView: UIView = self.view
        
        self.navigationItem.title = "ToDo Lists"
        
        tableView.register(ToDoItemCell.self, forCellReuseIdentifier: "CellID")
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: baseView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: baseView.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: baseView.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: baseView.trailingAnchor)
        ])
        
        
        //add plus icon here
        let addItemBarButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(didClickAddBarButton))
        
        let filterBarButton = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(didClickFilterButton))
        
        self.navigationItem.rightBarButtonItems = [addItemBarButton, filterBarButton]
        
        
        //fetch all items
        fetchAllItems(filterType: .all)
        
        
    }
    
    
    //MARK: - Button Actions
    @objc private func didClickAddBarButton(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Add Item", message: nil, preferredStyle: .alert)
        alertController.addTextField { itemField in
            itemField.placeholder = "Enter item here"
        }
        alertController.addTextField { typeField in
            typeField.placeholder = "Enter type here"
        }
        
        let okAction = UIAlertAction(title: "Submit", style: .default) { [weak self] action in
            
            guard let txtNameField = alertController.textFields?.first, let name = txtNameField.text, !name.isEmpty else {
                return
            }
            guard let txtTypeField = alertController.textFields?[1], let type = txtTypeField.text, !type.isEmpty else {
                return
            }
            
            self?.addItems(itemName: name, itemType: type)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
    }
        
    @objc private func didClickFilterButton(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Filter Options", message: nil, preferredStyle: .actionSheet)

        let allAction = UIAlertAction(title: "All Items", style: .default) { [weak self] action in
            
            self?.fetchAllItems(filterType: .all)
        }
        let fruitAction = UIAlertAction(title: "Only Friuts", style: .default) { [weak self] action in
            
            self?.fetchAllItems(filterType: .fruit)
        }
        let vegAction = UIAlertAction(title: "Only Vegtables", style: .default) { [weak self] action in
            
            self?.fetchAllItems(filterType: .veg)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(allAction)
        alertController.addAction(fruitAction)
        alertController.addAction(vegAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        toDoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) as! ToDoItemCell
        
        if !toDoItems.isEmpty {
            let item = toDoItems[indexPath.row]
            cell.item = item
        }
        
        return cell
    }
    
    //MARK: - Delegates
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard !toDoItems.isEmpty else {
            return
        }
        
        let selectedItem = toDoItems[indexPath.row]
        
        let actionSheet = UIAlertController(title: "Choose Action", message: nil, preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: "Edit", style: .default) { [weak self] action in
                        
            self?.showEditAlert(selectedItem: selectedItem)
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] delete in
            
            self?.deleteItem(item: selectedItem)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        actionSheet.addAction(editAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true)
    }
    
    
    private func showEditAlert(selectedItem: ToDoItems) {
        
        let alertController = UIAlertController(title: "Edit Item", message: nil, preferredStyle: .alert)
        alertController.addTextField { itemField in
            itemField.placeholder = "Enter item here"
            itemField.text = selectedItem.name
        }
        alertController.addTextField { typeField in
            typeField.placeholder = "Enter type here"
            typeField.text = selectedItem.itemType?.name
        }
        //alertController.textFields?.first?.text = selectedItem.name
        
        let okAction = UIAlertAction(title: "Submit", style: .default) { [weak self] action in
            
            guard let txtNameField = alertController.textFields?.first, let name = txtNameField.text, !name.isEmpty else {
                return
            }
            guard let txtTypeField = alertController.textFields?[1], let type = txtTypeField.text, !type.isEmpty else {
                return
            }
            
            self?.updateItem(item: selectedItem, newItem: name, newType: type)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
    }
}


//MARK: - Core Data
extension ViewController {
    
    private func fetchAllItems(filterType: FilterType = .all) {
        
        do {
            var predicate: NSPredicate?
            if filterType != .all {
                predicate = NSPredicate(format: "type =[c] %@", filterType.rawValue)
            }
            toDoItems = try context.fetch(ToDoItems.fetchRequest(filterPredicate: predicate))
            
            print("toDoItems", toDoItems)
            
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
            
        } catch {
            print("Err in fetch to do items", error.localizedDescription)
        }
    }
    
    private func addItems(itemName: String, itemType: String) {
        
        let newItem = ToDoItems(context: context)
        newItem.name = itemName
        newItem.itemAddedAt = Date()
        newItem.itemType?.name = itemType
        
        updateCoreData()
    }
    
    private func updateItem(item: ToDoItems, newItem: String, newType: String) {
        
        item.name = newItem
        item.itemType?.name = newItem
        
        updateCoreData()
    }
    
    
    private func deleteItem(item: ToDoItems) {
     
        context.delete(item)
        
        updateCoreData()
    }
    
    
    private func updateCoreData() {
        
        CoreDataStack.sharedInstance.saveContext()
        
        fetchAllItems()
        
//        do {
//            try context.save()
//            
//            fetchAllItems()
//            
//        } catch {
//            print("Err in save to do items", error.localizedDescription)
//        }
    }
}
