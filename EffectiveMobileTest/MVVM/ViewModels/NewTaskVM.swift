import CoreData

final class NewTaskVM: ObservableObject {
    @Published var todos: [TodoItem] = []
    private let coreDataManager: CoreDataManagerProtocol
    
    init(coreDataManager: CoreDataManagerProtocol = CoreDataManager.shared) {
        self.coreDataManager = coreDataManager
    }

	func saveTaskToCoreData(_ task: TodoItem) throws {
        try coreDataManager.saveTodo(task)
	}
    
    func loadFromCoreData() throws {
        todos = try coreDataManager.fetchTodos()
    }
}
