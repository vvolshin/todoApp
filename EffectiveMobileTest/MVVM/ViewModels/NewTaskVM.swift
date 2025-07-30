import CoreData

final class NewTaskVM: ObservableObject {
	private let coreDataManager = CoreDataManager.shared

	func saveTaskToCoreData(_ task: TodoItem) {
		do {
			try coreDataManager.saveTodo(task)
		}
		catch {
			print(CoreDataErrors.failedToSave(error).description)
		}
	}
}
