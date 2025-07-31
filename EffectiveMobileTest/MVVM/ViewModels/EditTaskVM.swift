import CoreData

final class EditTaskVM: ObservableObject {
    @Published var todos: [TodoItem] = []
	private let coreDataManager: CoreDataManagerProtocol

	init(coreDataManager: CoreDataManagerProtocol = CoreDataManager.shared) {
		self.coreDataManager = coreDataManager
	}

    func updateTodo(_ todo: TodoItem, newTodo: String) throws {
        try coreDataManager.updateTodo(todo, newTodo: newTodo)
    }
    
    func loadFromCoreData() throws {
        todos = try coreDataManager.fetchTodos()
    }
}
