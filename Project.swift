import ProjectDescription

let project = Project(
    name: "GeoGuesser",
    targets: [
        .target(
            name: "Core",
            destinations: .iOS,
            product: .framework,
            bundleId: ".GeoGuesser.Core",
            deploymentTargets: .iOS("18.0"),
            sources: ["Modules/Core/Sources/**"],
            settings: .settings(
                base: [
                    "SWIFT_VERSION": "6.0",
                    "SWIFT_STRICT_CONCURRENCY": "complete"
                ]
            )
        ),
        .target(
            name: "LocationServices",
            destinations: .iOS,
            product: .framework,
            bundleId: ".GeoGuesser.LocationServices",
            deploymentTargets: .iOS("18.0"),
            sources: ["Modules/LocationServices/Sources/**"],
            dependencies: [
                .target(name: "Core")
            ],
            settings: .settings(
                base: [
                    "SWIFT_VERSION": "6.0",
                    "SWIFT_STRICT_CONCURRENCY": "complete"
                ]
            )
        ),
        .target(
            name: "StartScreen",
            destinations: .iOS,
            product: .framework,
            bundleId: ".GeoGuesser.StartScreen",
            deploymentTargets: .iOS("18.0"),
            sources: ["Modules/StartScreen/Sources/**"],
            resources: ["Modules/StartScreen/Resources/**"],
            dependencies: [],
            settings: .settings(
                base: [
                    "SWIFT_VERSION": "6.0",
                    "SWIFT_STRICT_CONCURRENCY": "complete"
                ]
            )
        ),
        .target(
            name: "GameEngine",
            destinations: .iOS,
            product: .framework,
            bundleId: ".GeoGuesser.GameEngine",
            deploymentTargets: .iOS("18.0"),
            sources: ["Modules/GameEngine/Sources/**"],
            dependencies: [
                .target(name: "Core")
            ],
            settings: .settings(
                base: [
                    "SWIFT_VERSION": "6.0",
                    "SWIFT_STRICT_CONCURRENCY": "complete"
                ]
            )
        ),
        .target(
            name: "GeoGuesser",
            destinations: .iOS,
            product: .app,
            bundleId: ".GeoGuesser",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .file(path: "GeoGuesser/Info.plist"),
            sources: ["GeoGuesser/**"],
            resources: ["GeoGuesser/Assets.xcassets/**", "GeoGuesser/Preview Content/**"],
            dependencies: [
                .target(name: "Core"),
                .target(name: "GameEngine"),
                .target(name: "LocationServices"),
                .target(name: "StartScreen")
            ],
            settings: .settings(
                base: [
                    "CODE_SIGN_STYLE": "Automatic",
                    "INFOPLIST_KEY_CFBundleDisplayName": "Pinpoint",
                    "SWIFT_VERSION": "6.0",
                    "SWIFT_STRICT_CONCURRENCY": "complete",
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
                    "DEVELOPMENT_ASSET_PATHS": "\"GeoGuesser/Preview Content\""
                ]
            )
        )
    ]
)
