//
//  PlayView.swift
//  ProBaseball
//
//  Created by 오킹 on 2021/05/06.
//

import UIKit

class PlayView: UIView {

    var path: UIBezierPath!
    var firstBase: DiamondView!
    var secondBase: DiamondView!
    var thirdBase: DiamondView!
    var homeBase: HomeView!
    private var pathShadow: UIBezierPath!
    private var groundPath: UIBezierPath!
    private var ellipsePath: UIBezierPath!
    lazy var centerX = self.bounds.midX
    lazy var centerY = self.bounds.midY
    lazy var baseSize: CGFloat = 30
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        drawBase()
    }
    
    override func draw(_ rect: CGRect) {
        self.createRectangle()
        self.createRectangleShadow()
        UIColor.brown.setStroke()
        pathShadow.lineWidth = 15
        pathShadow.stroke()
        
        UIColor.white.setStroke()
        let pattern: [CGFloat] = [6,3]
        path.setLineDash(pattern, count: pattern.count, phase: 0)
        path.lineWidth = 5
        path.stroke()
        
        self.createGround()
        groundPath.lineWidth = 10
        groundPath.stroke()
        setFillBase(color: UIColor.init(patternImage: UIImage(named: "playViewPattern")!))
        
        self.createEllipse()
        UIColor.brown.setFill()
        ellipsePath.lineWidth = 1
        ellipsePath.fill()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        drawBase()
    }
    
    func drawBase() {
        let halfBaseSize = baseSize/2
        let maxX = self.bounds.maxX - halfBaseSize
        let minX = self.bounds.minX - halfBaseSize
        let minY = self.bounds.minY - halfBaseSize
        let baseCenterX = centerX - halfBaseSize
        let baseCenterY = centerY - halfBaseSize
  
        self.firstBase = DiamondView(frame: CGRect(x: maxX, y: baseCenterY, width: baseSize, height: baseSize))
        self.secondBase = DiamondView(frame: CGRect(x: baseCenterX, y: minY, width: baseSize, height: baseSize))
        self.thirdBase = DiamondView(frame: CGRect(x: minX, y: baseCenterY, width: baseSize, height: baseSize))
        self.homeBase = HomeView(frame: CGRect(x: baseCenterX, y: self.bounds.maxY-(baseSize/1.2), width: baseSize, height: baseSize*1.2))
        self.addSubview(firstBase)
        self.addSubview(secondBase)
        self.addSubview(thirdBase)
        self.addSubview(homeBase)
    }
    
    func createRectangle() {
        path = UIBezierPath()
        path.move(to: CGPoint(x: centerX, y: 0))
        path.addLine(to: CGPoint(x: 0, y: centerY))
        path.addLine(to: CGPoint(x: centerX, y: self.frame.height))
        path.addLine(to: CGPoint(x: self.frame.width, y: centerY))
        path.close()
    }
    
    func createGround() {
        groundPath = UIBezierPath()
        groundPath.move(to: CGPoint(x: 0, y: centerY))
        groundPath.addLine(to: CGPoint(x: -centerX, y: self.bounds.minY))
    }
    
    func createRectangleShadow() {
        let centerX = self.frame.width/2
        let centerY = self.frame.height/2
        
        pathShadow = UIBezierPath()
        pathShadow.move(to: CGPoint(x: centerX, y: 0))
        pathShadow.addLine(to: CGPoint(x: 0, y: centerY))
        pathShadow.addLine(to: CGPoint(x: centerX, y: self.frame.height))
        pathShadow.addLine(to: CGPoint(x: self.frame.width, y: centerY))
        pathShadow.close()
    }
    
    private func createEllipse() {
        ellipsePath = UIBezierPath(ovalIn: CGRect(x: centerX-((self.frame.width/5)/2), y: centerY-((self.frame.width/10)/2), width: self.frame.width/5, height: self.frame.width/10))
    }
    
    func setFillBase(color: UIColor) {
        color.setFill()
        path.fill()
    }
    
}
