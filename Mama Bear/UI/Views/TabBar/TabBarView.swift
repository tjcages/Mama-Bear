//
//  TabBarView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/5/20.
//

import Foundation
import SwiftUI
import Combine

enum TabBarViews {
    case home
    case notification
    case newListing
    case help
    case profile
}

struct TabBarView: View {
    @ObservedObject var viewRouter: ViewRouter
    @State var geometry: GeometryProxy
    
    static var animationDuration = Animation.animationQuick

    var size: CGFloat = Sizes.Default
    var padding: CGFloat = 12

    var fit: ((CGPoint) -> (CGPoint)) = { point in return point }
    var cornerRadius: CGFloat = 0

    static var arrowWidth: CGFloat = 164
    static var arrowHeight = Sizes.Small

    var clockwise = false
    var arc1 = (start: Angle.radians(-.pi * 0.5), end: Angle.radians(.pi * 0.0))
    var arc2 = (start: Angle.radians(.pi * 0.0), end: Angle.radians(.pi * 0.5))
    var arc3 = (start: Angle.radians(.pi * 0.5), end: Angle.radians(.pi * 1.0))
    var arc4 = (start: Angle.radians(.pi * 1.0), end: Angle.radians(-.pi * 0.5))

    let apex = CGPoint(x: arrowWidth * 0.5 * 0.000, y: -arrowHeight * 0.1456)
    let peak = CGPoint(x: arrowWidth * 0.5 * 0.200, y: arrowHeight * 0.0864)
    let curv = CGPoint(x: arrowWidth * 0.5 * 0.500, y: arrowHeight * 0.7500)
    let ctrl = CGPoint(x: arrowWidth * 0.5 * 0.750, y: arrowHeight * 1.0000)
    let base = CGPoint(x: arrowWidth * 0.5 * 1.000, y: arrowHeight * 1.0000)

