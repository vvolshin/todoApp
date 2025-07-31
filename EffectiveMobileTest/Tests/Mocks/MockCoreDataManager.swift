import CoreData
import Testing

@testable import EffectiveMobileTest

final class MockCoreDataManager: CoreDataManagerProtocol {
	private(set) var storedTodos: [TodoItem] = []

	var shouldThrowFetchError = false
	var shouldThrowToggleError = false
	var shouldThrowDeleteAllError = false
	var shouldThrowSaveError = false
	var shouldThrowUpdateError = false
	var didCallSaveTodos = false

	func saveTodos(_ todos: [TodoItem]) throws {
		didCallSaveTodos = true
		if shouldThrowSaveError {
			throw CoreDataErrors.failedToSave(NSError(domain: "Test", code: 1))
		}
		storedTodos = todos
	}

	func saveTodo(_ item: TodoItem) throws {
		if shouldThrowSaveError {
			throw CoreDataErrors.failedToSave(NSError(domain: "Test", code: 1))
		}
		storedTodos.append(item)
	}

	func updateTodo(_ todo: TodoItem, newTodo: String) throws {
        if shouldThrowUpdateError {
            throw CoreDataErrors.failedToUpdate(NSError(domain: "Test", code: 1))
        }
        
		guard let index = storedTodos.firstIndex(where: { $0.id == todo.id }) else {
			throw CoreDataErrors.todoNotFound
		}

		storedTodos[index].todo = newTodo
	}

	func toggleTodoCompletion(_ todo: TodoItem) throws {
		guard let index = storedTodos.firstIndex(where: { $0.id == todo.id }) else {
			throw CoreDataErrors.todoNotFound
		}
		storedTodos[index].completed.toggle()
	}

	func searchTodo(by keywords: String) throws -> [TodoItem] {
		if keywords == "throw" {
			throw CoreDataErrors.failedToSearch(NSError(domain: "Test", code: 1))
		}
		return storedTodos.filter { $0.todo.localizedCaseInsensitiveContains(keywords) }
	}

	func deleteTodo(_ todo: TodoItem) throws {
		guard let index = storedTodos.firstIndex(where: { $0.id == todo.id }) else {
			throw CoreDataErrors.todoNotFound
		}
		storedTodos.remove(at: index)
	}

	func fetchTodos() throws -> [TodoItem] {
		if shouldThrowFetchError {
			throw CoreDataErrors.failedToLoad(NSError(domain: "Test", code: -1))
		}
		return storedTodos
	}

	func deleteAllTodos() throws {
		if shouldThrowDeleteAllError {
			throw CoreDataErrors.failedToDelete(NSError(domain: "Test", code: -1))
		}
		storedTodos.removeAll()
	}

	var context: NSManagedObjectContext {
		fatalError("Not needed for mock")
	}
}
