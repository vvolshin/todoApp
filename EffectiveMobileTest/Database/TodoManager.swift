import Combine
import CoreData

final class TodoManager {
	static let shared = TodoManager()
	private init() {}

	private var cancellables = Set<AnyCancellable>()

	func fetchAndStoreTodos() {
		NetworkAgent.shared.fetchTodos()
			.receive(on: DispatchQueue.main)
			.sink(
				receiveCompletion: { completion in
					if case let .failure(error) = completion {
						print("❌ Error fetching todos: \(error)")
					}
				},
				receiveValue: { todos in
					let context = CoreDataManager.shared.context
					todos.forEach { todoData in
						let todo = TodoEntity(context: context)
						todo.id = Int64(todoData.id)
						todo.todo = todoData.todo
						todo.completed = todoData.completed
						todo.userId = Int64(todoData.userId)
					}
					CoreDataManager.shared.saveContext()
					print("✅ Saved \(todos.count) todos")
				}
			)
			.store(in: &cancellables)
	}
}
