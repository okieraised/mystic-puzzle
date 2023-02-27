//
//  Extensions.swift
//  MysticPuzzle
//
//  Created by Tri Pham on 2/21/23.
//

import CoreGraphics

public extension CGPoint {
    
    func length() -> CGFloat {
        return sqrt(x * x + y * y)
    }
    
    func distanceTo(point: CGPoint) -> CGFloat {
        let differenceOfPoints = self - point
        return differenceOfPoints.length()
    }
    
    static func - (left: CGPoint, right: CGPoint) -> CGPoint {
        let dx = left.x - right.x
        let dy = left.y - right.y
        
        return CGPoint(x: dx, y: dy)
    }
    
    static func + (left: CGPoint, right: CGPoint) -> CGPoint {
        let dx = left.x + right.x
        let dy = left.y + right.y
        
        return CGPoint(x: dx, y: dy)
    }
    
    static func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
        let scaledX = point.x * scalar
        let scaledY = point.y * scalar
        
        return CGPoint(x: scaledX, y: scaledY)
    }
}
