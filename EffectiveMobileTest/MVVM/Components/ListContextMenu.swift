import SwiftUI

struct TodoContextMenu: View {
    let todo: TodoItem
    let viewModel: MainListVM
    let router: Router

    var body: some View {
        Group {
            Button {
                router.go(to: .taskEditView(task: todo))
            } label: {
                Label("Редактировать", systemImage: "square.and.pencil")
            }

            ShareLink(item: todo.todo) {
                Label("Поделиться", systemImage: "square.and.arrow.up")
            }

            Button(role: .destructive) {
                withAnimation {
                    viewModel.deleteTodo(todo)
                }
            } label: {
                Label("Удалить", systemImage: "trash")
            }
        }
    }
}
