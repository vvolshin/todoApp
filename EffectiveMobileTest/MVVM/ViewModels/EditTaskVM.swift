import CoreData

final class EditTaskVM: ObservableObject {
	private let coreDataManager = CoreDataManager.shared
    
    func updateTodo(_ todo: TodoItem, newTodo: String) {
        do {
            try coreDataManager.updateTodo(todo, newTodo: newTodo)
        } catch {
            print(CoreDataErrors.failedToUpdate(error).description)
        }
    }
}
