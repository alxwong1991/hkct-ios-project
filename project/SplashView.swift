//
//  SplashView.swift
//  project
//
//  Created by Alex MAC on 12/4/2023.
//

import SwiftUI

struct SplashView: View {
    
    @State var isAnimating = false
    
    @State var isActive: Bool = false
    
    var body: some View {
        VStack {
            if self.isActive {
                Home()
            } else {
                HStack(spacing: 0) {
                    Spacer()
                    Text("M")
                        .font(.system(size: 100))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .opacity(isAnimating ? 1 : 0)
                        .offset(x: isAnimating ? 0 : -200)
                        .animation(Animation.easeInOut(duration: 1.5), value: isAnimating)
                    
                    Text("useum")
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .opacity(isAnimating ? 1 : 0)
                        .offset(x: isAnimating ? 0 : -200)
                        .animation(Animation.easeInOut(duration: 1.5), value: isAnimating)
                    Spacer()
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear() {
            isAnimating = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    self.isActive = true
                }
                
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}

