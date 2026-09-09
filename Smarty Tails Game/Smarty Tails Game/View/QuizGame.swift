//
//  QuizGame.swift
//  Smarty Tails Game
//

import AVFoundation
import SwiftUI
import UIKit

private enum AnswerState {
    case normal, correct, wrong
}

struct QuizGame: View {
    let subject: QuizSubject
    @Binding var currentScreen: Screens

    @AppStorage("isSoundEnabled") private var isSoundEnabled = true
    @AppStorage("isVibrationEnabled") private var isVibrationEnabled = true

    private let questions: [QuizQuestion]
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    @State private var lives = 3
    @State private var currentQuestionIndex = 0
    @State private var time = 60
    @State private var score = 0
    @State private var isPaused = false
    @State private var selectedAnswers: Set<String> = []
    @State private var correctAnswer: String?
    @State private var result: GameResult?
    @State private var didStoreResult = false

    init(subject: QuizSubject, currentScreen: Binding<Screens>) {
        self.subject = subject
        _currentScreen = currentScreen
        questions = QuizContent.questions(for: subject)
    }

    var body: some View {
        let question = questions[currentQuestionIndex]

        ZStack {
            Image("GeographyWallpaper")
                .resizable()
                .ignoresSafeArea()

            VStack {
                header
                Spacer()
            }
            .padding(.horizontal, 16)

            VStack(spacing: 12) {
                Spacer()

                Text(subject.title)
                    .font(.system(size: 20, weight: .black, design: .rounded))
                    .foregroundStyle(.white)

                questionCard(question.title)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(question.answers, id: \.self) { answer in
                        answerButton(answer, question: question)
                    }
                }
            }
            .padding()

            if isPaused {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                PauseOverlay(resume: { isPaused = false }, leave: { currentScreen = .subject })
            }

            if let result {
                ResultOverlay(result: result, score: score, restart: restart, leave: { currentScreen = .subject })
            }
        }
        .onReceive(timer) { _ in
            guard !isPaused, result == nil else { return }
            if time > 0 {
                time -= 1
            } else {
                finish(.lost)
            }
        }
    }

    private var header: some View {
        VStack(spacing: -12) {
            HStack {
                HStack(spacing: 4) {
                    ForEach(0..<3, id: \.self) { index in
                        Image("HeartWallpaper")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 42, height: 38)
                            .opacity(index < lives ? 1 : 0.2)
                    }
                }
                Spacer()
                Button { isPaused = true } label: {
                    Image("BtnPauseWallpaper")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 64)
                }
                .accessibilityLabel("Pause game")
            }

            ZStack {
                Image("TimeWatchGeographyWallpaper")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 136, height: 164)
                Text("\(time)")
                    .font(.system(size: 35, weight: .bold, design: .rounded))
                    .foregroundStyle(.black)
                    .padding(.top, 30)
            }
        }
    }

    private func questionCard(_ title: String) -> some View {
        ZStack {
            Image("GreenGameWallpaper")
                .resizable()
                .scaledToFit()
            Text(title)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 280)
                .padding(.horizontal, 24)
        }
        .frame(maxWidth: 380)
    }

    private func answerButton(_ answer: String, question: QuizQuestion) -> some View {
        let state = answerState(for: answer, correct: question.correctAnswer)
        return Button { select(answer, in: question) } label: {
            ZStack {
                Image(imageName(for: state))
                    .resizable()
                    .scaledToFit()
                Text(answer)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 10)
                    .frame(maxWidth: 160)
            }
        }
        .disabled(selectedAnswers.contains(answer) || correctAnswer != nil)
        .accessibilityLabel(answer)
    }

    private func answerState(for answer: String, correct: String) -> AnswerState {
        if answer == correctAnswer { return .correct }
        if selectedAnswers.contains(answer) { return .wrong }
        return .normal
    }

    private func imageName(for state: AnswerState) -> String {
        switch state {
        case .normal: "BlueGameButton"
        case .correct: "GreenGameButton"
        case .wrong: "RedGameButton"
        }
    }

    private func select(_ answer: String, in question: QuizQuestion) {
        guard correctAnswer == nil, !selectedAnswers.contains(answer) else { return }
        if answer == question.correctAnswer {
            correctAnswer = answer
            score += 10
            playFeedback(success: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
                if currentQuestionIndex == questions.count - 1 {
                    finish(.won)
                } else {
                    currentQuestionIndex += 1
                    time = 60
                    selectedAnswers.removeAll()
                    correctAnswer = nil
                }
            }
        } else {
            selectedAnswers.insert(answer)
            lives -= 1
            playFeedback(success: false)
            if lives == 0 { finish(.lost) }
        }
    }

    private func finish(_ newResult: GameResult) {
        guard result == nil else { return }
        isPaused = true
        result = newResult
        if newResult == .won, !didStoreResult {
            GameStore.record(score: score, for: subject)
            didStoreResult = true
        }
    }

    private func restart() {
        lives = 3
        currentQuestionIndex = 0
        time = 60
        score = 0
        selectedAnswers.removeAll()
        correctAnswer = nil
        result = nil
        isPaused = false
        didStoreResult = false
    }

    private func playFeedback(success: Bool) {
        if isVibrationEnabled {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(success ? .success : .error)
        }
        if isSoundEnabled {
            SoundPlayer.shared.play()
        }
    }
}

private enum GameResult: Equatable {
    case won
    case lost

    var title: String { self == .won ? "Nice job!" : "Try again" }
    var imageName: String { self == .won ? "NiceJobWallpaper" : "TryHeaderWallpaper" }
}

private struct PauseOverlay: View {
    let resume: () -> Void
    let leave: () -> Void

    var body: some View {
        ZStack {
            Image("FieldSettingsWallpaper")
                .resizable()
                .scaledToFit()
                .frame(width: 270, height: 192)
            VStack(spacing: 25) {
                Image("PauseWallpaper")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 162, height: 32)
                HStack(spacing: 24) {
                    Button(action: leave) {
                        Image("BtnMenuWallpaper").resizable().scaledToFit().frame(width: 60, height: 64)
                    }
                    Button(action: resume) {
                        Image("BtnContinueSettingWallpaper").resizable().scaledToFit().frame(width: 60, height: 64)
                    }
                }
            }
        }
    }
}

private struct ResultOverlay: View {
    let result: GameResult
    let score: Int
    let restart: () -> Void
    let leave: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.6).ignoresSafeArea()
            Image(result.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 380, height: 380)
            VStack(spacing: 6) {
                Text(result.title)
                    .font(.system(size: 28, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                Image("ScoreWallpaper")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 87, height: 23)
                Text("\(score)")
                    .font(.system(size: 24, weight: .black))
                    .foregroundStyle(.white)
                    .frame(width: 132, height: 32)
                    .background(Color(red: 7 / 255, green: 39 / 255, blue: 21 / 255), in: RoundedRectangle(cornerRadius: 16))
            }
            .padding(.top, 70)
            HStack(spacing: 30) {
                Button(action: leave) {
                    Image("BtnMenuWallpaper").resizable().scaledToFit().frame(width: 60, height: 64)
                }
                Button(action: restart) {
                    Image("BtnRestartWallpaper").resizable().scaledToFit().frame(width: 60, height: 64)
                }
            }
            .padding(.top, 250)
        }
    }
}

private final class SoundPlayer {
    static let shared = SoundPlayer()
    private var player: AVAudioPlayer?

    func play() {
        guard let url = Bundle.main.url(forResource: "DAWSON", withExtension: "mp3") else { return }
        player = try? AVAudioPlayer(contentsOf: url)
        player?.prepareToPlay()
        player?.play()
    }
}
