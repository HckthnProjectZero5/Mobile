//
//  MapCollectionViewController.swift
//  AngryProject
//
//  Created by jpk on 6/27/15.
//  Copyright (c) 2015 Parker Kirby. All rights reserved.
//

import UIKit

let reuseIdentifier = "mapCell"

class MapCollectionViewController: UICollectionViewController {

    @IBOutlet var mapCollectionView: UICollectionView!
    var getMapLevelList: [AnyObject] = []
    var x = ""
    var y = ""
    var width = ""
    var length = ""
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        HTTPRequest.session().getMapLevelJSONRequest { () -> Void in
            
            self.getMapLevelList = HTTPRequest.session().getMapLevelList
            println(self.getMapLevelList)
            
            self.mapCollectionView.reloadData()
            
        }
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return getMapLevelList.count
        
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MapCollectionViewCell
        
        cell.outerLabel.layer.cornerRadius = 10
        cell.outerLabel.layer.masksToBounds = true 
        
        if let level = getMapLevelList[indexPath.item] as? [String:AnyObject] {
            
//            println(level)
            
            if let levelInfo = level["level"] as? [String:AnyObject] {
                
                if let mapID = levelInfo["id"] as? Int {
                    
                    cell.mapLabel.text = String(mapID)
                    
                }
                
//                if let properties = levelInfo["properties"] as? [String:AnyObject] {
//                    
//                    if let map = properties["map"] as? [String:AnyObject] {
//                        
//                        var newGameLevel = GameLevel()
//                        newGameLevel.level = levelInfo["id"] as? Int
//                        
//                        for block in map.values.array {
//                            
//                            let blockInfo = block as! [String:AnyObject]
//                            
//                            let x = blockInfo["x"] as! String
//                            self.x = x 
//                            let y = blockInfo["y"] as! String
//                            self.y = y
//                            let length = blockInfo["length"] as! String
//                            self.length = length
//                            let width = blockInfo["width"] as! String
//                            self.width = width
//                            
//                            let CGx = CGFloat(x.toInt()!)
//                            let CGy = CGFloat(y.toInt()!)
//                            let CGw = CGFloat(width.toInt()!)
//                            let CGl = CGFloat(length.toInt()!)
//                            
//                            let newBlock = Block(left: CGx, boom: CGy, wide: CGw, tall: CGl)
//                            newGameLevel.arrayOfBlocks?.append(newBlock)
//                            
////                            var newGameLevel = GameLevel()
////                            newGameLevel.level = levelInfo["id"] as? Int
//                            
//                            
//                            println("block x \(x)")
//                            println("block y \(y)")
//                            println("block length \(length)")
//                            println("block width \(width)")
//                            
//                        }
//                        
//                        println("Our game level array of blocks: \(newGameLevel.arrayOfBlocks)")
//                        
//                    }
//                    
//                }
                
            }
            
        }
        

//
//            for map in mapID {
//                
//                if let id = map["id"] as? Int {
//                    
//                    println("this is the mapID \(id)")
//                    
//                    cell.mapLabel.text = String(id)
//
//                }
//                
//            }
 
//        println(cell)
    
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if let gameScene = self.storyboard?.instantiateViewControllerWithIdentifier("gameScene") as? UIViewController {
            
            self.presentViewController(gameScene, animated: true, completion: nil)
            
            
        } else {
            
            println("This will go to alert screen")
        }

        
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
