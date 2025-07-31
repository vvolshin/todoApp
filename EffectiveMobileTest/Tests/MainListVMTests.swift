import Testing

@testable import EffectiveMobileTest

struct MainListVMTests {
	@Test func testFetchTodosSuccess() async throws {
		let mockNetwork = MockNetworkAgent()
		let mockCoreData = MockCoreDataManager()
		mockNetwork.todosToReturn = [
			TodoItem(id: 1, todo: "Mock 1", completed: false, userId: 1),
			TodoItem(id: 2, todo: "Mock 2", completed: true, userId: 1),
		]

		let viewModel = MainListVM(networkAgent: mockNetwork, coreDataManager: mockCoreData)
		viewModel.deleteAllTodosFromCoreData()
		viewModel.fetchAndStoreTodos()

		for try await todos in viewModel.$todos.dropFirst().values {
			if todos.count == 2 { break }
		}

		#expect(viewModel.todos.count == 2)
		#expect(viewModel.todos[0].todo == "Mock 1")
		#expect(viewModel.todos[1].todo == "Mock 2")
	}

	@Test func testFetchTodosFailure() throws {
		let mockNetwork = MockNetworkAgent()
		mockNetwork.errorToReturn = .invalidURL

		let viewModel = MainListVM(networkAgent: mockNetwork)

		viewModel.fetchAndStoreTodos()

		#expect(viewModel.todos.isEmpty)
	}

	@Test func testLoadFromCoreDataFailure() {
		let mockCoreData = MockCoreDataManager()
		mockCoreData.shouldThrowFetchError = true

		let viewModel = MainListVM(networkAgent: MockNetworkAgent(), coreDataManager: mockCoreData)

		#expect(
			throws: CoreDataErrors.self,
			performing: {
				try viewModel.loadFromCoreData()
			})

		#expect(viewModel.todos.isEmpty)
	}

	@Test func testSaveTodoFailure() async throws {
		let mockCoreData = MockCoreDataManager()
		mockCoreData.shouldThrowSaveError = true

		let mockNetwork = MockNetworkAgent()
		mockNetwork.todosToReturn = [
			TodoItem(id: 1, todo: "Test todo", completed: false, userId: 1)
		]

		let viewModel = MainListVM(networkAgent: mockNetwork, coreDataManager: mockCoreData)
		viewModel.fetchAndStoreTodos()

		try viewModel.loadFromCoreData()

		_ = await viewModel.$todos.values.first(where: { !$0.isEmpty || mockCoreData.didCallSaveTodos })
		#expect(mockCoreData.didCallSaveTodos == true)
	}

	@Test func testToggleTodoSuccess() throws {
		let mockCoreData = MockCoreDataManager()
		try mockCoreData.saveTodo(TodoItem(id: 1, todo: "Buy milk", completed: false, userId: 1))

		let viewModel = MainListVM(networkAgent: MockNetworkAgent(), coreDataManager: mockCoreData)
		try viewModel.loadFromCoreData()

		viewModel.toggleTodo(TodoItem(id: 1, todo: "Buy milk", completed: false, userId: 1))

		#expect(viewModel.todos.first?.completed == true)
	}

	@Test func testToggleTodoFailure() throws {
		let mockCoreData = MockCoreDataManager()
		mockCoreData.shouldThrowToggleError = true
		try mockCoreData.saveTodo(TodoItem(id: 1, todo: "Buy milk", completed: false, userId: 1))

		let viewModel = MainListVM(networkAgent: MockNetworkAgent(), coreDataManager: mockCoreData)
		try viewModel.loadFromCoreData()

		viewModel.toggleTodo(TodoItem(id: 1, todo: "Buy milk", completed: false, userId: 1))

		#expect(viewModel.todos.first?.completed == true)
	}

	@Test func testToggleTodoWithMissingItem() throws {
		let mockCoreData = MockCoreDataManager()
		mockCoreData.shouldThrowToggleError = true

		let viewModel = MainListVM(networkAgent: MockNetworkAgent(), coreDataManager: mockCoreData)
		try viewModel.loadFromCoreData()

		let missingItem = TodoItem(id: 999, todo: "Ghost", completed: false, userId: 1)
		viewModel.toggleTodo(missingItem)

		#expect(viewModel.todos.isEmpty)
	}

	@Test func testDeleteTaskSuccess() throws {
		let mockNetwork = MockNetworkAgent()
		let mockCoreData = MockCoreDataManager()

		try mockCoreData.saveTodos([
			TodoItem(id: 1, todo: "Buy milk", completed: false, userId: 1),
			TodoItem(id: 2, todo: "Buy bread", completed: true, userId: 1),
			TodoItem(id: 3, todo: "Walk dog", completed: false, userId: 1),
		])

		let viewModel = MainListVM(networkAgent: mockNetwork, coreDataManager: mockCoreData)
		try viewModel.loadFromCoreData()

		#expect(viewModel.todos.count == 3)
		try viewModel.deleteTodo(TodoItem(id: 2, todo: "Buy bread", completed: true, userId: 1))
		#expect(viewModel.todos.count == 2)
	}

	@Test func testDeleteTodoFailure() throws {
		let mockCoreData = MockCoreDataManager()
		try mockCoreData.saveTodos([
			TodoItem(id: 1, todo: "Buy milk", completed: false, userId: 1),
			TodoItem(id: 2, todo: "Buy bread", completed: true, userId: 1),
			TodoItem(id: 3, todo: "Walk dog", completed: false, userId: 1),
		])

		let viewModel = MainListVM(networkAgent: MockNetworkAgent(), coreDataManager: mockCoreData)
		try viewModel.loadFromCoreData()

		#expect(viewModel.todos.count == 3)
		#expect(
			throws: CoreDataErrors.self,
			performing: {
				try viewModel.deleteTodo(TodoItem(id: 5, todo: "123", completed: true, userId: 1))
			})
		#expect(viewModel.todos.count == 3)
	}

	@Test func testDeleteAllTodosFailure() throws {
		let mockCoreData = MockCoreDataManager()
		mockCoreData.shouldThrowDeleteAllError = true
		try mockCoreData.saveTodos([
			TodoItem(id: 1, todo: "Buy milk", completed: false, userId: 1)
		])

		let viewModel = MainListVM(networkAgent: MockNetworkAgent(), coreDataManager: mockCoreData)
		try viewModel.loadFromCoreData()

		viewModel.deleteAllTodosFromCoreData()

		#expect(viewModel.todos.isEmpty)
	}
}
