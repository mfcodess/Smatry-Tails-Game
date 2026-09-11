//
//  SettingScreenMenu.swift
//  Smarty Tails Game
//
//  Created by Максим  on 11.07.2026.
//

import SwiftUI
import StoreKit

struct SettingScreenMenu: View {

    @Binding var showSetting: Bool
    @AppStorage("isVibrationEnabled") private var isVibration = true
    @AppStorage("isSoundEnabled") private var isSound = true
    @Environment(\.requestReview) private var requestReview: RequestReviewAction
    
    var body: some View {
        
        ZStack {
            
            Image("SettingBigWallpaper")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 300)
            
            VStack(spacing: 20) {
                Image("SettingsMenuWallpaper")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 180)
                
                HStack(spacing: 30) {
                    Button {
                        isSound.toggle()
                    } label: {
                        Image(isSound ? "BtnSoundOnWallpaper" : "BtnSoundOffWallpaper")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 60)
                    }
                    
                    Button {
                        isVibration.toggle()
                    } label: {
                        Image(isVibration ? "BtnVibroOnWallpaper" : "BtnVibroOffWallpaper")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 60)
                    }
                    
                    Button {
                        requestReview()
                    } label: {
                        Image("BtnRateWallpaper")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 60)
                    }
                }
                
                Button {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        showSetting = false
                    }
                    
                } label: {
                    Image("BtnCloseWallpaper")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 200)
                }
            }
        }
    }
}

#Preview {
    SettingScreenMenu(showSetting: .constant(true))
}
