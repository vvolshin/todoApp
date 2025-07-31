import Testing
import Foundation

@testable import EffectiveMobileTest

struct SearchVMTests {
    @Test func testSearchReturnsMatchingTodos() throws {
        let mockCoreData = MockCoreDataManager()
        try mockCoreData.saveTodos([
            TodoItem(id: 1, todo: "Buy milk", completed: false, userId: 1),
            TodoItem(id: 2, todo: "Buy bread", completed: true, userId: 1),
            TodoItem(id: 3, todo: "Walk dog", completed: false, userId: 1)
        ])
        
        let viewModel = SearchVM(coreDataManager: mockCoreData)
        
        try viewModel.searchTasks(by: "buy")
        
        #expect(viewModel.todos.count == 2)
        #expect(viewModel.todos.contains(where: { $0.todo == "Buy milk" }))
        #expect(viewModel.todos.contains(where: { $0.todo == "Buy bread" }))
    }
    
    @Test func testSearchReturnsEmptyIfNoMatch() throws {
        let mockCoreData = MockCoreDataManager()
        try mockCoreData.saveTodos([
            TodoItem(id: 1, todo: "Do homework", completed: false, userId: 1)
        ])
        
        let viewModel = SearchVM(coreDataManager: mockCoreData)
        
        try viewModel.searchTasks(by: "shopping")
        
        #expect(viewModel.todos.isEmpty)
    }
    
    @Test func testSearchThrowsError() throws {
        let mockCoreData = MockCoreDataManager()
        let viewModel = SearchVM(coreDataManager: mockCoreData)

        #expect(throws: CoreDataErrors.self, performing: {
            try viewModel.searchTasks(by: "throw")
        })
    }
}
