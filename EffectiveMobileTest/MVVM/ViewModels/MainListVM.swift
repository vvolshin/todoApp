import Combine
import CoreData

final class MainListVM: ObservableObject {
	@Published var todos: [TodoItem] = []

	private var cancellables = Set<AnyCancellable>()
	private let coreDataManager: CoreDataManagerProtocol
	private let networkAgent: NetworkAgentProtocol

	init(
		networkAgent: NetworkAgentProtocol = NetworkAgent.shared,
		coreDataManager: CoreDataManagerProtocol = CoreDataManager.shared
	) {
		self.networkAgent = networkAgent
		self.coreDataManager = coreDataManager
	}

	func fetchAndStoreTodos() {
		networkAgent.fetchTodos()
			.subscribe(on: DispatchQueue.global(qos: .background))
			.handleEvents(receiveOutput: { [weak self] (items: [TodoItem]) in
				guard let self = self else { return }
				do {
					try coreDataManager.saveTodos(items)
				}
				catch {
					print(CoreDataErrors.failedToSave(error).description)
				}
			})
			.receive(on: DispatchQueue.main)
			.sink { completion in
				if case let .failure(error) = completion {
					print("Network Fetch Error: \(error.description)")
				}
			} receiveValue: { [weak self] items in
				self?.todos = items
			}
			.store(in: &cancellables)
	}

    func loadFromCoreData() throws {
        todos = try coreDataManager.fetchTodos()
    }

	func toggleTodo(_ todo: TodoItem) {
		if let index = todos.firstIndex(where: { $0.id == todo.id }) {
			todos[index].completed.toggle()
		}

		do {
			try coreDataManager.toggleTodoCompletion(todo)
		}
		catch {
			print(CoreDataErrors.failedToUpdate(error).description)
		}
	}

	func deleteAllTodosFromCoreData() {
		todos = []
		do {
			try coreDataManager.deleteAllTodos()
		}
		catch {
			print(CoreDataErrors.failedToDelete(error).description)
		}
	}

    func deleteTodo(_ todo: TodoItem) throws {
        try coreDataManager.deleteTodo(todo)
        todos.removeAll(where: { $0.id == todo.id })
    }
}
