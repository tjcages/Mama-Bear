//
//  SocialLoginView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/1/20.
//

import SwiftUI

struct SocialLoginView: View {
    let size = Sizes.xLarge
    let space = Sizes.Spacer
    
    var body: some View {
        HStack {
            Spacer()
            
            // Apple
            Button {
                //
            } label: {
                Image("apple")
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size, height: size)
                    .padding(.horizontal, space)
                    .foregroundColor(Colors.darkBlue)
                    .contentShape(Circle())
            }

            // Google
            Button {
                //
            } label: {
                Image("google")
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size, height: size)
                    .padding(.horizontal, space)
                    .foregroundColor(Colors.darkBlue)
                    .contentShape(Circle())
            }
            
            // Facebook
            Button {
                //
            } label: {
                Image("facebook")
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size, height: size)
                    .padding(.horizontal, space)
                    .foregroundColor(Colors.darkBlue)
                    .contentShape(Circle())
            }
            
            Spacer()
        }
    }
}

struct SocialLoginView_Previews: PreviewProvider {
    static var previews: some View {
        SocialLoginView()
    }
}
