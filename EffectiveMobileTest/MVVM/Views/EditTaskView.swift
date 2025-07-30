import SwiftUI

struct EditTaskView: View {
	@EnvironmentObject var router: Router
	@StateObject private var viewModel = EditTaskVM()
	@State private var todo: String = ""

	var task: TodoItem

    // MARK: - Body
	var body: some View {
		ScrollView {
			HStack {
				Text("\(task.id)")
					.font(.system(size: 34))
					.fontWeight(.bold)
					.foregroundStyle(.white)
				Spacer()
			}
			.padding(.horizontal)

			HStack {
				Text(task.date.formatDate())
					.font(.system(size: 12))
					.foregroundStyle(.secondary)
				Spacer()
			}
			.padding(.horizontal)

			TextEditor(text: $todo)
		}
		.padding()
		.ignoresSafeArea(.keyboard)
		.editViewToolbar(
			onBack: { router.goBack() },
            onSave: {
                viewModel.updateTodo(task, newTodo: todo)
                router.goBack()
            })
        .onAppear {
            todo = task.todo
        }
	}
}

// MARK: - Preview
#Preview {
	NavigationStack {
        EditTaskView(task: TodoItem(id: 12, todo: "Do smth", completed: false, userId: 42))
			.environmentObject(Router())
	}
}
