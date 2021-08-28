//
//  LearningAppApp.swift
//  LearningApp
//
//  Created by Scott on 11/8/21.
//

import SwiftUI

@main
struct LearningApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(ContentModel())
        }
    }
}
