//
//  BeautySegmentControl.swift
//  FrameworksTest
//
//  Created by Denis on 28.06.17.
//  Copyright © 2017 Denis Petrov. All rights reserved.
//

import UIKit

@IBDesignable public class BeautySegmentControl: UIView
{
    fileprivate var arrayOfButtons = [UIButton]()
    fileprivate var line : CALayer!
    var delegate : DPSegmentControlDelegate?
    
    //строка названий кнопок
    @IBInspectable
    var buttonTitles: String = ""
    {
        didSet {
            setup()
        }
    }
    
    //цвет названий кнопок
    @IBInspectable
    var titlesColor: UIColor = UIColor(colorLiteralRed: 61/255.0, green: 153/255.0, blue: 246/255.0, alpha: 1.0)
    {
        didSet {
            setup()
        }
    }
    
    //размер названий
    @IBInspectable
    var buttonFontSize: UInt = 15
    {
        didSet {
            setup()
        }
    }
    
    //нужно ли менять цвет тайтла у активной кнопки
    @IBInspectable
    var needTitleHighlight: Bool = true
    
    //цвет тайтла активной кнопки
    @IBInspectable
    var activeButtonColor: UIColor = UIColor(colorLiteralRed: 238/255.0, green: 163/255.0, blue: 81/255.0, alpha: 1.0)
    
    //нужно ли менять цвет бэкграунда у активной кнопки
    @IBInspectable
    var backgroundHighlight: Bool = true
    
    //цвет бэкграунда активной кнопки
    @IBInspectable
    var activeButtonBackgroundColor: UIColor = UIColor(colorLiteralRed: 222/255.0, green: 255/255.0, blue: 252/252.0, alpha: 1.0)
    
    //нужна ли линия
    @IBInspectable
    var lineEnabled: Bool = true
    
    //высота линии
    @IBInspectable
    var lineHeight: UInt = 5
    
    //ширина линии. 0 - по ширине кнопки
    @IBInspectable
    var lineWidth: UInt = 0
    
    //цвет линии
    @IBInspectable
    var lineColor: UIColor = UIColor(colorLiteralRed: 238/255.0, green: 163/255.0, blue: 81/255.0, alpha: 1.0)
    
    //цвет линии
    @IBInspectable
    var lineAtTop: Bool = true
    
    
    //MARK: Initializers
    override public init(frame : CGRect)
    {
        super.init(frame : frame)
        setup()
    }
    
    convenience public init()
    {
        self.init(frame:CGRect.zero)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    override public func awakeFromNib()
    {
        super.awakeFromNib()
        setup()
    }
    
    override public func prepareForInterfaceBuilder()
    {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
    
    override public func layoutSublayers(of layer: CALayer)
    {
        super.layoutSublayers(of: layer)
        setup()
    }
}


//MARK: - SETUP AND CONFIGURE
public extension BeautySegmentControl
{
    fileprivate func setup()
    {
        if buttonTitles.replacingOccurrences(of: " ", with: "").isEmpty { return }
        
        //create button
        let arrayOfTitles = buttonTitles.replacingOccurrences(of: " , ", with: ",").replacingOccurrences(of: " ,", with: ",").replacingOccurrences(of: ", ", with: ",").components(separatedBy: ",")
        createButtons(fromTitlesArray: arrayOfTitles)
        createLine()
    }
}


//MARK: - CREATE AND CONFIGURE BUTTONS
public extension BeautySegmentControl
{
    fileprivate func createButtons(fromTitlesArray titles : [String])
    {
        arrayOfButtons.removeAll()
        
        
        for title in titles
        {
            if title == "" { break }
            
            let button = UIButton()
            button.setTitle(title, for: .normal)
            button.setTitleColor(titlesColor, for: .normal)
            button.tag = 777
            button.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(buttonFontSize))
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            arrayOfButtons.append(button)
        }
        
        if needTitleHighlight { arrayOfButtons.first!.setTitleColor(activeButtonColor, for: .normal) }
        if backgroundHighlight { arrayOfButtons.first!.backgroundColor = activeButtonBackgroundColor }
        
        replaceButtons()
    }
    
    
    fileprivate func replaceButtons()
    {
        //remove old buttons
        self.subviews.forEach { (view) in
            if view.tag == 777 { view.removeFromSuperview() }
        }
        
        let count = CGFloat(arrayOfButtons.count)
        
        var xPosForNextButton : CGFloat = 0
        for button in arrayOfButtons
        {
            button.frame = CGRect(x: xPosForNextButton, y: 0, width: self.frame.width / count, height: self.frame.height)
            self.addSubview(button)
            xPosForNextButton += button.frame.width
        }
    }
}


//MARK: - BUTTON ACTIONS
public extension BeautySegmentControl
{
    @objc fileprivate func buttonTapped(_ sender : UIButton)
    {
        if needTitleHighlight
        {
            arrayOfButtons.forEach({ (button) in
                button.setTitleColor(titlesColor, for: .normal)
                if backgroundHighlight { button.backgroundColor = UIColor.clear }
            })
            sender.setTitleColor(activeButtonColor, for: .normal)
            if backgroundHighlight { sender.backgroundColor = activeButtonBackgroundColor }
        }
        
        //send delegate
        for i in 0 ..< arrayOfButtons.count
        {
            if sender == arrayOfButtons[i] { delegate?.segmentDidTapped(atIndex: i) }
        }
        
        //animate line
        if lineEnabled { moveLineAt(button: sender) }
    }
}


//MARK: - LINE
public extension BeautySegmentControl
{
    fileprivate func createLine()
    {
        //remove old layer
        self.layer.sublayers?.forEach({ (layer) in
            if layer.name == "line" { layer.removeFromSuperlayer() }
        })
        
        line = CALayer()
        let buttonWidth = arrayOfButtons.first?.frame.width ?? 0
        let lineWidth_ = lineWidth == 0 ? buttonWidth : CGFloat(lineWidth)
        let yPos : CGFloat = lineAtTop ? 0 : self.frame.height - CGFloat(lineHeight)
        line.frame = CGRect(x: buttonWidth / 2 - lineWidth_ / 2, y: yPos, width: lineWidth_, height: CGFloat(lineHeight))
        line.backgroundColor = lineColor.cgColor
        line.name = "line"
        self.layer.addSublayer(line)
    }
    
    
    fileprivate func moveLineAt(button : UIButton)
    {
        let frame = (line.presentation()!).frame
        line.removeAllAnimations()
        line.frame = frame
        
        UIView.animate(withDuration: 1.2, delay: 0.0, options: [], animations: {
            
            let lineWidth_ = self.lineWidth == 0 ? button.frame.width : CGFloat(self.lineWidth)
            self.line.frame.origin.x = (button.frame.origin.x + button.frame.width / 2) - lineWidth_ / 2
            
        }, completion: nil)
    }
}


//MARK: - SEGMENT PROTOCOL
public protocol DPSegmentControlDelegate
{
    func segmentDidTapped(atIndex : Int)
}
