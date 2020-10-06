//
//  DurationView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/6/20.
//

import SwiftUI

struct DurationView: View {
    var body: some View {
        VStack(alignment: .leading) {
            // Date selection
            HStack {
                Image(systemName: "calendar")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: Sizes.Default, height: Sizes.Default)
                    .foregroundColor(Colors.coral)
                
                Text("06.02.2019")
                    .customFont(.medium, category: .medium)
                    .foregroundColor(Colors.headline)
            }
            
            // Divider
            Rectangle()
                .foregroundColor(Colors.subheadline)
                .frame(height: 1)
                .padding(.vertical, Sizes.xSmall)
            
            // Duration
            HStack {
                // Start
                VStack(alignment: .leading) {
                    Text("Start time")
                        .customFont(.medium, category: .small)
                        .foregroundColor(Colors.subheadline)
                    
                    HStack {
                        Image(systemName: "clock")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: Sizes.Small, height: Sizes.Small)
                            .foregroundColor(Colors.coral)
                        
                        Text("5:45 am")
                            .customFont(.medium, category: .medium)
                            .foregroundColor(Colors.headline)
                    }
                }
                
                Spacer()
                
                Image(systemName: "arrow.right")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: Sizes.xSmall, height: Sizes.xSmall)
                    .foregroundColor(Colors.subheadline)
                    .offset(y: Sizes.xSmall)
                
                Spacer()
                
                // Start
                VStack(alignment: .leading) {
                    Text("End time")
                        .customFont(.medium, category: .small)
                        .foregroundColor(Colors.subheadline)
                    
                    HStack {
                        Image(systemName: "clock")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: Sizes.Small, height: Sizes.Small)
                            .foregroundColor(Colors.coral)
                        
                        Text("10:30 pm")
                            .customFont(.medium, category: .medium)
                            .foregroundColor(Colors.headline)
                    }
                }
            }
        }
        .padding(Sizes.Default)
        .background(Colors.white)
        .cornerRadius(Sizes.Spacer)
        .shadow()
        .padding(.horizontal, Sizes.Default)
    }
}

struct DurationView_Previews: PreviewProvider {
    static var previews: some View {
        DurationView()
    }
}
