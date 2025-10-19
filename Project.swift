import ProjectDescription

let marketingVersion = "1.0.0-alpha"
let buildNumber = "1"

let project = Project(
    name: "GeoGuesser",
    targets: [
        .target(
            name: "GeoDomain",
            destinations: .iOS,
            product: .framework,
            bundleId: ".GeoGuesser.Core",
            deploymentTargets: .iOS("18.0"),
            sources: ["Modules/Domain/Sources/**"],
            settings: .settings(
                base: [
                    "SWIFT_VERSION": "6.0",
                    "SWIFT_STRICT_CONCURRENCY": "complete",
                    "SWIFT_DEFAULT_ACTOR_ISOLATION": "MainActor",
                    "SWIFT_APPROACHABLE_CONCURRENCY": "YES",
                    "ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": "YES",
                    "ENABLE_USER_SCRIPT_SANDBOXING": "YES",
                    "STRING_CATALOG_GENERATE_SYMBOLS": "YES",
                    "ENABLE_MODULE_VERIFIER": "YES",
                    "MODULE_VERIFIER_SUPPORTED_LANGUAGE_STANDARDS": "gnu11 gnu++14",
                ]
            )
        ),
        .target(
            name: "GeoApplication",
            destinations: .iOS,
            product: .framework,
            bundleId: ".GeoGuesser.LocationServices",
            deploymentTargets: .iOS("18.0"),
            sources: ["Modules/Application/Sources/**"],
            dependencies: [
                .target(name: "GeoDomain")
            ],
            settings: .settings(
                base: [
                    "SWIFT_VERSION": "6.0",
                    "SWIFT_STRICT_CONCURRENCY": "complete",
                    "SWIFT_DEFAULT_ACTOR_ISOLATION": "MainActor",
                    "SWIFT_APPROACHABLE_CONCURRENCY": "YES",
                    "ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": "YES",
                    "ENABLE_USER_SCRIPT_SANDBOXING": "YES",
                    "STRING_CATALOG_GENERATE_SYMBOLS": "YES",
                    "ENABLE_MODULE_VERIFIER": "YES",
                    "MODULE_VERIFIER_SUPPORTED_LANGUAGE_STANDARDS": "gnu11 gnu++14",
                ]
            )
        ),
        .target(
            name: "GeoInfrastructure",
            destinations: .iOS,
            product: .framework,
            bundleId: ".GeoGuesser.StartScreen",
            deploymentTargets: .iOS("18.0"),
            sources: ["Modules/Infrastructure/Sources/**"],
            dependencies: [
                .target(name: "GeoDomain")
            ],
            settings: .settings(
                base: [
                    "SWIFT_VERSION": "6.0",
                    "SWIFT_STRICT_CONCURRENCY": "complete",
                    "SWIFT_DEFAULT_ACTOR_ISOLATION": "MainActor",
                    "SWIFT_APPROACHABLE_CONCURRENCY": "YES",
                    "ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": "YES",
                    "ENABLE_USER_SCRIPT_SANDBOXING": "YES",
                    "STRING_CATALOG_GENERATE_SYMBOLS": "YES",
                    "ENABLE_MODULE_VERIFIER": "YES",
                    "MODULE_VERIFIER_SUPPORTED_LANGUAGE_STANDARDS": "gnu11 gnu++14",
                ]
            )
        ),
        .target(
            name: "GeoPresentation",
            destinations: .iOS,
            product: .framework,
            bundleId: ".GeoGuesser.GameEngine",
            deploymentTargets: .iOS("18.0"),
            sources: ["Modules/Presentation/Sources/**"],
            resources: ["Modules/Presentation/Resources/**"],
            dependencies: [
                .target(name: "GeoDomain")
            ],
            settings: .settings(
                base: [
                    "SWIFT_VERSION": "6.0",
                    "SWIFT_STRICT_CONCURRENCY": "complete",
                    "SWIFT_DEFAULT_ACTOR_ISOLATION": "MainActor",
                    "SWIFT_APPROACHABLE_CONCURRENCY": "YES",
                    "ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": "YES",
                    "ENABLE_USER_SCRIPT_SANDBOXING": "YES",
                    "STRING_CATALOG_GENERATE_SYMBOLS": "YES",
                    "ENABLE_MODULE_VERIFIER": "YES",
                    "MODULE_VERIFIER_SUPPORTED_LANGUAGE_STANDARDS": "gnu11 gnu++14",
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
            resources: [
                "GeoGuesser/Assets.xcassets/**",
                "GeoGuesser/Preview Content/**",
                "GeoGuesser/**/*.icon"
            ],
            dependencies: [
                .target(name: "GeoDomain"),
                .target(name: "GeoApplication"),
                .target(name: "GeoInfrastructure"),
                .target(name: "GeoPresentation")
            ],
            settings: .settings(
                base: [                    "MARKETING_VERSION": .string(marketingVersion),
                    "CURRENT_PROJECT_VERSION": .string(buildNumber),
"ASSETCATALOG_COMPILER_APPICON_NAME": "Pangea",
                    "ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": "YES",
                    "ENABLE_USER_SCRIPT_SANDBOXING": "YES",
                    "STRING_CATALOG_GENERATE_SYMBOLS": "YES",
                    "ENABLE_MODULE_VERIFIER": "YES",
                    "MODULE_VERIFIER_SUPPORTED_LANGUAGE_STANDARDS": "gnu11 gnu++14",
                    "SWIFT_DEFAULT_ACTOR_ISOLATION": "MainActor",
                    "SWIFT_APPROACHABLE_CONCURRENCY": "YES",
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
