//
//  SocialLoginView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/1/20.
//

import SwiftUI

struct SocialLoginView: View {
    let size = Sizes.xLarge - Sizes.Spacer
    let space = Sizes.Spacer
    
    var body: some View {
        HStack {
            Spacer()
            
            // Apple
            Button {
                //
            } label: {
                Image("")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size, height: size)
                    .background(Color.red)
                    .padding(.horizontal, space)
            }

            // Google
            Button {
                //
            } label: {
                Image("")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size, height: size)
                    .background(Color.red)
                    .padding(.horizontal, space)
            }
            
            // Facebook
            Button {
                //
            } label: {
                Image("")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size, height: size)
                    .background(Color.red)
                    .padding(.horizontal, space)
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
