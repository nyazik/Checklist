//
//  ViewController.swift
//  Checklist
//
//  Created by Nazik on 19.01.2020.
//  Copyright © 2020 Nazik. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {
    
    var todoList:TodoList
    
    private func priorityForSectionIndex(_ index: Int) -> TodoList.Priority? {
        return TodoList.Priority(rawValue: index)
    }
    
    required init?(coder aDecoder: NSCoder) {
        todoList  = TodoList()
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = editButtonItem
        tableView.allowsMultipleSelectionDuringEditing = true
        
        
    }

    
    
    
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        tableView.setEditing(tableView.isEditing, animated: true)
    }

    
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

        if let srcPriority = priorityForSectionIndex(sourceIndexPath.section),
            let destPriority = priorityForSectionIndex(destinationIndexPath.section){
            let item = todoList.todoList(for: srcPriority)[sourceIndexPath.row]
            todoList.move(item: item, from: srcPriority, at: sourceIndexPath.row, to: destPriority, at: destinationIndexPath.row)
            
        }
            
        
        tableView.reloadData()
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let priority = priorityForSectionIndex(section){
            return todoList.todoList(for: priority).count
        }
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        //let item = todoList.todos[indexPath.row]
        if let priority = priorityForSectionIndex(indexPath.section){
            let items = todoList.todoList(for: priority)
            let item = items[indexPath.row]
            configureText(for: cell, with: item)
            configureCheckMark(for: cell, with: item)
        }
        
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing{
            return
        }
        if let cell = tableView.cellForRow(at: indexPath){
            if let priority = priorityForSectionIndex(indexPath.section){
                let items = todoList.todoList(for: priority)
                let item  = items[indexPath.row]
                
                
                item.toggleChecked()
                configureCheckMark(for: cell, with: item)
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
    
    
    func configureCheckMark (for cell: UITableViewCell, with item: ChecklistItem){
        guard let checkmarkCell = cell as? ChecklistTableViewCell  else {
            return
        }
        
        if item.checked{
            checkmarkCell.checkmarkView.text  = "√​"
        }else{
            checkmarkCell.checkmarkView.text = ""
        }
        
     }
    
    
    func configureText (for cell: UITableViewCell, with item: ChecklistItem){
          if let checkmarkCell = cell as? ChecklistTableViewCell{
            checkmarkCell.todoTextLable.text  = item.text
          }
      }
    
    
    
    @IBAction func deleteLabel(_ sender: Any) {
        if let selectedRows  = tableView.indexPathsForSelectedRows {
            for indexPath in selectedRows{
                if let priority = priorityForSectionIndex(indexPath.section){
                    let todos = todoList.todoList(for: priority)
                    
                    let rowToDelete = indexPath.row > todos.count - 1 ? todos.count - 1 : indexPath.row
                    let item = todos[rowToDelete]
                    todoList.remove(item, from: priority, at: rowToDelete)
                }
            }
            tableView.beginUpdates()
            tableView.deleteRows(at: selectedRows, with: .automatic)
            tableView.endUpdates()
        }
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if let priority = priorityForSectionIndex(indexPath.section){
            let items  = todoList.todoList(for: priority)
            
            let rowToDelete = indexPath.row > items.count - 1 ? items.count - 1 : indexPath.row
            let item = items[rowToDelete]
            todoList.remove(item, from: priority, at: rowToDelete)
            _ = [indexPath]
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    
    
    @IBAction func addButton(){
        let newRawIndex = todoList.todoList(for: .medium).count
        _  = todoList.newToDo()
        let indexPath = IndexPath(row: newRawIndex, section: 0)
        _ = [indexPath]
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItemSegue" {
            if let addItemViewController = segue.destination as? AddItemTableViewController{
                addItemViewController.delegate = self as AddItemViewControllerDelegate
                addItemViewController.todoList = todoList
            }
        }else if segue.identifier == "EditItemSegue" {
                if let editItemViewController = segue.destination as? AddItemTableViewController{
                    if let cell = sender as? UITableViewCell ,
                        let indexPath = tableView.indexPath(for: cell),
                        let priority = priorityForSectionIndex(indexPath.section)
                        {
                            let item = todoList.todoList(for: priority)[indexPath.row]
                            editItemViewController.itemToEdit = item
                            editItemViewController.delegate = self
                    }
                }
            }
        }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return TodoList.Priority.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title : String? = nil
        if let priority = priorityForSectionIndex(section){
            switch priority {
            case .high:
                title = "high priority"
            case .medium:
                title = "medium priority"
            case .low:
                title = "low priority"
            case .no:
                title = "no priority"
            }
        }
        return title
    }
    

}


extension ChecklistViewController : AddItemViewControllerDelegate{
    func addItemViewComtrollerDidCancel(_ controller: AddItemTableViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addItemViewController(_ controller: AddItemTableViewController, didFinishAdding item: ChecklistItem) {
        navigationController?.popViewController(animated: true)
        let rawIndex = todoList.todoList(for: .medium).count - 1
        //todoList.todos.append(item)
        let indexPath = IndexPath(row: rawIndex, section: TodoList.Priority.medium.rawValue)
        _ = [indexPath]
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func editItemViewController(_ controller: AddItemTableViewController, didFinishEditing item: ChecklistItem) {
        
        for priority in TodoList.Priority.allCases{
            let currentList = todoList.todoList(for: priority)
            if let index  = currentList.index(of: item){
                let indexPath = IndexPath(row: index, section: priority.rawValue)
                if let cell = tableView.cellForRow(at: indexPath){
                    configureText(for: cell, with: item)
                }
            }
        }
        
        navigationController?.popViewController(animated: true)
    }
    
}
