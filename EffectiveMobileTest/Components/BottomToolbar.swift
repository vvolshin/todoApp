import SwiftUI

struct BottomToolbarModifier: ViewModifier {
    let taskCount: Int
    let onNewTask: () -> Void

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    ZStack {
                        Text("\(taskCount) Задач")

                        HStack {
                            Spacer()

                            Button(action: onNewTask) {
                                Image(systemName: "square.and.pencil")
                                    .foregroundStyle(.yellow)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .toolbarBackground(.ownGray, for: .bottomBar)
            .toolbarBackgroundVisibility(.visible, for: .bottomBar)
    }
}

extension View {
    func bottomToolbar(taskCount: Int, onNewTask: @escaping () -> Void) -> some View {
        self.modifier(BottomToolbarModifier(taskCount: taskCount, onNewTask: onNewTask))
    }
}
