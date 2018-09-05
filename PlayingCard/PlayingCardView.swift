//
//  PlayingCardView.swift
//  PlayingCard
//
//  Created by Thara Nagaraj on 03/09/18.
//  Copyright © 2018 Thara Nagaraj. All rights reserved.
//

import UIKit

@IBDesignable
class PlayingCardView: UIView {
    
    //setNeedsDisplay eventually calls draw, setNeedsLayout eventually calls layoutSubviews
    
    // If a property is marked @IBInspectable, the type HAS to be mentioned, inference won't work here
    @IBInspectable var rank : Int = 11 {didSet {setNeedsDisplay(); setNeedsLayout()}}
    @IBInspectable var suit : String = "❤️" {didSet {setNeedsDisplay(); setNeedsLayout()}}
    @IBInspectable var isFaceUp : Bool = true {didSet {setNeedsDisplay(); setNeedsLayout()}}
    
    
    var faceCardScale : CGFloat = SizeRatio.faceCardImageSizeToBoundSize {didSet {setNeedsDisplay(); setNeedsLayout()}}
    
    @objc func adjustFaceCardScale(byHandlingGestureRecognizedBy recognizer: UIPinchGestureRecognizer){
        switch recognizer.state {
        case .changed, .ended:
            faceCardScale *= recognizer.scale
            recognizer.scale = 1.0
        default:
            break
        }
    }
    
    private func centeredAttributedString(_ string : String, fontSize : CGFloat ) -> NSAttributedString {
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return NSAttributedString(string: string, attributes: [.paragraphStyle :paragraphStyle,
                                                               .font : font])
    }
    
    private var cornerString: NSAttributedString{
        return centeredAttributedString(rankString + "\n" + suit, fontSize: cornerFontSize)
    }
    
    private lazy var upperLeftCornerLabel = createCornerLabel()
    private lazy var lowerRightCornerLabel =  createCornerLabel()
    
    private func createCornerLabel() -> UILabel{
        let label = UILabel()
        label.numberOfLines = 0 // use as many lines as you need
        addSubview(label)
        return label
    }
    
    //changes font if user changes it in settings
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
        setNeedsLayout()
    }

    
    private func configureCornerLabel(_ label: UILabel){
        label.attributedText = cornerString
        label.frame.size = CGSize.zero
        label.sizeToFit()
        label.isHidden = !isFaceUp
    }
    
    
    //called by the system anytime your subviews need to be laid out
    //bounds -> drawing area
    //frame -> sets it
    override func layoutSubviews() {
        super.layoutSubviews()
        configureCornerLabel(upperLeftCornerLabel)
        upperLeftCornerLabel.frame.origin = bounds.origin.offsetBy(dx: cornerOffset, dy: cornerOffset)
        configureCornerLabel(lowerRightCornerLabel)
        lowerRightCornerLabel.transform = CGAffineTransform.identity
        .translatedBy(x: lowerRightCornerLabel.frame.size.width, y: lowerRightCornerLabel.frame.size.height)
        .rotated(by: CGFloat.pi)
        lowerRightCornerLabel.frame.origin = CGPoint(x: bounds.maxX, y: bounds.maxY)
            .offsetBy(dx: -cornerOffset, dy: -cornerOffset)
            .offsetBy(dx: -lowerRightCornerLabel.frame.size.width, dy: -lowerRightCornerLabel.frame.size.height)
    }

    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath.init(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
        
        if isFaceUp{
            if let faceCardImage = UIImage(named: rankString+suit, in: Bundle(for: self.classForCoder),
                                           compatibleWith: traitCollection){
                faceCardImage.draw(in: bounds.zoom(by: SizeRatio.faceCardImageSizeToBoundSize))
            } else{
                //drawPips()
            }
        } else{
            if let cardBackImage = UIImage(named: "cardBackImage",in: Bundle(for: self.classForCoder),
                                           compatibleWith: traitCollection){
                cardBackImage.draw(in: bounds)
            }
        }
    }
    
        
        // using context, fill path won't work
//        if let context = UIGraphicsGetCurrentContext(){
//            context.addArc(center: CGPoint(x : bounds.midX, y: bounds.midY), radius: 100.0, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
//            context.setLineWidth(5.0)
//            UIColor.gray.setFill()
//            UIColor.green.setStroke()
//            context.strokePath()
//            context.fillPath()
//        }
        // using UIBezierPath
//        let path = UIBezierPath()
//        path.addArc(withCenter: CGPoint(x : bounds.midX, y: bounds.midY), radius: 100.0, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
//        path.lineWidth = 5.0
//        UIColor.gray.setFill()
//        UIColor.green.setStroke()
//        path.stroke()
//        path.fill()
//    }

}

extension PlayingCardView{
    private struct SizeRatio{
        static let cornerFontSizeToBoundsHeight : CGFloat = 0.085
        static let cornerRadiusToBoundsHeight : CGFloat = 0.06
        static let cornerOffsetToCornerRadius : CGFloat = 0.33
        static let faceCardImageSizeToBoundSize : CGFloat = 0.75
    }
    
    private var cornerRadius : CGFloat{
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    
    private var cornerOffset : CGFloat{
        return cornerRadius * SizeRatio.cornerOffsetToCornerRadius
    }
    
    private var cornerFontSize : CGFloat{
        return bounds.size.height * SizeRatio.cornerFontSizeToBoundsHeight
    }
    
    private var rankString : String {
        switch rank {
        case 1: return "A"
        case 2...10: return String(rank)
        case 11 : return "J"
        case 12: return "Q"
        case 13 : return "K"
        default:
            return "?"
        }
    }
}


extension CGRect{
    var leftHalf : CGRect {
        return CGRect(x: minX, y: minY, width: width/2, height : height)
    }
    
    var rightHalf : CGRect {
        return CGRect(x: midX, y: minY, width: width/2, height : height)
    }
    
    func inset(by size: CGSize) -> CGRect{
        return insetBy(dx: size.width, dy: size.height)
    }
    
    func sizedTo(to size: CGSize) -> CGRect{
        return CGRect(origin: origin, size: size)
    }
    
    func zoom(by scale: CGFloat) -> CGRect{
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width - newWidth)/2, dy: (height - newHeight)/2)
    }
}


extension CGPoint{
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint{
        return CGPoint(x : x+dx, y: y+dy)
    }
}
