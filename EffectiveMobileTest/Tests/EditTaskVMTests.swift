import Testing
import Foundation

@testable import EffectiveMobileTest

struct EditTaskVMTests {
    @Test func testEditTaskSuccess() throws {
        let mockCoreData = MockCoreDataManager()
        try mockCoreData.saveTodos([
            TodoItem(id: 1, todo: "Buy milk", completed: false, userId: 1),
            TodoItem(id: 2, todo: "Buy bread", completed: true, userId: 1),
            TodoItem(id: 3, todo: "Walk dog", completed: false, userId: 1)
        ])
        
        let viewModel = EditTaskVM(coreDataManager: mockCoreData)
        try viewModel.updateTodo(TodoItem(id: 2, todo: "Buy bread", completed: true, userId: 1), newTodo: "Cut bread into peases")
        try viewModel.loadFromCoreData()
        
        #expect(viewModel.todos.count == 3)
        #expect(viewModel.todos.contains(where: { $0.todo == "Cut bread into peases" }))
    }
    
    @Test func testEditNotFound() throws {
        let mockCoreData = MockCoreDataManager()
        
        let viewModel = EditTaskVM(coreDataManager: mockCoreData)
        let nonExistentTodo = TodoItem(id: 999, todo: "Ghost task", completed: false, userId: 1)
        try viewModel.loadFromCoreData()

        #expect(throws: CoreDataErrors.self, performing: {
            try viewModel.updateTodo(nonExistentTodo, newTodo: "New text")
        })
    }
    
    @Test func testEditThrowsError() throws {
        let mockCoreData = MockCoreDataManager()
        let item = TodoItem(id: 1, todo: "Buy milk", completed: false, userId: 1)
        try mockCoreData.saveTodo(item)
        mockCoreData.shouldThrowUpdateError = true
        
        let viewModel = EditTaskVM(coreDataManager: mockCoreData)
        try viewModel.loadFromCoreData()

        #expect(throws: CoreDataErrors.self, performing: {
            try viewModel.updateTodo(item, newTodo: "New text")
        })
    }
}
