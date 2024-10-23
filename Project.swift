import ProjectDescription

let project = Project(
    name: "GeoGuesser",
    targets: [
        .target(
            name: "GeoGuesser",
            destinations: .iOS,
            product: .app,
            bundleId: ".GeoGuesser",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .file(path: "GeoGuesser/Info.plist"),
            sources: ["GeoGuesser/**"],
            resources: ["GeoGuesser/Assets.xcassets/**", "GeoGuesser/Preview Content/**"],
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
