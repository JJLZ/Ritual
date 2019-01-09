import UIKit

class TaskTableViewController: UITableViewController {
    
    var tasks: [Task?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSampleTasks()
    }
    
    private func loadSampleTasks() {
        let task1 = Task.init(description: "Task 1", notes: nil)
        let task2 = Task.init(description: "Task 2", notes: nil)
        
        tasks += [task1, task2]
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
        
        cell.taskLabel.text = tasks[indexPath.row]?.description
        return cell
    }
}

extension TaskTableViewController {
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
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
                // Update an existing task.
                tasks[selectedIndexPath.row] = task
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                // Add a new task.
                let newIndexPath = IndexPath(row: tasks.count, section: 0)
                
                tasks.append(task)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
