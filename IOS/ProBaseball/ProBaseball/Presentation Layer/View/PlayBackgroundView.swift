//
//  GroundView.swift
//  ProBaseball
//
//  Created by 오킹 on 2021/05/13.
//

import Foundation
import UIKit

class PlayBackgroundView: UIView {
    
    @IBOutlet weak var playView: PlayView!
    private var groundPath: UIBezierPath!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor =  UIColor(patternImage: UIImage(named: "playViewPattern")!)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor =  UIColor(patternImage: UIImage(named: "playViewPattern")!)
    }
    
    override func draw(_ rect: CGRect) {
        self.createGroundLine()
        UIColor.white.setStroke()
        let pattern: [CGFloat] = [6,3]
        groundPath.setLineDash(pattern, count: pattern.count, phase: 0)
        groundPath.lineWidth = 3
        groundPath.stroke()
       
    }
    
    private func createGroundLine() {
        groundPath = UIBezierPath()
    
        groundPath.move(to: CGPoint(x: playView.frame.minX, y: playView.frame.midY))
        groundPath.addLine(to: CGPoint(x: -((playView.frame.midX-playView.frame.minX)-playView.frame.minX), y: playView.frame.minY))
        
        groundPath.move(to: CGPoint(x: playView.frame.maxX, y: playView.frame.midY))
        groundPath.addLine(to: CGPoint(x: playView.frame.maxX+((playView.frame.maxX-playView.frame.midX)), y: playView.frame.minY))
    }
 
    
}
