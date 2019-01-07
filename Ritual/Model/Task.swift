import Foundation

class Task {
  let description: String
  let notes: String?
  
  init?(description: String, notes: String?) {
    
    if description.isEmpty {
      return nil
    }
    
    self.description = description
    self.notes = notes
  }
}
