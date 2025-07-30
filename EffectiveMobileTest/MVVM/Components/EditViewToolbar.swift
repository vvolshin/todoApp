import SwiftUI

struct EditViewToolbarModifier: ViewModifier {
	let onBack: () -> Void
	let onSave: () -> Void

	func body(content: Content) -> some View {
		content
			.navigationBarBackButtonHidden()
			.toolbar {
				ToolbarItem(placement: .topBarLeading) {
					Button(
						action: {
							onBack()
						},
						label: {
							HStack {
								Image(systemName: "chevron.backward")
								Text("Back")
							}
							.foregroundStyle(.yellow)
						})
				}

				ToolbarItem(placement: .topBarTrailing) {
					Button(
						action: {
							onSave()
						},
						label: {
							Text("Save")
								.foregroundStyle(.yellow)
						})
				}
			}
	}
}

extension View {
    func editViewToolbar(onBack: @escaping () -> Void, onSave: @escaping () -> Void) -> some View {
        self.modifier(EditViewToolbarModifier(onBack: onBack, onSave: onSave))
    }
}
