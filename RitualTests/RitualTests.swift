import XCTest
@testable import Ritual

class RitualTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testTaskInitialization() {
    let emptyTask = Task.init(description: "", notes: nil)
    XCTAssertNil(emptyTask)
  }
}