    var body: some View {
        VStack {
            HStack {
                // Main feed
                Image(systemName: "list.bullet.below.rectangle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size, height: size)
                    .padding(padding)
                    .foregroundColor(viewRouter.currentView == .home ? Colors.white : Colors.subheadline)
                    .background(
                        Rectangle()
                            .foregroundColor(viewRouter.currentView == .home ? Colors.coral : Color.clear)
                            .cornerRadius(Sizes.xSmall)
                            .shadow()
                    )
                    .onTapGesture {
                        withAnimation(Animation.easeOut(duration: TabBarView.animationDuration)) {
                            self.viewRouter.currentView = .home
                        }
                }

                Spacer()

                // User messages
                Image(systemName: "bell")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size, height: size)
                    .padding(padding)
                    .foregroundColor(viewRouter.currentView == .notification ? Colors.white : Colors.subheadline)
                    .background(
                        Rectangle()
                            .foregroundColor(viewRouter.currentView == .notification ? Colors.coral : Color.clear)
                            .cornerRadius(Sizes.xSmall)
                            .shadow()
                    )
                    .onTapGesture {
                        withAnimation(Animation.easeOut(duration: TabBarView.animationDuration)) {
                            self.viewRouter.currentView = .notification
                        }
                }

                Spacer()

                if viewRouter.accountType == .family {
                    // Add new listing
                    Image(systemName: "plus")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: Sizes.Default, height: Sizes.Default)
                        .foregroundColor(viewRouter.currentView == .newListing ? Colors.white : Colors.subheadline)
                        .padding(Sizes.Small)
                        .background(viewRouter.currentView == .newListing ? Colors.coral : Colors.white)
                        .cornerRadius(Sizes.Large)
                        .shadow()
                        .offset(y: -Sizes.Spacer)
                        .onTapGesture {
                            withAnimation(Animation.easeOut(duration: TabBarView.animationDuration)) {
                                self.viewRouter.currentView = .newListing
                            }
                    }

                    Spacer()
                }

                // Get help/feedback
                Image(systemName: "questionmark.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size, height: size)
                    .padding(padding)
                    .foregroundColor(viewRouter.currentView == .help ? Colors.white : Colors.subheadline)
                    .background(
                        Rectangle()
                            .foregroundColor(viewRouter.currentView == .help ? Colors.coral : Color.clear)
                            .cornerRadius(Sizes.xSmall)
                            .shadow()
                    )
                    .onTapGesture {
                        withAnimation(Animation.easeOut(duration: TabBarView.animationDuration)) {
                            self.viewRouter.currentView = .help
                        }
                }
                
                Spacer()
                
                // User profile
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size, height: size)
                    .padding(padding)
                    .foregroundColor(viewRouter.currentView == .profile ? Colors.white : Colors.subheadline)
                    .background(
                        Rectangle()
                            .foregroundColor(viewRouter.currentView == .profile ? Colors.coral : Color.clear)
                            .cornerRadius(Sizes.xSmall)
                            .shadow()
                    )
                    .onTapGesture {
                        withAnimation(Animation.easeOut(duration: TabBarView.animationDuration)) {
                            self.viewRouter.currentView = .profile
                        }
                }
            }
                .padding(.horizontal, viewRouter.accountType == .family ? Sizes.Default : Sizes.xLarge)
                .frame(width: geometry.size.width, height: geometry.size.height / 10)

            Rectangle()
                .foregroundColor(.clear)
                .frame(width: geometry.size.width, height: Sizes.Spacer)
        }
            .background(
                // Adapted from: https://medium.com/better-programming/cgaffinetransforms-arcs-and-quad-curves-in-swiftui-41e1dbfe6161
                Path { path in
                    // Move to beginning of Arc 1
                    path.move(to: fit(CGPoint(x: geometry.size.width * 0.5 + TabBarView.arrowWidth * 0.5, y: TabBarView.arrowHeight)))

                    // Step 1 (arc1)
                    path.addArc(center: fit(CGPoint(x: geometry.size.width - cornerRadius, y: cornerRadius + TabBarView.arrowHeight)),
                        radius: cornerRadius,
                        startAngle: arc1.start,
                        endAngle: arc1.end,
                        clockwise: clockwise)

                    // Step 2 (arc2)
                    path.addArc(center: fit(CGPoint(x: geometry.size.width - cornerRadius, y: geometry.size.height - cornerRadius)),
                        radius: cornerRadius,
                        startAngle: arc2.start,
                        endAngle: arc2.end,
                        clockwise: clockwise)

                    // Step 3 (arc3)
                    path.addArc(center: fit(CGPoint(x: cornerRadius, y: geometry.size.height - cornerRadius)),
                        radius: cornerRadius,
                        startAngle: arc3.start,
                        endAngle: arc3.end,
                        clockwise: clockwise)

                    // Step 4 (arc4)
                    path.addArc(center: fit(CGPoint(x: cornerRadius, y: cornerRadius + TabBarView.arrowHeight)),
                        radius: cornerRadius,
                        startAngle: arc4.start,
                        endAngle: arc4.end,
                        clockwise: clockwise)

                    if viewRouter.accountType == .family {
                        // Step 5
                        path.addLine(to: fit(CGPoint(x: (geometry.size.width * 0.5) - base.x, y: base.y)))

                        // Step 6
                        path.addQuadCurve(to: fit(CGPoint(x: (geometry.size.width * 0.5) - curv.x, y: curv.y)),
                            control: fit(CGPoint(x: (geometry.size.width * 0.5) - ctrl.x, y: ctrl.y)))

                        // Step 7
                        path.addLine(to: fit(CGPoint(x: (geometry.size.width * 0.5) - peak.x, y: peak.y)))

                        // Step 8
                        path.addQuadCurve(to: fit(CGPoint(x: (geometry.size.width * 0.5) + peak.x, y: peak.y)),
                            control: fit(CGPoint(x: (geometry.size.width * 0.5) + apex.x, y: apex.y)))

                        // Step 9
                        path.addLine(to: fit(CGPoint(x: (geometry.size.width * 0.5) + curv.x, y: curv.y)))

                        // Step 10
                        path.addQuadCurve(to: fit(CGPoint(x: (geometry.size.width * 0.5) + base.x, y: base.y)),
                            control: fit(CGPoint(x: (geometry.size.width * 0.5) + ctrl.x, y: ctrl.y)))
                    }
                }
                    .fill()
                    .foregroundColor(Colors.white)
                    .shadow()
                    .offset(y: -Sizes.Spacer)
            )
    }
}
