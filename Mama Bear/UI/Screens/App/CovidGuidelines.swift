//
//  CovidGuidelines.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 1/5/21.
//

import SwiftUI

struct CovidGuidelines: View {
    @Binding var showSheet: Bool
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                BackButton() {
                    showSheet.toggle()
                }
                
                Image("covidGraphicLarge")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, Sizes.Default)
                
                Group {
                    Text("COVID-19 Guidelines")
                        .customFont(.heavy, category: .extraLarge)
                        .foregroundColor(Colors.headline)
                        .padding(.bottom, Sizes.Default)
                    
                    Text("""
                        During the COVID-19 pandemic, it’s important to keep health and safety in mind. We’ve created a set of mandatory COVID-19 safety practices for both for families and sitters of Mama Bear Babysitting listings, based on guidance from the World Health Organization and the US Centers for Disease Control.
                        
                        All families and sitters are required to follow the COVID-19 safety practices outlined above, as applicable.
                        """)
                        .customFont(.medium, category: .medium)
                        .foregroundColor(Colors.subheadline)
                        .padding(.bottom, Sizes.Default)
                    
                    Text("Wear a mask")
                        .customFont(.heavy, category: .large)
                        .foregroundColor(Colors.headline)
                        .padding(.bottom, Sizes.Small)
                    
                    Text("Wash your hands regularly")
                        .customFont(.heavy, category: .large)
                        .foregroundColor(Colors.headline)
                        .padding(.bottom, Sizes.Small)
                    
                    Text("Maintain distance in shared spaces")
                        .customFont(.heavy, category: .large)
                        .foregroundColor(Colors.headline)
                        .padding(.bottom, Sizes.Small)
                    
                    Text("Contact the listing number directly if you have symptoms of COVID-19")
                        .customFont(.heavy, category: .large)
                        .foregroundColor(Colors.headline)
                        .padding(.bottom, Sizes.Large)
                    
                    Divider()
                    
                    Text("What to do if you test positive for COVID-19 during or after your listing")
                        .customFont(.heavy, category: .large)
                        .foregroundColor(Colors.headline)
                        .padding(.top, Sizes.Large)
                        .padding(.bottom, Sizes.Small)
                    
                    Text("""
                        If you recently tested positive for COVID-19 or have started to feel any COVID-19 symptoms, and have recently stayed in a listing or interacted with families as a sitter, contact us. You should also inform relevant local authorities as well as your doctor.
                        """)
                        .customFont(.medium, category: .medium)
                        .foregroundColor(Colors.subheadline)
                        .padding(.bottom, Sizes.Default)
                }
                .padding(.horizontal, Sizes.Default)
            }
        }
    }
}
