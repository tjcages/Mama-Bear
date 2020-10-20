//
//  HelpView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/5/20.
//

import SwiftUI
import MessageUI

struct HelpView: View {
    @ObservedObject var faqVM: FAQViewModel
    @State var userFeedback: String = ""

    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false

    var emailMessageIsValid = MFMailComposeViewController.canSendMail()

    var sendButtonColor: Color {
        return emailMessageIsValid ? Colors.headline : Colors.subheadline
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: Sizes.xSmall) {
                Text("Help")
                    .customFont(.heavy, category: .extraLarge)
                    .foregroundColor(Colors.headline)
                    .padding(.top, Sizes.Large)
                    .padding(.bottom, Sizes.Default)

                VStack(alignment: .leading) {
                    Text("Check our FAQ")
                        .customFont(.medium, category: .medium)
                        .foregroundColor(Colors.headline)

                    Text("Instant help")
                        .customFont(.medium, category: .small)
                        .foregroundColor(Colors.subheadline)
                }
                    .padding(.bottom, Sizes.xSmall)

                ForEach(faqVM.faq, id: \.title) { question in
                    HelpRow(question: question)
                        .onTapGesture {
                            withAnimation(Animation.easeOut(duration: Animation.animationIn)) {
                                faqVM.updateOpen(question: question)
                            }
                    }
                }

                VStack(alignment: .leading) {
                    Text("Still looking for help?")
                        .customFont(.medium, category: .medium)
                        .foregroundColor(Colors.headline)

                    Text("Contact us")
                        .customFont(.medium, category: .small)
                        .foregroundColor(Colors.subheadline)
                }
                    .padding(.top, Sizes.Default)
                    .padding(.bottom, Sizes.xSmall)

                ZStack(alignment: .topTrailing) {
                    ResizableTextField(placeholder: Text("Type your message"), font: .medium, size: .medium, tag: 0, text: $userFeedback) {
                        // onCommit
                    } ended: {
                        // onEnded
                    }

                    Button {
                        // Send message
                        self.isShowingMailView.toggle()
                    } label: {
                        Image(systemName: "paperplane")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: Sizes.Default, height: Sizes.Default)
                            .foregroundColor(sendButtonColor)
                            .padding(Sizes.Spacer)
                            .contentShape(Rectangle())
                            .padding([.top, .trailing], Sizes.Spacer)
                    }
                        .disabled(!emailMessageIsValid)
                }

                Color.clear.padding(.bottom, Sizes.Big * 2)
            }
                .padding(.horizontal, Sizes.Default)

            Spacer()
        }
            .responsiveKeyboard()
            .sheet(isPresented: $isShowingMailView) {
                eMailView(message: userFeedback, result: self.$result)
        }
    }
}

struct HelpRow: View {
    var question: FAQ

    var body: some View {
        VStack {
            HStack(spacing: Sizes.xSmall) {
                Image(systemName: "questionmark.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: Sizes.xSmall, height: Sizes.xSmall)
                    .foregroundColor(Colors.white)
                    .padding(Sizes.Spacer)
                    .background(Colors.lightCoral)
                    .cornerRadius(Sizes.Large)

                Text(question.title)
                    .customFont(.medium, category: .medium)
                    .foregroundColor(Colors.headline)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer()

                Image(systemName: "chevron.down")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: Sizes.xSmall, height: Sizes.xSmall)
                    .foregroundColor(Colors.subheadline)
            }
                .padding(.bottom, Sizes.Spacer)

            if question.open {
                Text(question.description)
                    .customFont(.medium, category: .medium)
                    .foregroundColor(Colors.subheadline)
                    .fixedSize(horizontal: false, vertical: true)

                Rectangle()
                    .foregroundColor(Colors.subheadline.opacity(0.3))
                    .frame(height: 1)
                    .padding(.vertical, Sizes.Default)
            }
        }
    }
}
