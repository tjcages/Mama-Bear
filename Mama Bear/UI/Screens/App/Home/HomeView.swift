//
//  HomeView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/5/20.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: Sizes.xSmall) {
                Text("Main Feed")
                    .customFont(.heavy, category: .extraLarge)
                    .foregroundColor(Colors.headline)
                    .padding(.top, Sizes.Large)
                    .padding([.bottom, .horizontal], Sizes.Default)
                
                Header_HomeView()
                    .padding(.bottom, Sizes.Big)
                
                HStack {
                    Spacer()
                        
                    VStack {
                        Image("nannyGraphic")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.horizontal, Sizes.Big)
                        
                        Text("No upcoming listings.\nAdd a listing to view here.")
                            .customFont(.medium, category: .medium)
                            .foregroundColor(Colors.subheadline)
                            .multilineTextAlignment(.center)
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
