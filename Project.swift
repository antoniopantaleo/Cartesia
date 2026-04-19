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
        µFeature("Game")
        µFeature("Result")
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
                    "MKDirectionsApplicationSupportedModes": .array([]),
                    "ITSAppUsesNonExemptEncryption": .boolean(false)
                ]
            ),
            sources: ["\(appName)/**"],
            resources: [
                "\(appName)/Assets.xcassets/**",
                "\(appName)/Preview Content/**",
                "\(appName)/**/*.icon",
                "\(appName)/PrivacyInfo.xcprivacy"
            ],
            dependencies: [
                .target(name: "Start"),
                .target(name: "StartInterface"),
                .target(name: "Game"),
                .target(name: "GameInterface"),
                .target(name: "Result"),
                .target(name: "ResultInterface"),
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
        Target.target(
            name: "\(appName)Tests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.antoniopantaleo.\(appName)Tests",
            deploymentTargets: .iOS("18.0"),
            sources: ["\(appName)Tests/Sources/**"],
            dependencies: [
                .target(name: appName),
                .target(name: "ResultInterface"),
                .target(name: "ResultTesting")
            ],
            settings: .settings(
                base: SettingsDictionary()
                    .merging(.approachableConcurrency)
            )
        )
    }
)
