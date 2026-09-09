//
//  Geography.swift
//  Smarty Tails Game
//

import SwiftUI

/// Kept as a dedicated entry point for previews and links from older builds.
/// The shared `QuizGame` now owns all quiz rules.
struct Geography: View {
    @Binding var currentScreen: Screens

    var body: some View {
        QuizGame(subject: .geography, currentScreen: $currentScreen)
    }
}

#Preview {
    Geography(currentScreen: .constant(.geography))
}
