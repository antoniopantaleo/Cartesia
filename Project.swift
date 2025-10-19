import ProjectDescription
import ProjectDescriptionHelpers

let marketingVersion = "1.0.0-alpha"
let buildNumber = "1"

let project = Project(
    name: "Pangea",
    targets: [
        .target(
            name: "Domain",
            destinations: .iOS,
            product: .framework,
            bundleId: ".Pangea.Domain",
            deploymentTargets: .iOS("18.0"),
            sources: ["Modules/Domain/Sources/**"],
            settings: .settings(
                base: SettingsDictionary()
                    .merging(.xcodeRecommendedSettings)
                    .merging(.approachableConcurrency)
            )
        ),
        .target(
            name: "Application",
            destinations: .iOS,
            product: .framework,
            bundleId: ".Pangea.Application",
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
        ),
        .target(
            name: "Infrastructure",
            destinations: .iOS,
            product: .framework,
            bundleId: ".Pangea.Infrastructure",
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
        ),
        .target(
            name: "Presentation",
            destinations: .iOS,
            product: .framework,
            bundleId: ".Pangea.Presentation",
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
        ),
        .target(
            name: "Pangea",
            destinations: .iOS,
            product: .app,
            bundleId: ".Pangea",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .file(path: "Pangea/Info.plist"),
            sources: ["Pangea/**"],
            resources: [
                "Pangea/Assets.xcassets/**",
                "Pangea/Preview Content/**",
                "Pangea/**/*.icon"
            ],
            dependencies: [
                .target(name: "Domain"),
                .target(name: "Application"),
                .target(name: "Infrastructure"),
                .target(name: "Presentation")
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
                    .merging(
                        ["ASSETCATALOG_COMPILER_APPICON_NAME": "Pangea",
                         "CODE_SIGN_STYLE": "Automatic",
                         "INFOPLIST_KEY_CFBundleDisplayName": "Pangea",
                         "TARGETED_DEVICE_FAMILY": "1",
                         "SUPPORTS_MACCATALYST": "NO",
                         "SUPPORTS_MAC_DESIGNED_FOR_IPHONE_IPAD": "NO",
                         "SUPPORTS_XR_DESIGNED_FOR_IPHONE_IPAD": "NO",
                         "INFOPLIST_KEY_UIApplicationSceneManifest_Generation": "YES",
                         "INFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents": "YES",
                         "INFOPLIST_KEY_UILaunchScreen_Generation": "YES",
                         "INFOPLIST_KEY_UISupportedInterfaceOrientations_iPad": "UIInterfaceOrientationPortrait UIInterfaceOrientationPortraitUpsideDown UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight",
                         "INFOPLIST_KEY_UISupportedInterfaceOrientations_iPhone": "UIInterfaceOrientationPortrait UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight",
                         "ENABLE_PREVIEWS": "YES",
                         "DEVELOPMENT_ASSET_PATHS": "\"Pangea/Preview Content\""
                        ])
                
            )
        )
    ]
)

