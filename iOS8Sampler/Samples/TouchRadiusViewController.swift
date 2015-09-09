//
//  TouchRadiusViewController.swift
//  iOS8Sampler
//
//  Created by Shuichi Tsutsumi on 2015/02/18.
//  Copyright (c) 2015 Shuichi Tsutsumi. All rights reserved.
//

import UIKit


class TouchRadiusViewController: UIViewController {

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: "TouchRadiusViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    // =========================================================================
    // MARK: Private
    
    private func createHaloAt(location: CGPoint, withRadius radius: CGFloat) {
        
        let halo = PulsingHaloLayer()
        halo.repeatCount = 1
        halo.position = location
        halo.radius = radius * 2.0
        halo.fromValueForRadius = 0.5
        halo.keyTimeForHalfOpacity = 0.7
        halo.animationDuration = 0.8
        self.view.layer.addSublayer(halo)
    }
    
    
    // =========================================================================
    // MARK: Touch Handlers
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for obj: AnyObject in touches {
            
            let touch = obj as! UITouch
            let location = touch.locationInView(self.view)
            let radius = touch.majorRadius
            
            self.createHaloAt(location, withRadius: radius)
        }
    }
}
