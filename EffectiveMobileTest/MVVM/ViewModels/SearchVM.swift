import CoreData

final class SearchViewModel: ObservableObject {
	@Published var todos: [TodoItem] = []
	@Published var searchQuery: String = ""

	private let coreDataManager = CoreDataManager.shared

	func searchTasks(by query: String) throws {
		todos = try coreDataManager.searchTodo(by: query)
	}
}
