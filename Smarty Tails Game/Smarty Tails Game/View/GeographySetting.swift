//
//  GeographySetting.swift
//  Smarty Tails Game
//
//  Created by Максим  on 20.07.2026.
//

import SwiftUI

struct GeographySetting: View {
    
    @Binding var showSettings: Bool
    @Binding var isPaused: Bool
    
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
                    Button {
                        
                    } label: {
                        Image("BtnMenuWallpaper")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 64)
                    }
                    
                    Button {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            showSettings = false
                            isPaused = false
                        }
                    } label: {
                        Image("BtnContinueSettingWallpaper")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 64)
                    }
                }
            }
        }
    }
}

#Preview {
    GeographySetting(showSettings: .constant(false), isPaused: .constant(false))
}
