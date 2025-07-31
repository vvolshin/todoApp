protocol CoreDataManagerProtocol {
    func saveTodos(_ items: [TodoItem]) throws
    func saveTodo(_ item: TodoItem) throws
    func fetchTodos() throws -> [TodoItem]
    func updateTodo(_ todo: TodoItem, newTodo: String) throws
    func toggleTodoCompletion(_ todo: TodoItem) throws
    func searchTodo(by keywords: String) throws -> [TodoItem]
    func deleteTodo(_ todo: TodoItem) throws
    func deleteAllTodos() throws
}
