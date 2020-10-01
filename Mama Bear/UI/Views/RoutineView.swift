//
//  StructureView.swift
//  Gather
//
//  Created by Tyler Cagle on 9/29/20.
//

import SwiftUI

struct RoutineView: View {

    // This is where a user will be able to tap to add another task
    var body: some View {
        VStack(alignment: .leading, spacing: Sizes.xSmall) {
            RoutineCell()

            TaskListView()
        }
            .padding(.bottom, Sizes.Big)
    }
}

struct StructureView_Previews: PreviewProvider {
    static var previews: some View {
        RoutineView()
    }
}
