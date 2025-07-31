import CoreData

final class SearchVM: ObservableObject {
	@Published var todos: [TodoItem] = []
	@Published var searchQuery: String = ""

    private let coreDataManager: CoreDataManagerProtocol
    
    init(coreDataManager: CoreDataManagerProtocol = CoreDataManager.shared) {
        self.coreDataManager = coreDataManager
    }

	func searchTasks(by query: String) throws {
		todos = try coreDataManager.searchTodo(by: query)
	}
}
