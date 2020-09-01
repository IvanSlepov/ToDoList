//
//  ViewController.swift
//  ToDo List
//
//  Created by Ivan Sliepov on 31.08.2020.
//  Copyright © 2020 Ivan Sliepov. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var importantCheckbox: NSButton!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var deleteButton: NSButton!
    
    var toDoItems : [ToDoItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getToDoItems()

        // Do any additional setup after loading the view.
    }
    
    func getToDoItems() {
        if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
            do {
                toDoItems = try context.fetch(ToDoItem.fetchRequest())
                // print(toDoItems.count)
            }catch{}
        }
        
        tableView.reloadData()
    }
    
    @IBAction func addClicked(_ sender: Any) {
        if textField.stringValue != ""{
            if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
                
                let toDoItem = ToDoItem(context: context)
                
                toDoItem.name = textField.stringValue
                if importantCheckbox.state.rawValue == 0 {
                    toDoItem.important = false
                }
                else{
                    toDoItem.important = true
                }
                
                (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
                
                textField.stringValue = ""
                importantCheckbox.state = NSControl.StateValue(rawValue: 0)
                
                getToDoItems()
            }
            
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    @IBAction func deleteClicked(_ sender: Any) {
        let toDoItem = toDoItems[tableView.selectedRow]
        
        if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
            
            context.delete(toDoItem)
            
            (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
            
            getToDoItems()
            
            deleteButton.isHidden = true
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return toDoItems.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let toDoItem = toDoItems[row]
        
        if tableColumn?.identifier.rawValue == "importantColumn" {
            
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "importantCell"), owner: self) as? NSTableCellView {
                
                if toDoItem.important {
                    cell.textField?.stringValue = "❗️"
                } else {
                    cell.textField?.stringValue = ""
                }
                
                return cell
            }
        }
        
        else {
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "todoitems"), owner: self) as? NSTableCellView {
                
                let toDoItem = toDoItems[row]
                
                cell.textField?.stringValue = toDoItem.name!
                
                return cell
            }
        }
        
        return nil
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        deleteButton.isHidden = false
    }
}

