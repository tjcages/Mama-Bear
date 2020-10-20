//
//  HomeView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/5/20.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var authenticationService: AuthenticationService
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: Sizes.xSmall) {
                Text("Main Feed")
                    .customFont(.heavy, category: .extraLarge)
                    .foregroundColor(Colors.headline)
                    .padding(.top, Sizes.Large)
                    .padding([.bottom, .horizontal], Sizes.Default)
                
                Header_HomeView(authenticationService: authenticationService)
                    .padding(.bottom, Sizes.Big)
                
                HStack {
                    Spacer()
                        
                    VStack {
                        Image("nannyHomeGraphic")
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
