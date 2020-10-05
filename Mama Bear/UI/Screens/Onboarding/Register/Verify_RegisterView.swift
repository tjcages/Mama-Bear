//
//  Verify_RegisterView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/2/20.
//

import SwiftUI

struct Verify_RegisterView: View {
    @Binding var model: VerifyModel
    
    @State var canResend: Bool = false
    @Binding var canResendCode: Bool
    
    @State var timeRemaining: Int = 32
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(alignment: .leading) {
            Text("Paste code \nfrom SMS")
                .customFont(.heavy, category: .extraLarge)
                .foregroundColor(Colors.headline)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, Sizes.xSmall)

            VerifyTextView(model: $model)

            HStack {
                Spacer()

                if !canResend {
                    Text("Resend code in 0:\(timeRemaining)")
                        .customFont(.medium, category: .small)
                        .foregroundColor(Colors.subheadline)
                        .onReceive(timer) { _ in
                            if canResendCode {
                                timeRemaining = 32
                                canResendCode.toggle()
                            }
                            if timeRemaining > 0 {
                                timeRemaining -= 1
                            } else if timeRemaining == 0 {
                                withAnimation(Animation.easeOut(duration: Animation.animationIn)) {
                                    self.canResend.toggle()
                                }
                            }
                    }
                } else {
                    Button {
                        // Resend code
                        withAnimation(Animation.easeOut(duration: Animation.animationIn)) {
                            self.canResend.toggle()
                            self.timeRemaining = 32
                        }
                    } label: {
                        Text("Resend code")
                            .customFont(.medium, category: .small)
                            .foregroundColor(Colors.blue)
                    }

                }

                Spacer()
            }
                .padding(.top, Sizes.xSmall)

            Rectangle()
                .foregroundColor(.clear)
                .contentShape(Rectangle())
        }
            .padding(.horizontal, Sizes.Default)
    }
}
