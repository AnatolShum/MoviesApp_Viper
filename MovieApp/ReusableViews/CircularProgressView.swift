//
//  CircularProgressView.swift
//  MoviesAppUIKit
//
//  Created by Anatolii Shumov on 03/10/2023.
//

import Foundation
import UIKit

class CircularProgressView: UIView {
    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    private var startPoint = CGFloat(-Double.pi / 2)
    private var endPoint = CGFloat(3 * Double.pi / 2)
    
    let starView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "star.fill")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.heightAnchor.constraint(equalToConstant: 18).isActive = true
        image.widthAnchor.constraint(equalToConstant: 18).isActive = true
        image.tintColor = .systemYellow
        return image
    }()
    
    let voteLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white.withAlphaComponent(0.7)
        return label
    }()
    
    var hStack: HStack!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        hStack = HStack(arrangedSubviews: [starView, voteLabel])
        hStack.spacing = 5
        hStack.alignment = .center
        addSubview(hStack)
        hStack.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        hStack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        createUI()
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createUI() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2, y: frame.size.height / 2),
                                        radius: 30,
                                        startAngle: startPoint,
                                        endAngle: endPoint,
                                        clockwise: true)
        
        circleLayer.path = circularPath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 10
        circleLayer.strokeEnd = 1
        circleLayer.strokeColor = UIColor.systemGray.withAlphaComponent(0.7).cgColor
        
        layer.addSublayer(circleLayer)
        
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 5
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = UIColor.systemGray.cgColor
        
        layer.addSublayer(progressLayer)
    }
    
    func progressAnimation(_ vote: Double?) {
        guard let vote = vote else { return }
        let progressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        progressAnimation.toValue = vote / 10
        progressAnimation.fillMode = .forwards
        progressAnimation.isRemovedOnCompletion = false
        progressLayer.add(progressAnimation, forKey: "progressAnim")
        progressLayer.strokeColor = setColor(with: vote).cgColor
    }
    
    func setColor(with vote: Double?) -> UIColor {
        guard let vote = vote else { return .gray }
        switch vote {
        case 0..<3:
            return .systemPurple.withAlphaComponent(0.7)
        case 3..<5:
            return .systemRed.withAlphaComponent(0.7)
        case 5..<6:
            return .systemOrange.withAlphaComponent(0.7)
        case 6..<7:
            return .systemYellow.withAlphaComponent(0.7)
        case 7...10:
            return .systemGreen.withAlphaComponent(0.7)
        default:
            return .systemGray
        }
    }
}
