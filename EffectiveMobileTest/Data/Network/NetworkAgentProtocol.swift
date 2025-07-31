import Combine

protocol NetworkAgentProtocol {
    func fetchTodos() -> AnyPublisher<[TodoItem], NetworkErrors>
}
