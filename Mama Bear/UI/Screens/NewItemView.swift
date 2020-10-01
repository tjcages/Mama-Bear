//
//  NewItemView.swift
//  Gather
//
//  Created by Tyler Cagle on 9/29/20.
//

import SwiftUI
import Introspect

struct NewItemView: View {
    @State private var sendNewItem = false
    @State private var addDescription = false
    @State private var showReturnDescription = true

    @State private var textFieldText = ""
    @State private var descriptionFieldText = ""
    @State private var emojiIcon = ""

    @State var taskSelection: TaskItems = .task
    @State var scheduleSelection: ScheduleOptions = .today

    @State private var titleFirstResponder = false
    @State private var descriptionFirstResponder = false

    //MARK: -Declare views

    var titleView: some View {
        PlaceholderTextField(
            placeholder:
                Text(placeholder()),
            font: .heavy,
            size: .large,
            tag: 0,
            becomeFirstResponder: $titleFirstResponder,
            text: $textFieldText,
            commit: {
                addDescription = true
                showReturnDescription = false
                descriptionFirstResponder = true
            },
            ended: {

            })
    }

    var descriptionView: some View {
        PlaceholderTextField(
            placeholder:
                Text("Add description"),
            font: .regular,
            size: .medium,
            tag: 1,
            becomeFirstResponder: $descriptionFirstResponder,
            text: $descriptionFieldText,
            commit: {
                if descriptionFieldText.isEmpty {
                    addDescription = false
                }
            },
            ended: {
                if descriptionFieldText.isEmpty {
                    DispatchQueue.main.async {
                        self.addDescription = false
                    }
                }
            })
    }

    var descriptionPlaceholder: some View {
        Text("Press return to add a description")
            .customFont(.medium, category: .medium)
            .foregroundColor(Colors.subheadline)
            .padding(.bottom, Sizes.Spacer)
            .onTapGesture {
                addDescription = true
                showReturnDescription = false
                descriptionFirstResponder = true
            }
            .onAppear {
                delayWithSeconds(4) {
                    withAnimation {
                        self.showReturnDescription = false
                    }
                }
        }
    }

    @State private var selectingIcon = false

    var iconView: some View {
        HStack(alignment: .center, spacing: 8) {
            if !selectingIcon {
                Image(systemName: "smiley.fill")
                    .resizable()
                    .frame(width: Sizes.xSmall, height: Sizes.xSmall)
                    .foregroundColor(Colors.subheadline)
                    .padding([.top, .leading, .bottom], Sizes.Spacer)

                Text("Add icon")
                    .customFont(.heavy, category: .small)
                    .foregroundColor(Colors.subheadline)
                    .padding([.top, .trailing, .bottom], Sizes.Spacer)

            } else {
                EmojiTextView(emojiText: $emojiIcon, font: uiFont(.heavy, category: .extraLarge), onDone: {
                        selectingIcon = false
                    })
                    .frame(width: Sizes.Large + Sizes.Spacer, height: Sizes.Large + Sizes.Spacer)
                    .padding(.trailing, Sizes.Spacer)
                    .offset(x: -4, y: 0)
            }
        }
            .background(Colors.subheadline.opacity(selectingIcon ? 0 : 0.1))
            .cornerRadius(Sizes.Spacer / 2)
            .padding(.bottom, selectingIcon ? 0 : Sizes.xSmall/2)
            .onTapGesture {
                selectingIcon = true
            }
            .onDisappear {
                selectingIcon = false
        }
    }

    //MARK: -UI Logic

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .bottom) {
                AddNewView(selection: $taskSelection)
                    .padding(.vertical, Sizes.xSmall)

                Spacer()

                SendButton(addTask: $sendNewItem)
            }
                .padding(.leading, Sizes.xSmall)

            VStack(alignment: .leading, spacing: 0) {
                // Add an icon
                iconView

                // Title textfield
                titleView

                // Description placeholder
                if descriptionFieldText.isEmpty && !textFieldText.isEmpty && showReturnDescription {
                    descriptionPlaceholder
                }

                if addDescription {
                    descriptionView
                        .offset(x: 0, y: -Sizes.Spacer)
                }

                ScheduleView(selection: $scheduleSelection)
                    .padding(.top, Sizes.Spacer)

                Spacer()
                    .frame(height: 100)
            }
                .padding(.top, Sizes.xSmall)
                .padding(.horizontal, Sizes.Default)
                .background(
                    Colors.cellBackground
                        .cornerRadius(Sizes.Spacer)
                        .onTapGesture {
                            UIApplication.shared.endEditing()
                    }
                )
        }
            .onAppear {
                titleFirstResponder = true
        }
    }

    func placeholder() -> String {
        var placeholder = "Enter task title"
        if taskSelection == .event {
            placeholder = "Enter event information"
        } else if taskSelection == .project {
            placeholder = "Enter project details"
        }
        return placeholder
    }
}

struct NewItemView_Previews: PreviewProvider {
    static var previews: some View {
        NewItemView()
    }
}
