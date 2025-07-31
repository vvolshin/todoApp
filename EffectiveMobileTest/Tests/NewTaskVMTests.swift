import Foundation
import Testing

@testable import EffectiveMobileTest

struct NewTaskVMTests {
	@Test func testAddNewTaskSuccess() throws {
		let mockCoreData = MockCoreDataManager()
		try mockCoreData.saveTodos([
			TodoItem(id: 1, todo: "Buy milk", completed: false, userId: 1),
			TodoItem(id: 2, todo: "Buy bread", completed: true, userId: 1),
			TodoItem(id: 3, todo: "Walk dog", completed: false, userId: 1),
		])

		let viewModel = NewTaskVM(coreDataManager: mockCoreData)

		try viewModel.saveTaskToCoreData(TodoItem(id: 4, todo: "Water plants", completed: false, userId: 1))
        try viewModel.loadFromCoreData()

		#expect(viewModel.todos.count == 4)
		#expect(viewModel.todos.contains(where: { $0.todo == "Water plants" }))
	}
    
    @Test func testSaveToCoreDataFailure() {
        let mockCoreData = MockCoreDataManager()
        mockCoreData.shouldThrowSaveError = true
        
        let viewModel = NewTaskVM(coreDataManager: mockCoreData)
        
        #expect(throws: CoreDataErrors.self, performing: {
            try viewModel.saveTaskToCoreData(TodoItem(id: 4, todo: "Water plants", completed: false, userId: 1))
        })

        #expect(viewModel.todos.isEmpty)
    }
    
    @Test func testLoadFromCoreDataFailure() {
        let mockCoreData = MockCoreDataManager()
        mockCoreData.shouldThrowFetchError = true
        
        let viewModel = NewTaskVM(coreDataManager: mockCoreData)
        
        #expect(throws: CoreDataErrors.self, performing: {
            try viewModel.loadFromCoreData()
        })

        #expect(viewModel.todos.isEmpty)
    }
}
