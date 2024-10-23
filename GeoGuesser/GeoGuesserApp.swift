//
//  GeoGuesserApp.swift
//  GeoGuesser
//
//  Created by Antonio on 19/10/24.
//

import SwiftUI

@main
struct GeoGuesserApp: App {
    let now = Date.now
    let viewModel = GameViewModel()
    
    init() {
        UIViewController.swizzleViewWillAppear()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                viewModel: viewModel
            )
//            {
//                TimelineView(.periodic(from: .now, by: 1)) { context in
//                    Text(now..<context.date, format: .timeDuration)
//                        .contentTransition(.numericText(countsDown: true))
//                        .font(.system(size: 20, weight: .bold, design: .rounded))
//                        .padding()
//                        .background(.ultraThinMaterial)
//                        .clipShape(RoundedRectangle(cornerRadius: 10))
//                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
//                }
//            }
        }
    }
}
