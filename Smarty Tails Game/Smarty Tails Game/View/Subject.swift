//
//  Subject.swift
//  Smarty Tails Game
//
//  Created by Максим  on 14.07.2026.
//

import SwiftUI

struct Subject: View {
    
    @Binding var currentScreen: Screens
    
    var body: some View {
        
        ZStack {
            Image("EmptyWallpaper")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            currentScreen = .menu
                        }
                    } label: {
                        Image("BtnMenuWallpaper")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                    }
                    .padding(.horizontal)
                    Spacer()
                }
                ScrollView {
                    HStack {
                        Spacer()
                        ZStack {
                            Image("RectangleSubjectWallpaper")
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 680)
                            
                            VStack {
                                Text("Choose your\nsubject")
                                    .fontWeight(.black)
                                    .font(.system(size: 36))
                                    .foregroundStyle(.white)
                                    .multilineTextAlignment(.center)
                                
                                ZStack {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color(red: 7/255, green: 39/255, blue: 21/255))
                                        .frame(width: 162, height: 32)
                                    
                                    Text("Top score: \(GameStore.topScore(for: .mathematics))")
                                        .fontWeight(.black)
                                        .foregroundStyle(.white)
                                }
                                Button {
                                    currentScreen = .mathematics
                                } label: {
                                    Image("BtnMathematicsWallpaper")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 270)
                                }
                                
                                ZStack {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color(red: 7/255, green: 39/255, blue: 21/255))
                                        .frame(width: 162, height: 32)
                                    
                                    Text("Top score: \(GameStore.topScore(for: .chemistry))")
                                        .fontWeight(.black)
                                        .foregroundStyle(.white)
                                }
                                Button {
                                    currentScreen = .chemistry
                                } label: {
                                    Image("BtnChemistryWallpaper")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 270)
                                }
                                
                                ZStack {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color(red: 7/255, green: 39/255, blue: 21/255))
                                        .frame(width: 162, height: 32)
                                    
                                    Text("Top score: \(GameStore.topScore(for: .geography))")
                                        .fontWeight(.black)
                                        .foregroundStyle(.white)
                                }
                                Button {
                                    withAnimation(.easeInOut(duration: 0.4)) {
                                        currentScreen = .geography
                                    }
                                    
                                } label: {
                                    Image("BtnGeographyWallpaper")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 270)
                                }
                                
                                ZStack {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color(red: 7/255, green: 39/255, blue: 21/255))
                                        .frame(width: 162, height: 32)
                                    
                                    Text("Top score: \(GameStore.topScore(for: .mixed))")
                                        .fontWeight(.black)
                                        .foregroundStyle(.white)
                                }
                                Button {
                                    currentScreen = .mixed
                                } label: {
                                    Image("BtnMixedWallpaper")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 270)
                                }
                            }
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}

#Preview {
    Subject(currentScreen: .constant(.subject))
}
