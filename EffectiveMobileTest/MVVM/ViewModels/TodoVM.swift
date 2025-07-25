import Combine
import CoreData
import Foundation

final class TodoViewModel: ObservableObject {
    @Published var todos: [TodoItem] = []
    @Published var searchQuery: String = "" {
        didSet {
            searchTasks(by: searchQuery)
        }
    }

    private var cancellables = Set<AnyCancellable>()
    private let coreDataManager = CoreDataManager.shared

    func fetchAndStoreTodos() {
        NetworkAgent.shared.fetchTodos()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("✅ Finished fetching todos")
                case .failure(let error):
                    print("❌ Failed to fetch todos: \(error)")
                }
            } receiveValue: { [weak self] items in
                self?.todos = items
                self?.saveTodosToCoreData(items)
            }
            .store(in: &cancellables)
    }

    private func saveTodosToCoreData(_ items: [TodoItem]) {
        let context = coreDataManager.context

        for item in items {
            let entity = TodoEntity(context: context)
            entity.id = Int64(item.id)
            entity.todo = item.todo
            entity.completed = item.completed
            entity.userId = Int64(item.userId)
            entity.date = Date()
        }

        coreDataManager.saveContext()
        print("✅ Saved \(items.count) items to Core Data")
    }

    func loadFromCoreData() {
        let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()

        do {
            let results = try coreDataManager.context.fetch(fetchRequest)
            self.todos = results.map {
                TodoItem(id: Int($0.id), todo: $0.todo ?? "", completed: $0.completed, userId: Int($0.userId), date: $0.date ?? Date())
            }
        } catch {
            print("❌ Failed to load from Core Data: \(error)")
        }
    }
    
    func searchTasks(by query: String) {
        let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()

        if !query.isEmpty {
            fetchRequest.predicate = NSPredicate(format: "todo != nil AND todo CONTAINS[cd] %@", query)
        }

        do {
            let results = try coreDataManager.context.fetch(fetchRequest)
            self.todos = results.map {
                TodoItem(id: Int($0.id), todo: $0.todo ?? "", completed: $0.completed, userId: Int($0.userId), date: $0.date ?? Date())
            }
        } catch {
            print("❌ Failed to search Core Data: \(error)")
        }
    }
    
    func toggleTodo(_ todo: TodoItem) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index].completed.toggle()
        }
    }
    
    func deleteAllTodosFromCoreData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TodoEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try coreDataManager.context.execute(deleteRequest)
            try coreDataManager.context.save()
            self.todos = []
            print("🗑️ Удалены все задачи из Core Data")
        } catch {
            print("❌ Не удалось удалить задачи: \(error)")
        }
    }
    
    func deleteTodo(_ todo: TodoItem) {
        let context = coreDataManager.context
        let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", todo.id)

        do {
            let results = try context.fetch(fetchRequest)
            if let entityToDelete = results.first {
                context.delete(entityToDelete)
                try context.save()
                print("🗑️ Удалена задача с id: \(todo.id)")
                
                loadFromCoreData()
            } else {
                print("⚠️ Не найдена задача с id: \(todo.id)")
            }
        } catch {
            print("❌ Ошибка при удалении задачи: \(error)")
        }
    }
}
