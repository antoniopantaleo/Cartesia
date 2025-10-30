//
//  TargetsBuilder.swift
//  Manifests
//
//  Created by Antonio on 29/10/25.
//

import ProjectDescription

@resultBuilder
public enum TargetsBuilder {
    public static func buildBlock(_ components: [Target]...) -> [Target] {
        components.flatMap { $0 }
    }
    
    public static func buildExpression(_ expression: Target) -> [Target] {
        [expression]
    }
    
    public static func buildExpression(_ expression: [Target]) -> [Target] {
        expression
    }
}

public extension [Target] {
    static func build(@TargetsBuilder builder: () -> [Target]) -> [Target] {
        builder()
    }
}
