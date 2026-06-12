//
//  µFeature.swift
//  Manifests
//
//  Created by Antonio on 29/10/25.
//

import ProjectDescription

public func µFeature(_ name: String) -> [Target] {
    [
        .target(
            name: name,
            destinations: .iOS,
            product: .framework,
            bundleId: "com.antoniopantaleo.\(name)",
            deploymentTargets: .iOS("18.0"),
            sources: ["\(name)/\(name)/Sources/**"],
            resources: ["\(name)/\(name)/Resources/**"],
            dependencies: [
                .target(name: name + "Interface"),
                .target(name: name + "Testing"),
            ],
            settings: .settings(base: SettingsDictionary())
        ),
        .target(
            name: name + "Interface",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.antoniopantaleo.\(name + "Interface")",
            deploymentTargets: .iOS("18.0"),
            sources: ["\(name)/\(name + "Interface")/Sources/**"],
        ),
        .target(
            name: name + "Tests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.antoniopantaleo.\(name + "Tests")",
            deploymentTargets: .iOS("18.0"),
            sources: ["\(name)/\(name + "Tests")/Sources/**"],
            dependencies: [
                .target(name: name),
                .target(name: name + "Interface"),
                .target(name: name + "Testing")
            ]
        ),
        .target(
            name: name + "Testing",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.antoniopantaleo.\(name + "Testing")",
            deploymentTargets: .iOS("18.0"),
            sources: ["\(name)/\(name + "Testing")/Sources/**"],
            resources: ["\(name)/\(name + "Testing")/Resources/**"],
            dependencies: [
                .target(name: name + "Interface")
            ]
        ),
        .target(
            name: name + "Example",
            destinations: .iOS,
            product: .app,
            bundleId: "com.antoniopantaleo.\(name + "Example")",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .extendingDefault(with: [
                "UIApplicationSceneManifest": .dictionary([
                    "UIApplicationSupportsMultipleScenes": .boolean(false),
                    "UISceneConfigurations": .dictionary([:])
                ])
            ]),
            sources: ["\(name)/\(name + "Example")/Sources/**"],
            resources: ["\(name)/\(name + "Example")/Resources/**"],
            dependencies: [
                .target(name: name),
                .target(name: name + "Testing")
            ],
            settings: .settings(
                base: SettingsDictionary()
                    .merging([
                        "TARGETED_DEVICE_FAMILY": "1",
                    ])
            )
        )
    ]
}

