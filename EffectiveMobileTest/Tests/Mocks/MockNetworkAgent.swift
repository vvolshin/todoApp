import Combine
import Testing
@testable import EffectiveMobileTest

final class MockNetworkAgent: NetworkAgentProtocol {
    var todosToReturn: [TodoItem]? = nil
    var errorToReturn: NetworkErrors? = nil

    func fetchTodos() -> AnyPublisher<[TodoItem], NetworkErrors> {
        if let error = errorToReturn {
            return Fail(error: error).eraseToAnyPublisher()
        } else {
            return Just(todosToReturn ?? [])
                .setFailureType(to: NetworkErrors.self)
                .eraseToAnyPublisher()
        }
    }
}
