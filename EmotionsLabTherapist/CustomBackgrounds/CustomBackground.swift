//
//  CustomBackground.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 14/04/2025.
//

import SwiftUI

struct CustomBackground: View{
    var body: some View{
        GeometryReader{ geometry in
            Color(red: 245/255, green: 238/255, blue: 220/255)
                .ignoresSafeArea()
            
            Circle()
                .fill(Color(red: 194/255, green: 179/255, blue: 140/255))
                .frame(width: geometry.size.width, height: geometry.size.height)
                .position(x: geometry.size.width / 2, y: 0)
        }
    }
}
#Preview {
    CustomBackground()
}
