//
//  StructureCell.swift
//  Gather
//
//  Created by Tyler Cagle on 9/29/20.
//

import SwiftUI

struct RoutineCell: View {
    var body: some View {
        VStack(alignment: .leading, spacing: Sizes.Spacer) {
            HStack(alignment: .center, spacing: 0) {
                Text("Morning routine")
                    .customFont(.heavy, category: .medium)
                    .foregroundColor(Colors.orange)
                    .padding(.horizontal, Sizes.Default)
                
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(Colors.orange)
            }
            Text("7:00am")
                .customFont(.medium, category: .medium)
                .foregroundColor(Colors.subheadline)
                .padding(.horizontal, Sizes.Default)
        }
    }
}

struct StructureCell_Previews: PreviewProvider {
    static var previews: some View {
        RoutineCell()
    }
}
