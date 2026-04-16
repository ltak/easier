import SwiftUI
import NutritionDomain
import DesignSystem

struct MealEditorView: View {
    let mealName: String
    @State private var components: [MealComponent]
    let onSave: ([MealComponent]) -> Void

    init(mealName: String, components: [MealComponent], onSave: @escaping ([MealComponent]) -> Void) {
        self.mealName = mealName
        self._components = State(initialValue: components)
        self.onSave = onSave
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Components") {
                    ForEach($components) { $component in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(component.name)
                                .font(.headline)

                            HStack {
                                Text("Grams")
                                    .foregroundStyle(.secondary)
                                Spacer()
                                TextField("0", value: $component.grams, format: .number)
                                    .multilineTextAlignment(.trailing)
                                    .keyboardType(.numberPad)
                                    .frame(width: 80)
                            }

                            Text("\(Int(component.totals.calories)) kcal")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 6)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(EasierTheme.canvas)
            .navigationTitle(mealName)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        onSave(components)
                    }
                }
            }
        }
    }
}
