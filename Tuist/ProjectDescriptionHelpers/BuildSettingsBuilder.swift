//
//  BuildSettingsBuilder.swift
//  Manifests
//
//  Created by Antonio on 19/10/25.
//

import ProjectDescription

@resultBuilder
public enum BuildSettingsBuilder {
    public static func buildBlock(_ components: SettingsDictionary...) -> SettingsDictionary {
        components.reduce(into: SettingsDictionary()) { partialResult, settings in
            partialResult.merge(settings) { first, last in last }
        }
    }
    
//    public static func buildExpression(_ expression: SettingsDictionary) -> SettingsDictionary {
//        expression
//    }
    
//    public static func buildExpression(_ expression: KeyPath<SettingsDictionary.Type, SettingsDictionary>) -> SettingsDictionary {
//        SettingsDictionary.self[keyPath: expression]
//    }
}

extension SettingsDictionary {
    public static func builder(@BuildSettingsBuilder _ builder: () -> SettingsDictionary) -> SettingsDictionary {
        builder()
    }
}
