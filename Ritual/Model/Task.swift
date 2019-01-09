import Foundation

class Task: NSObject, NSCoding {
    let taskDescription: String
    let notes: String?
    var isReminderSet: Bool = false
    var reminderDate: Date?
    
    init?(taskDescription: String, notes: String?) {
        if taskDescription.isEmpty {
            return nil
        }
        
        self.taskDescription = taskDescription
        self.notes = notes
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let taskDescription = aDecoder.decodeObject(forKey: "taskDescription") as? String ?? ""
        let notes = aDecoder.decodeObject(forKey: "notes") as? String ?? ""
        let isReminderSet = aDecoder.decodeBool(forKey: "isReminderSet")
        let reminderDate = aDecoder.decodeObject(forKey: "reminderDate") as? Date
        self.init(taskDescription: taskDescription, notes: notes)
        self.isReminderSet = isReminderSet
        self.reminderDate = reminderDate
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.taskDescription, forKey: "taskDescription")
        aCoder.encode(self.notes ?? "", forKey: "notes")
        aCoder.encode(self.isReminderSet, forKey: "isReminderSet")
        aCoder.encode(self.reminderDate, forKey: "reminderDate")
    }
}
