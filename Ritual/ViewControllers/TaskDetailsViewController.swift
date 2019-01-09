import UIKit
import os.log

class TaskDetailsViewController: UIViewController {
    
    @IBOutlet var descriptionTextField: UITextField!
    @IBOutlet var notesTextField: UITextField!
    @IBOutlet var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var containerView: UIView!
    var task: Task?
    var updatedReminderSetting: Bool? = nil
    var updatedReminderDate: Date? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionTextField.delegate = self
        if let task = task {
            descriptionTextField.text = task.taskDescription
            notesTextField.text = task.notes      
        }
        
        updateSaveButtonState()
    }
    
    // MARK: - Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPresentingInAddTaskMode = presentingViewController is UINavigationController
        if isPresentingInAddTaskMode {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The TaskDetailsViewController is not inside a navigation controller.")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "ReminderTable" {
            let reminderTableVC = segue.destination as? ReminderTableViewController
            reminderTableVC?.delegate = self
        }
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let description = descriptionTextField.text ?? ""
        let notes = notesTextField.text ?? ""
        let oldReminderSetting = task?.isReminderSet
        let oldReminderDate = task?.reminderDate
        
        task = Task(taskDescription: description, notes: notes)
        
        if let isReminderSet = updatedReminderSetting {
            task?.isReminderSet = isReminderSet
            updatedReminderSetting = nil
        } else {
            task?.isReminderSet = oldReminderSetting ?? false
        }
        
        if let reminderDate = updatedReminderDate {
            task?.reminderDate = reminderDate
            updatedReminderDate = nil
        } else {
            task?.reminderDate = oldReminderDate
        }
    }
}

extension TaskDetailsViewController: UITextFieldDelegate {
    //MARK: UITextFieldDelegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    //MARK: Private methods  
    func updateSaveButtonState() {    
        let description = self.descriptionTextField.text ?? ""
        saveButton.isEnabled = !description.isEmpty
    }
}

extension TaskDetailsViewController: ReminderViewDelegate {
    func reminderDataChanged(reminderSet: Bool, reminderDate: Date?) {
        updatedReminderSetting = reminderSet
        updatedReminderDate = reminderDate
    }
}
