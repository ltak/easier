import SwiftUI
import NutritionDomain
import DesignSystem

struct FoodLoggingDashboardView: View {
    @StateObject var viewModel: FoodLoggingDashboardViewModel
    @State private var isPresentingEditor = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    summaryCard
                    satietyCard
                    issuesCard
                    suggestionsCard
                }
                .padding(20)
            }
            .navigationTitle("Today")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Edit Meal") {
                        isPresentingEditor = true
                    }
                }
            }
            .sheet(isPresented: $isPresentingEditor) {
                MealEditorView(
                    mealName: viewModel.currentAnalysis.mealName,
                    components: viewModel.currentAnalysis.components,
                    onSave: { updatedComponents in
                        viewModel.update(components: updatedComponents)
                        isPresentingEditor = false
                    }
                )
            }
        }
    }

    private var summaryCard: some View {
        card(title: "Lunch Bowl") {
            VStack(alignment: .leading, spacing: 8) {
                metricRow(label: "Calories", value: Int(viewModel.currentAnalysis.totals.calories).description)
                metricRow(label: "Protein", value: "\(Int(viewModel.currentAnalysis.totals.proteinGrams))g")
                metricRow(label: "Fiber", value: "\(Int(viewModel.currentAnalysis.totals.fiberGrams))g")
            }
        }
    }

    private var satietyCard: some View {
        card(title: "Satiety") {
            VStack(alignment: .leading, spacing: 8) {
                Text("\(viewModel.currentAnalysis.satiety.overallScore)/100")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundStyle(EasierTheme.accent)
                Text("Where hunger is likely headed based on protein, fiber, energy density, and processed load.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var issuesCard: some View {
        card(title: "What To Watch") {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(viewModel.currentAnalysis.issues) { issue in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(issue.title)
                            .font(.headline)
                        Text(issue.detail)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }

    private var suggestionsCard: some View {
        card(title: "Best Next Change") {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(viewModel.currentAnalysis.suggestions) { suggestion in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(suggestion.title)
                            .font(.headline)
                        Text(suggestion.detail)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }

    private func metricRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
        }
    }

    private func card<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title)
                .font(.headline)
                .foregroundStyle(EasierTheme.ink)
            content()
        }
        .padding(18)
        .background(EasierTheme.panel, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}
