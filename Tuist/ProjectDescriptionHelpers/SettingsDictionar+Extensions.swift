//
//  SettingsDictionar+Extensions.swift
//  Manifests
//
//  Created by Antonio on 19/10/25.
//

import ProjectDescription

public extension SettingsDictionary {
    
    static let developmentTeam: Self = [
        "CODE_SIGN_STYLE": "Automatic",
        "DEVELOPMENT_TEAM": .string(
            Environment.developmentTeam.getString(
                default: ""
            )
        )
    ]
    
    static let approachableConcurrency: Self = [
        "SWIFT_VERSION": "6.0",
        "SWIFT_DEFAULT_ACTOR_ISOLATION": "MainActor",
        "SWIFT_STRICT_CONCURRENCY": "complete",
        "SWIFT_APPROACHABLE_CONCURRENCY": "YES",
    ]
    
    static let xcodeRecommendedSettings: Self = [
        "ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": "YES",
        "ENABLE_USER_SCRIPT_SANDBOXING": "YES",
        "STRING_CATALOG_GENERATE_SYMBOLS": "YES",
        "ENABLE_MODULE_VERIFIER": "YES",
        "MODULE_VERIFIER_SUPPORTED_LANGUAGE_STANDARDS": "gnu11 gnu++14",
    ]
    
    static func version(semVer: String, buildNumber: String) -> Self {[
        "MARKETING_VERSION": .string(semVer),
        "CURRENT_PROJECT_VERSION": .string(buildNumber),   
    ]}
}
