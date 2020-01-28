//
//  ChecklistItem.swift
//  Checklist
//
//  Created by Nazik on 20.01.2020.
//  Copyright © 2020 Nazik. All rights reserved.
//

import Foundation

class ChecklistItem : NSObject {
    @objc var text = ""
    var checked = false
    
    
    func toggleChecked(){
        checked = !checked
    }
    
}
