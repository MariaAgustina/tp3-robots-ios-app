//
//  LoadingView.swift
//  SearchProduct
//
//  Created by Maria Agustina Markosich on 13/07/2024.
//

import Foundation
import UIKit

final class LoadingView: UIView {

    private let gradientLayer = CAGradientLayer()
    private let shapeLayer = CAShapeLayer()
    private let animationKey = "rotationAnimation"

    override init(frame: CGRect) {
       super.init(frame: frame)
       setupLayer()
    }

    required init?(coder: NSCoder) {
       super.init(coder: coder)
       setupLayer()
    }

    private func setupLayer() {
       let circularPath = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: bounds.width / 2 - 2.5, startAngle: -CGFloat.pi / 2, endAngle: 1.5 * CGFloat.pi, clockwise: true)

       shapeLayer.path = circularPath.cgPath
       shapeLayer.lineWidth = 5
       shapeLayer.fillColor = UIColor.clear.cgColor
       shapeLayer.strokeColor = UIColor.black.cgColor
       shapeLayer.lineCap = .round
       shapeLayer.strokeEnd = 0.0

       gradientLayer.frame = bounds
       gradientLayer.colors = [BagifyTheme.lightPink.cgColor, BagifyTheme.lightLoadingPink.cgColor]
       gradientLayer.startPoint = CGPoint(x: 0, y: 0)
       gradientLayer.endPoint = CGPoint(x: 1, y: 1)
       gradientLayer.mask = shapeLayer

       layer.addSublayer(gradientLayer)

       startDrawingAnimation()
    }

    private func startDrawingAnimation() {
       let drawingAnimation = CABasicAnimation(keyPath: "strokeEnd")
       drawingAnimation.fromValue = 0
       drawingAnimation.toValue = 1
       drawingAnimation.duration = 2
       drawingAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
       drawingAnimation.repeatCount = .infinity
       shapeLayer.add(drawingAnimation, forKey: "drawingAnimation")
    }

    func startAnimating() {
       if layer.animation(forKey: animationKey) == nil {
           let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
           rotationAnimation.toValue = NSNumber(value: Double.pi * 2)
           rotationAnimation.duration = 2
           rotationAnimation.isRemovedOnCompletion = false
           rotationAnimation.repeatCount = .infinity
           layer.add(rotationAnimation, forKey: animationKey)
       }
    }

    func stopAnimating() {
       layer.removeAnimation(forKey: animationKey)
    }
}
