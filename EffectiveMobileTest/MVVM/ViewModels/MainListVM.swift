import Combine
import CoreData

final class MainListVM: ObservableObject {
	@Published var todos: [TodoItem] = []

	private var cancellables = Set<AnyCancellable>()
	private let coreDataManager = CoreDataManager.shared

	func fetchAndStoreTodos() {
		NetworkAgent.shared.fetchTodos()
			.subscribe(on: DispatchQueue.global(qos: .background))
			.handleEvents(receiveOutput: { [weak self] items in
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

	func loadFromCoreData() {
		do {
			todos = try coreDataManager.fetchTodos()
		}
		catch {
			print(CoreDataErrors.failedToLoad(error).description)
		}
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

	func deleteTodo(_ todo: TodoItem) {
		todos.removeAll { $0.id == todo.id }
		do {
			try coreDataManager.deleteTodo(todo)
		}
		catch {
			print(CoreDataErrors.failedToDelete(error).description)
		}
	}
}
