import CoreData

final class CoreDataManager: CoreDataManagerProtocol {
	static let shared = CoreDataManager()

	let container: NSPersistentContainer

	var context: NSManagedObjectContext {
		container.viewContext
	}

	private init() {
		container = NSPersistentContainer(name: "TodoModel")
		container.loadPersistentStores { description, error in
			if let error = error {
				assertionFailure("Error loading Core Data: \(error.localizedDescription)")
			}
		}
	}

	func saveContext() throws {
		if context.hasChanges {
			try context.save()
		}
	}

	func saveTodos(_ items: [TodoItem]) throws {
		for item in items {
			let entity = TodoEntity(context: context)
			entity.id = Int64(item.id)
			entity.todo = item.todo
			entity.completed = item.completed
			entity.userId = Int64(item.userId)
			entity.date = Date()
		}
		try saveContext()
	}

	func saveTodo(_ item: TodoItem) throws {
		let entity = TodoEntity(context: context)
		entity.id = Int64(item.id)
		entity.todo = item.todo
		entity.completed = item.completed
		entity.userId = Int64(item.userId)
		entity.date = Date()

		try saveContext()
	}

	func fetchTodos() throws -> [TodoItem] {
		let request: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
		request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
		let results = try context.fetch(request)
		return results.map {
			TodoItem(
				id: Int($0.id),
				todo: $0.todo ?? "",
				completed: $0.completed,
				userId: Int($0.userId),
				date: $0.date ?? Date()
			)
		}
	}

	func updateTodo(_ todo: TodoItem, newTodo: String) throws {
		let request: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
		request.predicate = NSPredicate(format: "id == %lld", todo.id)
		if let entity = try context.fetch(request).first {
			entity.todo = newTodo
			try saveContext()
		}
	}

	func toggleTodoCompletion(_ todo: TodoItem) throws {
		let request: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
		request.predicate = NSPredicate(format: "id == %lld", todo.id)
		if let entity = try context.fetch(request).first {
			entity.completed.toggle()
			try saveContext()
		}
	}

	func searchTodo(by keywords: String) throws -> [TodoItem] {
		let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()

		if !keywords.isEmpty {
			fetchRequest.predicate = NSPredicate(format: "todo CONTAINS[cd] %@", keywords)
		}

		let results = try context.fetch(fetchRequest)
		return results.map {
			TodoItem(
				id: Int($0.id),
				todo: $0.todo ?? "",
				completed: $0.completed,
				userId: Int($0.userId),
				date: $0.date ?? Date()
			)
		}
	}

	func deleteTodo(_ todo: TodoItem) throws {
		let request: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
		request.predicate = NSPredicate(format: "id == %d", todo.id)
		if let entity = try context.fetch(request).first {
			context.delete(entity)
			try saveContext()
		}
	}

	func deleteAllTodos() throws {
		let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TodoEntity.fetchRequest()
		let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
		try context.execute(deleteRequest)
		try saveContext()
	}
}
