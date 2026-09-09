//
//  GameContent.swift
//  Smarty Tails Game
//

import Foundation

enum QuizSubject: String, CaseIterable, Identifiable {
    case mathematics
    case chemistry
    case geography
    case mixed

    var id: String { rawValue }

    var title: String {
        switch self {
        case .mathematics: "Mathematics"
        case .chemistry: "Chemistry"
        case .geography: "Geography"
        case .mixed: "Mixed quiz"
        }
    }

    var scoreKey: String { "topScore.\(rawValue)" }
    var winKey: String { "wins.\(rawValue)" }
}

struct QuizQuestion: Identifiable {
    let id = UUID()
    let title: String
    let answers: [String]
    let correctAnswer: String
}

enum QuizContent {
    static func questions(for subject: QuizSubject) -> [QuizQuestion] {
        switch subject {
        case .mathematics:
            return [
                QuizQuestion(title: "What is 7 × 8?", answers: ["54", "56", "64", "48"], correctAnswer: "56"),
                QuizQuestion(title: "What is the square root of 81?", answers: ["7", "8", "9", "10"], correctAnswer: "9"),
                QuizQuestion(title: "How many sides does a hexagon have?", answers: ["5", "6", "7", "8"], correctAnswer: "6"),
                QuizQuestion(title: "What is 25% of 200?", answers: ["25", "40", "50", "75"], correctAnswer: "50")
            ]
        case .chemistry:
            return [
                QuizQuestion(title: "What is the chemical symbol for water?", answers: ["O₂", "H₂O", "CO₂", "NaCl"], correctAnswer: "H₂O"),
                QuizQuestion(title: "Which gas do plants use for photosynthesis?", answers: ["Oxygen", "Nitrogen", "Carbon dioxide", "Helium"], correctAnswer: "Carbon dioxide"),
                QuizQuestion(title: "What is the symbol for gold?", answers: ["Ag", "Au", "Go", "Gd"], correctAnswer: "Au"),
                QuizQuestion(title: "A substance with pH 7 is…", answers: ["Acidic", "Neutral", "Alkaline", "Metallic"], correctAnswer: "Neutral")
            ]
        case .geography:
            return [
                QuizQuestion(title: "What is the capital of Ukraine?", answers: ["Mariupol", "Kyiv", "Donetsk", "Lviv"], correctAnswer: "Kyiv"),
                QuizQuestion(title: "Which is the largest ocean?", answers: ["Atlantic Ocean", "Indian Ocean", "Pacific Ocean", "Arctic Ocean"], correctAnswer: "Pacific Ocean"),
                QuizQuestion(title: "Which continent is the Sahara Desert in?", answers: ["Asia", "Africa", "Australia", "South America"], correctAnswer: "Africa"),
                QuizQuestion(title: "Which river flows through Paris?", answers: ["Danube", "Seine", "Thames", "Dnieper"], correctAnswer: "Seine")
            ]
        case .mixed:
            return [
                QuizQuestion(title: "Which planet is known as the Red Planet?", answers: ["Mars", "Venus", "Jupiter", "Mercury"], correctAnswer: "Mars"),
                QuizQuestion(title: "What is 9 + 6?", answers: ["13", "14", "15", "16"], correctAnswer: "15"),
                QuizQuestion(title: "Which gas is essential for breathing?", answers: ["Hydrogen", "Oxygen", "Neon", "Carbon dioxide"], correctAnswer: "Oxygen"),
                QuizQuestion(title: "What is the capital of Japan?", answers: ["Kyoto", "Tokyo", "Osaka", "Seoul"], correctAnswer: "Tokyo")
            ]
        }
    }
}

enum GameStore {
    static func topScore(for subject: QuizSubject) -> Int {
        UserDefaults.standard.integer(forKey: subject.scoreKey)
    }

    static func record(score: Int, for subject: QuizSubject) {
        let defaults = UserDefaults.standard
        defaults.set(max(score, topScore(for: subject)), forKey: subject.scoreKey)
        defaults.set(defaults.integer(forKey: subject.winKey) + 1, forKey: subject.winKey)
    }

    static var totalWins: Int {
        QuizSubject.allCases.reduce(0) { $0 + UserDefaults.standard.integer(forKey: $1.winKey) }
    }

    static var bestScore: Int {
        QuizSubject.allCases.map(topScore).max() ?? 0
    }
}
