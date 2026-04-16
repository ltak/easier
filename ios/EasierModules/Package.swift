// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "EasierModules",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "EasierDomain", targets: ["EasierDomain"]),
        .library(name: "NutritionDomain", targets: ["NutritionDomain"]),
        .library(name: "GoalDomain", targets: ["GoalDomain"]),
        .library(name: "TrainingDomain", targets: ["TrainingDomain"]),
        .library(name: "CoachingDomain", targets: ["CoachingDomain"]),
        .library(name: "APIClient", targets: ["APIClient"]),
        .library(name: "DesignSystem", targets: ["DesignSystem"])
    ],
    targets: [
        .target(name: "EasierDomain"),
        .target(name: "NutritionDomain", dependencies: ["EasierDomain"]),
        .target(name: "GoalDomain", dependencies: ["EasierDomain"]),
        .target(name: "TrainingDomain", dependencies: ["EasierDomain"]),
        .target(name: "CoachingDomain", dependencies: ["EasierDomain"]),
        .target(name: "APIClient", dependencies: ["NutritionDomain", "GoalDomain", "TrainingDomain", "CoachingDomain"]),
        .target(name: "DesignSystem"),
        .testTarget(name: "NutritionDomainTests", dependencies: ["NutritionDomain"])
    ]
)
