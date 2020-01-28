

import UIKit



protocol AddItemViewControllerDelegate : class {
    func addItemViewComtrollerDidCancel(_ controller : AddItemTableViewController)
    func addItemViewController(_ controller : AddItemTableViewController, didFinishAdding item : ChecklistItem)
    func editItemViewController (_ controller: AddItemTableViewController, didFinishEditing item: ChecklistItem)
    
}


class AddItemTableViewController: UITableViewController {

    
    weak var delegate : AddItemViewControllerDelegate?
    weak var todoList :TodoList?
    weak var itemToEdit: ChecklistItem?
    
    @IBOutlet weak var AddBarButton: UIBarButtonItem!
    @IBOutlet weak var CancelBarButton: UIBarButtonItem!
    @IBOutlet weak var TextField: UITextField!
    
    
    @IBAction func addAction(_ sender: Any) {
        addOrEditItem()
    }
    
    func addOrEditItem() {
        if let item = itemToEdit, let text = TextField.text{
            item.text = text
            delegate?.editItemViewController(self, didFinishEditing: item)
        }else {
            if let item = todoList?.newToDo(){
                if let textFieldText = TextField.text{
                    item.text = textFieldText
                }
                item.checked = false
                delegate?.addItemViewController(self, didFinishAdding: item)
                }
            }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        delegate?.addItemViewComtrollerDidCancel(self )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let item = itemToEdit{
            title = "Edit Item"
            TextField.text = item.text
            AddBarButton.isEnabled = true
        }
        navigationItem.largeTitleDisplayMode = .never
        TextField.delegate = self
    }

    
    override func viewWillAppear(_ animated: Bool) {
        TextField.becomeFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }

}







extension AddItemTableViewController : UITextFieldDelegate{
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        TextField.resignFirstResponder()
        addOrEditItem()
        return false
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let oldText = textField.text,
             let stringRange = Range(range, in : oldText) else {return false}
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        if newText.isEmpty {
            AddBarButton.isEnabled = false
        }else{
            AddBarButton.isEnabled = true
        }
        return true
    }

}
