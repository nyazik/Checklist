//
//  TodoList.swift
//  Checklist
//
//  Created by Nazik on 20.01.2020.
//  Copyright © 2020 Nazik. All rights reserved.
//

import Foundation


class TodoList{
    
    
    enum  Priority : Int, CaseIterable {
        case high, medium, low, no
    }
    
    private var highPriotity : [ChecklistItem] = []
    private var mediumPriotity : [ChecklistItem] = []
    private var lowPriotity : [ChecklistItem] = []
    private var noPriotity : [ChecklistItem] = []
    
    
    
    init() {
        let raw0Item  = ChecklistItem()
        let raw1Item = ChecklistItem()
        let raw2Item = ChecklistItem()
        let raw3Item = ChecklistItem()
        let raw4Item = ChecklistItem()
        
        
        raw0Item.text = "take a jog"
        raw1Item.text = "watch a movie"
        raw2Item.text = "code an app"
        raw3Item.text = "walk the dog"
        raw4Item.text = "study"
        
        addTodo(raw0Item, for: .medium)
        addTodo(raw1Item, for: .low)
        addTodo(raw2Item, for: .medium)
        addTodo(raw3Item, for: .no)
        addTodo(raw4Item, for: .high)
    }
    
    
    
    func move(item : ChecklistItem, from sourcePriority: Priority, at sourseIndex : Int, to destinationPriority : Priority, at destionationIndex : Int ){
        
        remove(item , from: sourcePriority, at: sourseIndex)
        addTodo(item, for: destinationPriority, at: destionationIndex)
    }
    
    
    func remove (_ item: ChecklistItem, from priority : Priority, at index: Int){
        switch priority {
        case .high:
            highPriotity.remove(at: index)
        case .medium:
            mediumPriotity.remove(at: index)
        case .low:
            lowPriotity.remove(at: index)
        case .no:
            noPriotity.remove(at: index)
        }
    
    }
    
    
    
    func newToDo () -> ChecklistItem {
    let item = ChecklistItem()
    item.checked = false
    mediumPriotity.append(item)
    return item
    }
    
    func todoList (for priority : Priority) -> [ChecklistItem]{
        switch priority {
        case .high:
            return highPriotity
        case .medium:
            return mediumPriotity
        case .low:
            return lowPriotity
        case .no:
            return noPriotity
        }
    }
    
    
    
    func addTodo (_ item: ChecklistItem, for priority : Priority, at index : Int = -1){
        switch priority {
        case .high:
            if index < 0{
                highPriotity.append(item)
            }else{
                highPriotity.insert(item, at: index)
            }
        case .medium:
            if index < 0{
                mediumPriotity.append(item)
            }else{
                mediumPriotity.insert(item, at: index)
            }
        case .low:
            if index < 0{
                lowPriotity.append(item)
            }else{
                lowPriotity.insert(item, at: index)
            }
        case .no:
            if index < 0{
                lowPriotity.append(item)
            }else{
                noPriotity.insert(item, at: index)
            }
        }
    }
    
}
