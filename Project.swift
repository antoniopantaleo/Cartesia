import ProjectDescription
import ProjectDescriptionHelpers

let appName = "Cartesia"
let marketingVersion = "1.0.0"
let buildNumber = "1"
let bundlePrefix = Environment.bundlePrefix.getString(default: "")

let project = Project(
    name: appName,
    targets: .build {
        µFeature("Start")
//        µFeature("Game")
        Target.target(
            name: "Domain",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(bundlePrefix).\(appName).Domain",
            deploymentTargets: .iOS("18.0"),
            sources: ["Modules/Domain/Sources/**"],
            settings: .settings(
                base: SettingsDictionary()
                    .merging(.xcodeRecommendedSettings)
                    .merging(.approachableConcurrency)
            )
        )
        Target.target(
            name: "Application",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(bundlePrefix).\(appName).Application",
            deploymentTargets: .iOS("18.0"),
            sources: ["Modules/Application/Sources/**"],
            dependencies: [
                .target(name: "Domain")
            ],
            settings: .settings(
                base: SettingsDictionary()
                    .merging(.xcodeRecommendedSettings)
                    .merging(.approachableConcurrency)
            )
        )
        Target.target(
            name: "Infrastructure",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(bundlePrefix).\(appName).Infrastracture",
            deploymentTargets: .iOS("18.0"),
            sources: ["Modules/Infrastructure/Sources/**"],
            dependencies: [
                .target(name: "Domain")
            ],
            settings: .settings(
                base: SettingsDictionary()
                    .merging(.xcodeRecommendedSettings)
                    .merging(.approachableConcurrency)
            )
        )
        Target.target(
            name: "Presentation",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(bundlePrefix).\(appName).Presentation",
            deploymentTargets: .iOS("18.0"),
            sources: ["Modules/Presentation/Sources/**"],
            resources: ["Modules/Presentation/Resources/**"],
            dependencies: [
                .target(name: "Domain")
            ],
            settings: .settings(
                base: SettingsDictionary()
                    .merging(.xcodeRecommendedSettings)
                    .merging(.approachableConcurrency)
            )
        )
        Target.target(
            name: appName,
            destinations: .iOS,
            product: .app,
            bundleId: "\(bundlePrefix).\(appName)",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .extendingDefault(
                with: [
                    "CFBundleShortVersionString": .string("$(MARKETING_VERSION)"),
                    "CFBundleVersion": .string("$(CURRENT_PROJECT_VERSION)"),
                    "UIApplicationSceneManifest": .dictionary([
                        "UIApplicationSupportsMultipleScenes": .boolean(false),
                        "UISceneConfigurations": .dictionary([:])
                    ]),
                    "UIApplicationSupportsIndirectInputEvents": .boolean(true),
                    "UILaunchScreen": .dictionary([:]),
                    "UISupportedInterfaceOrientations": .array([
                        .string("UIInterfaceOrientationPortrait")
                    ]),
                    "MKDirectionsApplicationSupportedModes": .array([])
                ]
            ),
            sources: ["\(appName)/**"],
            resources: [
                "\(appName)/Assets.xcassets/**",
                "\(appName)/Preview Content/**",
                "\(appName)/**/*.icon"
            ],
            dependencies: [
                .target(name: "Domain"),
                .target(name: "Application"),
                .target(name: "Infrastructure"),
                .target(name: "Presentation"),
                .target(name: "Start"),
                .target(name: "StartInterface"),
            ],
            settings: .settings(
                base: SettingsDictionary()
                    .merging(.xcodeRecommendedSettings)
                    .merging(.approachableConcurrency)
                    .merging(
                        .version(
                            semVer: marketingVersion,
                            buildNumber: buildNumber
                        )
                    )
                    .merging(.developmentTeam)
                    .merging(
                        ["ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
                         "INFOPLIST_KEY_CFBundleDisplayName": .string(appName),
                         "ASSETCATALOG_COMPILER_INCLUDE_ALL_APPICON_ASSETS": "YES",
                         "TARGETED_DEVICE_FAMILY": "1",
                         "ENABLE_PREVIEWS": "YES",
                         "DEVELOPMENT_ASSET_PATHS": "\"\(appName)/Preview Content\""
                        ])
            )
        )
    }
)
