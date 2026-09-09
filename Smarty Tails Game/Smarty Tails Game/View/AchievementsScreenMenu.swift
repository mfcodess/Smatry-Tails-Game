//
//  AchievementsScreenMenu.swift
//  Smarty Tails Game
//

import SwiftUI

struct AchievementsScreenMenu: View {
    @Binding var currentScreen: Screens
    @State private var page = 0

    private var achievements: [Achievement] {
        [
            Achievement(title: "First steps", detail: "Win your first quiz", unlocked: GameStore.totalWins >= 1),
            Achievement(title: "Smarty", detail: "Reach 20 points in one quiz", unlocked: GameStore.bestScore >= 20),
            Achievement(title: "Quiz master", detail: "Win 4 quizzes", unlocked: GameStore.totalWins >= 4)
        ]
    }

    var body: some View {
        let achievement = achievements[page]
        ZStack {
            Image("EmptyWallpaper")
                .resizable()
                .ignoresSafeArea()

            VStack {
                HStack {
                    Button { currentScreen = .menu } label: {
                        Image("BtnMenuWallpaper")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                    }
                    .padding(.horizontal)
                    Spacer()
                }

                Spacer()

                Image("AchievementsChikenWallpaper")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 360)
                    .opacity(achievement.unlocked ? 1 : 0.35)
                    .overlay(alignment: .bottom) {
                        VStack(spacing: 8) {
                            Text(achievement.title)
                                .font(.system(size: 26, weight: .black, design: .rounded))
                            Text(achievement.detail)
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                            Text(achievement.unlocked ? "Unlocked!" : "Keep playing to unlock")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(achievement.unlocked ? .green : .secondary)
                        }
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white)
                        .padding(14)
                        .frame(width: 270)
                        .background(.black.opacity(0.55), in: RoundedRectangle(cornerRadius: 18))
                        .offset(y: 58)
                    }

                Spacer()

                HStack(spacing: 54) {
                    Button { page = max(0, page - 1) } label: {
                        Image("ArrowLeftWallpaper")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 72)
                            .opacity(page == 0 ? 0.35 : 1)
                    }
                    .disabled(page == 0)

                    Text("\(page + 1) / \(achievements.count)")
                        .font(.system(size: 18, weight: .black, design: .rounded))
                        .foregroundStyle(.white)

                    Button { page = min(achievements.count - 1, page + 1) } label: {
                        Image("ArrowRightWallpaper")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 72)
                            .opacity(page == achievements.count - 1 ? 0.35 : 1)
                    }
                    .disabled(page == achievements.count - 1)
                }
            }
        }
    }
}

private struct Achievement {
    let title: String
    let detail: String
    let unlocked: Bool
}

#Preview {
    AchievementsScreenMenu(currentScreen: .constant(.achievement))
}
