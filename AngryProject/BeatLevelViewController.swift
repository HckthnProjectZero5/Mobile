//
//  BeatLevelViewController.swift
//  AngryProject
//
//  Created by jpk on 6/27/15.
//  Copyright (c) 2015 Parker Kirby. All rights reserved.
//

import UIKit

class BeatLevelViewController: UIViewController {

    @IBOutlet weak var originalBudgetLabel: UILabel!
    @IBOutlet weak var newBudgetLabel: UILabel!
    @IBOutlet weak var finalScoreLabel: UILabel!
    @IBOutlet weak var sketchBg: UIImageView!
    
    var myScene = GameScene()
    var gameViewController = GameViewController()
    
    var newBudget = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        originalBudgetLabel.text = String(gameViewController.budget)
        newBudgetLabel.text = String(gameViewController.budget - gameViewController.newBudget)
        finalScoreLabel.text = String(gameViewController.budget * gameViewController.newBudget / 10000)
    
        let bgImage = UIImage(named: "sketchBg.jpg")
        sketchBg.image = bgImage
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectNextMap(sender: AnyObject) {
        
        if let mapVC = self.storyboard?.instantiateViewControllerWithIdentifier("mapVC") as? UIViewController {
            
            self.presentViewController(mapVC, animated: true, completion: nil)  
            
            
        } else {
            
            println("This will go to alert screen")
        }

        
    }
    
    @IBAction func endGame(sender: AnyObject) {
        
        if let startVC = self.storyboard?.instantiateViewControllerWithIdentifier("startVC") as? UIViewController {
            
            self.presentViewController(startVC, animated: true, completion: nil)
            
            
        } else {
            
            println("This will go to alert screen")
        }

        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
