import Foundation

final class Router: ObservableObject {
    @Published var path: [Route] = []
    func go(to route: Route) { self.path.append(route) }
    func goBack() { self.path.removeLast() }
    func goToMain() { self.path.removeAll() }
}
