//
//  PixelBorder.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//

import SwiftUI

struct PixelBorder: Shape {
    var pixel: CGFloat = 4
    var cornerPixels: Int = 2

    func path(in rect: CGRect) -> Path {
        let p = pixel
        let c = CGFloat(cornerPixels) * p

        var path = Path()

        // 外框：用直角 + “像素缺口”模拟像素边缘
        let r = rect.insetBy(dx: p/2, dy: p/2)

        // 画一个“像素圆角矩形”（简化版：切掉角）
        path.move(to: CGPoint(x: r.minX + c, y: r.minY))
        path.addLine(to: CGPoint(x: r.maxX - c, y: r.minY))
        path.addLine(to: CGPoint(x: r.maxX, y: r.minY + c))
        path.addLine(to: CGPoint(x: r.maxX, y: r.maxY - c))
        path.addLine(to: CGPoint(x: r.maxX - c, y: r.maxY))
        path.addLine(to: CGPoint(x: r.minX + c, y: r.maxY))
        path.addLine(to: CGPoint(x: r.minX, y: r.maxY - c))
        path.addLine(to: CGPoint(x: r.minX, y: r.minY + c))
        path.closeSubpath()

        return path
    }
}
