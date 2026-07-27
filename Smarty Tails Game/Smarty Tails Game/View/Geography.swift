//
//  Geography.swift
//  Smarty Tails Game
//
//  Created by Максим  on 15.07.2026.
//

import SwiftUI
internal import Combine

struct Question {
    let title: String
    let answers: [String]
    let correctAnswer: String
}

struct Geography: View {
    
    @Binding var currentScreen: Screens
    
    @State private var lives = 3
    @State private var currentQuestionIndex = 0
    @State private var showSetting = false
    @State private var time = 60
    @State private var score = 0
    @State private var isGameOver = false
    @State private var isPaused = false
    @State private var isWin = false
    @State private var wrongAnswers: Set<String> = []
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    //Список вопросов
    let questions = [
        Question(
            title: "What is a capital of Ukraine",
            answers: ["Mariupol", "Kyiv", "Donetsk", "Lviv"],
            correctAnswer: "Kyiv"),
        
        Question(
            title: "Which is the largest ocean?",
            answers: ["Atlantic Ocean", "Indian Ocean", "Pacific Ocean", "Arctic Ocean"],
            correctAnswer: "Pacific Ocean"),]
    
    var body: some View {
        
        let currentQuestion = questions[currentQuestionIndex]
        
        //MARK: - ВЕРХНИЙ ЕКРАН
        ZStack {
            Image("GeographyWallpaper")
                .resizable()
                .ignoresSafeArea()
            
            //MARK: - СРЕДНИЙ ЕКРАН
            VStack {
                HStack {
                    HStack(spacing: 4) {
                        ForEach(0..<3, id: \.self) { index in
                            Image("HeartWallpaper")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 42, height: 38)
                                .opacity(index < lives ? 1 : 0.2)
                                .animation(.easeInOut(duration: 0.3), value: lives)
                        }
                    }
                    Spacer()
                    
                    Button {
                        isPaused = true
                        withAnimation(.easeInOut(duration: 0.4)) {
                            showSetting = true
                        }
                    } label: {
                        Image("BtnPauseWallpaper")
                            .resizable()
                            .frame(width: 60, height: 64)
                    }
                }
                
                HStack {
                    Spacer()
                    ZStack {
                        Image("TimeWatchGeographyWallpaper")
                            .resizable()
                            .frame(width: 136, height: 164)
                        Text("\(time)")
                            .font(.system(size: 35, weight: .bold, design: .rounded))
                            .foregroundStyle(.black)
                            .padding(.top, 30)
                    }
                    .offset(y: -60)
                    Spacer()
                }
                Spacer()
            }
            .padding(.horizontal, 16)
            //MARK: - НИЖНИЙ ЕКРАН
            
            VStack {
                Spacer()
                ZStack {
                    Image("GreenGameWallpaper")
                        .resizable()
                        .scaledToFit()
                    
                    Text("\(currentQuestion.title)")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .frame(width: 260)
                }
                .padding(.horizontal, 30)
                
                HStack {
                    answerButton(
                        nameImage: imageForAnswer(answer: currentQuestion.answers[0]),
                        nameAnswer: currentQuestion.answers[0]
                    )
                    answerButton(
                        nameImage: imageForAnswer(answer: currentQuestion.answers[1]),
                        nameAnswer: currentQuestion.answers[1]
                    )
                }
                
                HStack {
                    answerButton(
                        nameImage: imageForAnswer(answer: currentQuestion.answers[2]),
                        nameAnswer: currentQuestion.answers[2]
                    )
                    answerButton(
                        nameImage: imageForAnswer(answer: currentQuestion.answers[3]),
                        nameAnswer: currentQuestion.answers[3]
                    )
                }
            }
            .padding()
            
            if showSetting {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                
                GeographySetting(showSettings: $showSetting, isPaused: $isPaused)
            }
            
            if isWin {
                ZStack {
                    Color.black.opacity(0.6)
                        .ignoresSafeArea()
                    
                    
                    Image("NiceJobWallpaper")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 380, height: 380)
                    
                    VStack {
                        Image("ScoreWallpaper")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 87, height: 23)
                        
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(red: 7/255, green: 39/255, blue: 21/255))
                            .frame(width: 132, height: 32)
                        
                            .overlay {
                                Text("\(score)")
                                    .font(.system(size: 24, weight: .black))
                                    .foregroundStyle(.white)
                            }
                    }
                    .padding(.top, 80)
                    
                    HStack(spacing: 30) {
                        Button {
                            currentScreen = .menu
                        } label: {
                            Image("BtnMenuWallpaper")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 64)
                        }
                    }
                    .padding(.top, 250)
                }
            }
            
            if isGameOver {
                resultView(title: "", buttonTitle: "")
            }
        }
        
        .onReceive(timer) { _ in
            if !isGameOver && !isPaused {
                updateTimer()
            }
        }
    }
    
    //MARK: -  FUNC
    
    //MARK: Функция которая создает кнопку ответа
    func answerButton(nameImage: String, nameAnswer: String) -> some View{
        ZStack {
            Button {
                cheackAnswer(answer: nameAnswer)
            } label: {
                Image(nameImage)
                    .resizable()
                    .scaledToFit()
            }
            
            Text(nameAnswer)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 10)
                .frame(width: 160)
        }
    }
    
    //MARK: Функция которая запускает Таймер
    func updateTimer() {
        if time > 0 {
            time -= 1
        } else {
            isGameOver = true
        }
    }
    
    func restart() {
        time = 60
        isGameOver = false
        isWin = false
        lives = 3
        currentQuestionIndex = 0
        wrongAnswers.removeAll()
        currentQuestionIndex += 1
        time = 60
        
    }
    
    func lose() {
        if lives > 0 {
            lives -= 1
        }
        
        if lives == 0 {
            isGameOver = true
        }
    }
    
    func resultView(title: String, buttonTitle: String) -> some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()
            
            
            Image("TryHeaderWallpaper")
                .resizable()
                .scaledToFit()
                .frame(width: 380, height: 380)
            
            VStack {
                Image("ScoreWallpaper")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 87, height: 23)
                
                
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(red: 7/255, green: 39/255, blue: 21/255))
                    .frame(width: 132, height: 32)
                
                    .overlay {
                        Text("0")
                        
                            .font(.system(size: 24, weight: .black))
                            .foregroundStyle(.white)
                    }
            }
            .padding(.top, 80)
            
            HStack(spacing: 30) {
                Button {
                    currentScreen = .subject
                } label: {
                    Image("BtnMenuWallpaper")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 64)
                }
                
                Button {
                    restart()
                } label: {
                    Image("BtnRestartWallpaper")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 64)
                }
            }
            .padding(.top, 250)
        }
    }
    
    func cheackAnswer(answer: String) {
        
       
        
        let currentQuestion = questions[currentQuestionIndex]
        if answer != currentQuestion.correctAnswer {
            wrongAnswers.insert(answer)
        }
        if answer == currentQuestion.correctAnswer {
            score += 10
            
            if currentQuestionIndex < questions.count - 1 {
                wrongAnswers.removeAll()
                currentQuestionIndex += 1
                time = 60
            } else {
                isWin = true
                isPaused = true
            }
        } else {
            lose()
        }
    }
    
    func imageForAnswer(answer: String) -> String {

        if wrongAnswers.contains(answer) {
            return "RedGameButton"
        }

        return "BlueGameButton"
    }
    
}

#Preview {
    Geography(currentScreen: .constant(.geography))
}
