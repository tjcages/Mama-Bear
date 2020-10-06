//
//  TabBarShape.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/5/20.
//

import SwiftUI

// Adapted from: https://medium.com/better-programming/cgaffinetransforms-arcs-and-quad-curves-in-swiftui-41e1dbfe6161
struct TabBarShape: Shape {
    @State var width: CGFloat
    @State var height: CGFloat
    @State var hump: Bool

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

    func path(in rect: CGRect) -> Path {
        var path = Path()

        // Move to beginning of Arc 1
        path.move(to: fit(CGPoint(x: width * 0.5 + TabBarShape.arrowWidth * 0.5, y: TabBarShape.arrowHeight)))

        // Step 1 (arc1)
        path.addArc(center: fit(CGPoint(x: width - cornerRadius, y: cornerRadius + TabBarShape.arrowHeight)),
            radius: cornerRadius,
            startAngle: arc1.start,
            endAngle: arc1.end,
            clockwise: clockwise)

        // Step 2 (arc2)
        path.addArc(center: fit(CGPoint(x: width - cornerRadius, y: height - cornerRadius)),
            radius: cornerRadius,
            startAngle: arc2.start,
            endAngle: arc2.end,
            clockwise: clockwise)

        // Step 3 (arc3)
        path.addArc(center: fit(CGPoint(x: cornerRadius, y: height - cornerRadius)),
            radius: cornerRadius,
            startAngle: arc3.start,
            endAngle: arc3.end,
            clockwise: clockwise)

        // Step 4 (arc4)
        path.addArc(center: fit(CGPoint(x: cornerRadius, y: cornerRadius + TabBarShape.arrowHeight)),
            radius: cornerRadius,
            startAngle: arc4.start,
            endAngle: arc4.end,
            clockwise: clockwise)

        if hump {
            // Step 5
            path.addLine(to: fit(CGPoint(x: (width * 0.5) - base.x, y: base.y)))

            // Step 6
            path.addQuadCurve(to: fit(CGPoint(x: (width * 0.5) - curv.x, y: curv.y)),
                control: fit(CGPoint(x: (width * 0.5) - ctrl.x, y: ctrl.y)))

            // Step 7
            path.addLine(to: fit(CGPoint(x: (width * 0.5) - peak.x, y: peak.y)))

            // Step 8
            path.addQuadCurve(to: fit(CGPoint(x: (width * 0.5) + peak.x, y: peak.y)),
                control: fit(CGPoint(x: (width * 0.5) + apex.x, y: apex.y)))

            // Step 9
            path.addLine(to: fit(CGPoint(x: (width * 0.5) + curv.x, y: curv.y)))

            // Step 10
            path.addQuadCurve(to: fit(CGPoint(x: (width * 0.5) + base.x, y: base.y)),
                control: fit(CGPoint(x: (width * 0.5) + ctrl.x, y: ctrl.y)))
        }

        return path
    }
}

