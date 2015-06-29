//
//  GameViewController.swift
//  FrostByte
//
//  Created by jpk on 6/24/15.
//  Copyright (c) 2015 Parker Kirby. All rights reserved.
//

import UIKit
import SpriteKit

struct TouchInfo {
    var location:CGPoint
    var time:NSTimeInterval
}

extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController {
    
    var myScene = GameScene()
    
    var budget = 30000
    var newBudget = 11000
    
    @IBOutlet weak var numberOfConsultantsLabel: UILabel!
    
    @IBOutlet weak var hireConsultant: UIButton!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var consulantsCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        consulantsCountLabel.hidden = true
        budgetLabel.text = String("Budget: \(budget)")
        hireConsultant.layer.cornerRadius = 10
        hireConsultant.layer.masksToBounds = true
                
        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            
            scene.gameVC = self
            
            let skView = self.view as! SKView
            skView.showsFPS = false
            skView.showsNodeCount = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            myScene = scene
            
            skView.presentScene(scene)
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func consultantButtonPressed(sender: AnyObject) {
        
        myScene.addAnotherManToScene()
        numberOfConsultantsLabel.text = String("Consultants left " + "\(myScene.maxNodeCount)")

        
    }
    
    func moveToEndScreen() {
    
        if let endVC = self.storyboard?.instantiateViewControllerWithIdentifier("endVC") as? UIViewController {
            
            self.presentViewController(endVC, animated: true, completion: nil)
            
            
        } else {
            
            println("This will go to alert screen")
        }
        
    
    }
    
}
