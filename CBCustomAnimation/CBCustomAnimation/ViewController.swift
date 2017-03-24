//
//  ViewController.swift
//  CBCustomAnimation
//
//  Created by 这个夏天有点冷 on 2017/3/24.
//  Copyright © 2017年 YLT. All rights reserved.
//

import UIKit

private let twinkleInteval = 0.6
private let layerKey = "layerKey"

class ViewController: UIViewController {

    @IBOutlet weak var selectBtn: UIButton!
    
    var myTimer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //  MARK:- 按钮点击
    @IBAction func selectBtnClicked(_ sender: UIButton) {
        
        myTimer = Timer.init(timeInterval: twinkleInteval, repeats: true, block: { [weak self]  (timer) in
            let frame = self?.selectBtn.frame
            let shapeLayer = self?.roundLayer(with: frame!)
            self?.view.layer.insertSublayer(shapeLayer!, below: self?.selectBtn.layer)
            self?.twinkle(layer: shapeLayer!)
        })
        RunLoop.current.add(myTimer!, forMode: RunLoopMode.commonModes)
    }
}

extension ViewController {
    func roundLayer(with frame : CGRect) -> CAShapeLayer {
        let layer = CAShapeLayer.init()
        layer.path = UIBezierPath.init(roundedRect: frame, cornerRadius: frame.height / 2).cgPath
        layer.bounds = frame
        layer.position = selectBtn.center
        layer.fillColor = UIColor.init(red: 34/255.0, green: 192/255.0, blue: 100/255.0, alpha: 1).cgColor
        return layer
    }
    
    func twinkle(layer : CAShapeLayer) {
        //  放大动画
        let basicAni = CABasicAnimation.init(keyPath: "transform")
        basicAni.toValue = NSValue.init(caTransform3D: CATransform3DMakeScale(4, 4, 1))
        
        //  颜色渐变动画
        let basicAni1 = CABasicAnimation.init(keyPath: "opacity")
        basicAni1.fromValue = NSNumber.init(floatLiteral: 0.75)
        basicAni1.toValue = NSNumber.init(floatLiteral: 0)
        
        //  动画组
        let aniGroup = CAAnimationGroup.init()
        aniGroup.animations = [basicAni, basicAni1]
        aniGroup.duration = twinkleInteval * 3
        aniGroup.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
        aniGroup.setValue(layer, forKey: layerKey)
        aniGroup.delegate = self
        
        layer.opacity = 0
        layer.add(aniGroup, forKey: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (myTimer != nil) {
            myTimer?.invalidate()
        }
    }
}

extension ViewController : CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let layer = anim.value(forKey: layerKey) as? CALayer else {
            return
        }
        
        layer.removeFromSuperlayer()
    }
}


