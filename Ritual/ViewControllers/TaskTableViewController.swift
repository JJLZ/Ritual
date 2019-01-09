import UIKit

class TaskTableViewController: UITableViewController {
    
    var tasks: [Task?] = []
    private var tasksKey = "Tasks"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTasks()
        TrackingManager.startTrackingTimedEvent(name: "Create Task")
    }
    
    private func loadTasks() {
        if let decoded = UserDefaults.standard.data(forKey: tasksKey) {
            tasks = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? [Task?] ?? []
        }
    }
}

// MARK: - Table view data source
extension TaskTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "TaskTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TaskTableViewCell else {
            fatalError("The dequeued cell is not an instance of TaskTableViewCell")
        }
        
        cell.taskLabel.text = tasks[indexPath.row]?.taskDescription
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension TaskTableViewController {
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let segueID = segue.identifier else { return }
        switch segueID {
        case "AddTask":
            break
        case "ShowDetail":
            guard let taskDetailViewController = segue.destination as? TaskDetailsViewController else {
                fatalError("Unexpected Destination: \(segue.destination)")
            }
            
            guard let taskCell = sender as? TaskTableViewCell else {
                fatalError("Unexpected sender: \(sender.debugDescription)")
            }
            
            guard let indexPath = tableView.indexPath(for: taskCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            taskDetailViewController.task = tasks[indexPath.row]
        default:
            fatalError("Unexpected Segue Identifier; \(segueID.debugDescription)")
        }
    }
    
    
    //MARK: Actions
    @IBAction func unwindToTaskList(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? TaskDetailsViewController, let task = sourceViewController.task {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tasks[selectedIndexPath.row] = task
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                let newIndexPath = IndexPath(row: tasks.count, section: 0)
                tasks.append(task)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                
                self.trackCreateTask(task)
            }
            self.saveTasks()
        }
    }
    
    private func saveTasks() {
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: tasks)
        UserDefaults.standard.set(encodedData, forKey: tasksKey)
    }
    
    private func trackCreateTask(_ task: Task) {
        TrackingManager.trackEvent(name: "Create Task", eventProperties: ["isReminderSet": task.isReminderSet])
    }
}
