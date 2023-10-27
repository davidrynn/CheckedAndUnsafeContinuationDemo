//
//  Continuation_DemoApp.swift
//  Continuation Demo
//
//  Created by David Rynn on 10/26/23.
//

import SwiftUI

@main
struct Continuation_DemoApp: App {
    var body: some Scene {
        WindowGroup {
            AnimalView(viewModel: AnimalViewModel(service: NetworkClient()))
        }
    }
}
