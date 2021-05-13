//
//  PlayerIconView.swift
//  ProBaseball
//
//  Created by 조중윤 on 2021/05/12.
//

import UIKit

class PlayerIconView: UIView {
    override func draw(_ rect: CGRect) {
        let center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        guard let currentContext = UIGraphicsGetCurrentContext() else {
            print("Could not get the context")
            return
        }
        let iconSize = self.bounds
        
        drawSilhouette(using: currentContext, centerPoint: center, frame: iconSize)
        drawCap(using: currentContext, centerPoint: center, frame: iconSize)
        drawEyes(using: currentContext, centerPoint: center, frame: iconSize)
        drawMouth(using: currentContext, centerPoint: center, frame: iconSize)
    }
    
    private func drawSilhouette(using context: CGContext, centerPoint: CGPoint, frame: CGRect) {
        let startPoint = CGPoint(x: frame.width / 5, y: frame.height / 2.5)
        let rightPoint = CGPoint(x: frame.width * (4 / 5), y: frame.height / 2.5)
        let lowerLeftPoint = CGPoint(x: startPoint.x - frame.width / 5, y: startPoint.y + frame.height / 1.5)
        let lowerRightPoint = CGPoint(x: rightPoint.x + frame.width / 5, y: startPoint.y + frame.height / 1.5)
        
        context.move(to: startPoint)
        context.addCurve(to:rightPoint, control1: lowerLeftPoint, control2: lowerRightPoint)
        context.addQuadCurve(to: startPoint, control: CGPoint(x: centerPoint.x, y: frame.height / 10))
        context.setFillColor(UIColor(named: "retroIvory")?.cgColor ?? UIColor.red.cgColor)
        context.fillPath()
    }
    
    private func drawCap(using context: CGContext, centerPoint: CGPoint, frame: CGRect) {
        let startPoint = CGPoint(x: frame.width / 5, y: frame.height / 2.5)
        let capTipPoint = CGPoint(x: frame.width, y: frame.height / 2.5)
        let rightPoint = CGPoint(x: frame.width * (4 / 5), y: frame.height / 3)
        let capBrimVolumeControlPoint = CGPoint(x: frame.width * 0.9, y: frame.height / 3)
        let capTopPoint = CGPoint(x: centerPoint.x, y: frame.height / 5)
        let capRightVolumeControlPoint = CGPoint(x: frame.width * 0.8, y: frame.height / 5)
        let capLeftVolumeControlPoint = CGPoint(x: frame.width / 4, y: frame.height / 9)
        
        context.move(to: startPoint)
        context.addLine(to: capTipPoint)
        context.addQuadCurve(to: rightPoint, control: capBrimVolumeControlPoint)
        context.addQuadCurve(to: capTopPoint, control: capRightVolumeControlPoint)
        context.addQuadCurve(to: startPoint, control: capLeftVolumeControlPoint)
        context.setFillColor(UIColor(named: "retroBlue")?.cgColor ?? UIColor.red.cgColor)
        context.fillPath()
    }
    
    private func drawEyes(using context: CGContext, centerPoint: CGPoint, frame: CGRect) {
        let startPoint = CGPoint(x: centerPoint.x - (frame.width / 4), y: frame.height / 2.2)
        let rightPoint = CGPoint(x: centerPoint.x + (frame.width / 4), y: frame.height / 2.2)
        let eyeCenterPoint = CGPoint(x: centerPoint.x, y: frame.height / 2.2)
        let lowerLeftPoint = CGPoint(x: centerPoint.x - (frame.width / 8), y: startPoint.y + frame.height / 2)
        let lowerRightPoint = CGPoint(x: centerPoint.x + (frame.width / 8), y: startPoint.y + frame.height / 2)
        let pupilPointLeft = CGPoint(x: centerPoint.x - (frame.width / 7), y: frame.height / 2.2)
        let pupilPointRight = CGPoint(x: centerPoint.x + (frame.width / 7), y: frame.height / 2.2)
        
        // draw eyes
        context.move(to: startPoint)
        context.addLine(to: rightPoint)
        context.addQuadCurve(to: eyeCenterPoint, control: lowerRightPoint)
        context.addQuadCurve(to: startPoint, control: lowerLeftPoint)
        context.setFillColor(UIColor.white.cgColor)
        context.fillPath()
        
        // draw pupils
        context.move(to: eyeCenterPoint)
        context.addQuadCurve(to: pupilPointLeft, control: lowerLeftPoint)
        context.move(to: eyeCenterPoint)
        context.addQuadCurve(to: pupilPointRight, control: lowerRightPoint)
        context.setFillColor(UIColor(named: "retroBrown")?.cgColor ?? UIColor.red.cgColor)
        context.fillPath()
    }
    
    func drawMouth(using context: CGContext, centerPoint: CGPoint, frame: CGRect) {
        let startPoint = CGPoint(x: centerPoint.x - (frame.width / 8), y: frame.height / 1.3)
        let rightPoint = CGPoint(x: centerPoint.x + (frame.width / 4), y: frame.height / 1.4)
        let lowerLipControlPoint = CGPoint(x: centerPoint.x + (frame.width / 10), y: frame.height)
        let upperLipControlPoint = CGPoint(x: centerPoint.x + (frame.width / 7), y: frame.height / 1.3)
        
        context.move(to: startPoint)
        context.addQuadCurve(to: rightPoint, control: lowerLipControlPoint)
        context.addQuadCurve(to: startPoint, control: upperLipControlPoint)
        context.setFillColor(UIColor.systemRed.cgColor)
        context.fillPath()
    }
}
