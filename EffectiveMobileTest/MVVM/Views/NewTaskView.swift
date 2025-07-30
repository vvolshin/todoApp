import SwiftUI

struct NewTaskView: View {
	@EnvironmentObject var router: Router
	@StateObject private var viewModel = NewTaskVM()

	@State private var todoText: String = ""
	@FocusState private var isFocused: Bool

    // MARK: - Body
	var body: some View {
		VStack {
			TextEditor(text: $todoText)
				.focused($isFocused)
				.scrollIndicators(.hidden)

			Spacer()
		}
		.padding()
		.ignoresSafeArea(.keyboard)
		.onAppear {
			isFocused = true
		}
		.editViewToolbar(
			onBack: { router.goBack() },
			onSave: {
				saveAction()
			}
		)
	}
}

// MARK: - Methods
extension NewTaskView {
	private func saveAction() {
		guard !todoText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

		let task = TodoItem(
			id: Int.random(in: Int.min...Int.max),
			todo: todoText,
			completed: false,
			userId: Int.random(in: Int.min...Int.max)
		)

        viewModel.saveTaskToCoreData(task)
		router.goBack()
	}
}

// MARK: - Preview
#Preview {
	NavigationStack {
		NewTaskView()
			.environmentObject(Router())
	}
}
