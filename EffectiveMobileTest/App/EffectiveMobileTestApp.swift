import SwiftUI

@main
struct EffectiveMobileTestApp: App {
	@StateObject private var router = Router()

	var body: some Scene {
		WindowGroup {
			NavigationStack(path: $router.path) {
				MainListView()
					.navigationDestination(for: Route.self) { route in route.view }
			}
			.environmentObject(router)
		}
	}
}
