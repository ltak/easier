import SwiftUI
import APIClient
import DesignSystem

@main
struct EasierApp: App {
    private let api = StubFoodLoggingAPI()

    var body: some Scene {
        WindowGroup {
            FoodLoggingDashboardView(viewModel: FoodLoggingDashboardViewModel(api: api))
                .background(EasierTheme.canvas)
        }
    }
}
