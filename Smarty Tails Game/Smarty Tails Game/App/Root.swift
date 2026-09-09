//
//  Root.swift
//  Smarty Tails Game
//
//  Created by Максим  on 11.07.2026.
//

import SwiftUI

struct Root: View {
    
    @State var currentScreen: Screens = .loading
    
    var body: some View {
        
        switch currentScreen {
            
        case .loading:
            Loading(currentScreen: $currentScreen)
            
        case .informationOne:
            InformationOne(currentScreen: $currentScreen)
            
        case .informationTwo:
            InformationTwo(currentScreen: $currentScreen)
            
        case .menu:
            Menu(currentScreen: $currentScreen)
            
        case .achievement:
            AchievementsScreenMenu(currentScreen: $currentScreen)
            
        case .subject:
            Subject(currentScreen: $currentScreen)
            
        case .mathematics:
            QuizGame(subject: .mathematics, currentScreen: $currentScreen)

        case .chemistry:
            QuizGame(subject: .chemistry, currentScreen: $currentScreen)

        case .geography:
            QuizGame(subject: .geography, currentScreen: $currentScreen)

        case .mixed:
            QuizGame(subject: .mixed, currentScreen: $currentScreen)
        }
    }
}


