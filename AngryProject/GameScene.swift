
//texture atlases

import SpriteKit

enum BodyType: UInt32 {
    
    case man = 1
    case block = 2
    
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var blockNode: SKShapeNode!
    
    var gameVC: GameViewController!
    
    var selectedNode: SKSpriteNode!
    var history: [TouchInfo]?
    
    var mapArray: [AnyObject] = []
    
    var manImageList: [String] = ["man.png", "man_blue.png", "woman.png"]
    
    var nodeCount = 0
    var maxNodeCount = 5
    
    var finalBudget = 0
    
    var theMan: ConsultantNode!
    
    override func didMoveToView(view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        //background image
        var bgImage = SKSpriteNode(imageNamed: "officebg.png")
        bgImage.position = CGPointMake(self.size.width / 2, self.size.height / 2)
        bgImage.zPosition = 0
        
        buildLayout(stageLayout)
        self.addChild(bgImage)
        
        self.mapArray = HTTPRequest.session().getMapLevel
        
    }
    
    func checkIfTheManIsFlat() {
     
        //theMan.hidden = true
        
    }
    
    func addAnotherManToScene() {
        
        if maxNodeCount < 1 {
            showOutOfConsulants()
        return }
        
        var x = Int(arc4random_uniform(UInt32(3)))
        
        let theMan = ConsultantNode(imageNamed: manImageList[x])
        theMan.type = ConsultantType(rawValue: x)
        let manMass: UInt32 = 10
        theMan.name = "theMan"
        selectedNode = theMan
        theMan.physicsBody = SKPhysicsBody(rectangleOfSize: theMan.size)
        theMan.physicsBody?.mass = CGFloat(arc4random_uniform(manMass))
        theMan.xScale = 0.25
        theMan.yScale = 0.25
        theMan.zPosition = 1
        theMan.position = CGPointMake(300,300)
        
        theMan.physicsBody?.categoryBitMask = BodyType.man.rawValue
        theMan.physicsBody?.contactTestBitMask = BodyType.block.rawValue
        
        //nodeCount++
        maxNodeCount--
        
        addChild(theMan)

    
    }
    
    func showOutOfConsulants() {
        
        gameVC.consulantsCountLabel.hidden = false
        gameVC.hireConsultant.hidden = true
        gameVC.moveToEndScreen()
        finalBudget = gameVC.budget
        
        
    }
    
    func budgetScoreMonitor() {
    
        if gameVC.budget == 0 {
            
            println("Perfect Score")
        }
        
    }
    

    func didBeginContact(contact: SKPhysicsContact) {
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody

        if contact.bodyA.categoryBitMask == BodyType.man.rawValue && contact.bodyB.categoryBitMask == BodyType.block.rawValue {
            
            // firstBody = man
            // secondBody = block
            
            firstBody = contact.bodyA
            secondBody = contact.bodyB
            
            let manNode = firstBody.node as! ConsultantNode
            
            // get block value

            switch manNode.type! {
                
            case .Man :
                
                gameVC.budget -= 500
                
            case .Woman :
                
                gameVC.budget -= 1000
                
            case .Blue :
                
                gameVC.budget -= 2000
                
            }
            
            
        } else if contact.bodyB.categoryBitMask == BodyType.man.rawValue && contact.bodyA.categoryBitMask == BodyType.block.rawValue {
            
            // firstBody = block
            // secondBody = man
            
            firstBody = contact.bodyB
            secondBody = contact.bodyA
            
            let manNode = firstBody.node as? ConsultantNode
            println(manNode)
            
            // get block value
            
            switch manNode!.type! {
                
            case .Man :
                
                gameVC.budget -= 500
                
            case .Woman :
                
                gameVC.budget -= 1000
                
            case .Blue :
                
                gameVC.budget -= 2000
                
            }

            gameVC.budgetLabel.text = "Budget: \(gameVC.budget)"
            
            gameVC.newBudget = gameVC.budget
            
            //firstBody.node?.removeFromParent()
            
        }
        
        
        
    }
    
    func loopThroughMapArray() {
        
//        println("Data items count: \(mapArray.count)")
//        
//        // loop through data items
//        if let mapCoordinate = mapArray[0] as? Int {
//        
//            for map in mapCoordinate {
//                
//                let x = map["x"]
//                let y = map["y"]
//                let height = map["height"]
//                let width = map["width"]
//                
//            }
//            
//        }
        
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        //drag 
        
        if touches.count > 1 { return }
        
        if let touch = touches.first as? UITouch {
            
        let location = touch.locationInNode(self)
            
        let node = self.nodeAtPoint(location)
            
        if node.name == "theMan" {
            
            selectedNode = node as? SKSpriteNode
            
            selectedNode.physicsBody?.velocity = CGVectorMake(0, 0)
            
            history = [TouchInfo(location:location, time:touch.timestamp)]
            
            }
            
        }
        
        
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        if let touch = touches.first as? UITouch {
            
        let location = touch.locationInNode(self)
        
            if selectedNode != nil {
            
            selectedNode.position = location
            
            history?.insert(TouchInfo(location:location, time:touch.timestamp),atIndex:0)
                
            }
        
        }
        
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        if (selectedNode != nil && history!.count > 1) {
            var vx:CGFloat = 0.0
            var vy:CGFloat = 0.0
            var previousTouchInfo:TouchInfo?
            // Adjust this value as needed
            let maxIterations = 2
            var numElts:Int = min(history!.count, maxIterations)
            // Loop over touch history
            for index in 1...numElts {
                let touchInfo = history![index]
                let location = touchInfo.location
                if let previousLocation = previousTouchInfo?.location {
                    // distance from last and current touch
                    let dx = location.x - previousLocation.x
                    let dy = location.y - previousLocation.y
                    // time difference between the two
                    let dt = CGFloat(touchInfo.time - previousTouchInfo!.time)
                    // velocity math
                    vx += dx / dt
                    vy += dy / dt
                }
                previousTouchInfo = touchInfo
            }
            let count = CGFloat(numElts-1)
            // flinging with velocity
            let velocity = CGVectorMake(vx/count,vy/count)
            selectedNode?.physicsBody?.velocity = velocity
            // deselect
            selectedNode = nil
            history = nil
     
            
        }
        
    }

    
    func buildLayout(layout: [Block]) {
        
        let gridSize: CGFloat = 20
        let gridMetric = (frame.width / 2) / gridSize
        
        for block in layout {
            
            let size = CGSizeMake(block.wide * gridMetric, block.tall * gridMetric)
            
            let blockNode = BlockNode(rectOfSize: size, cornerRadius: 4)
            
            let x = (block.left * gridMetric) + (size.width / 2) + (frame.width / 2)
            let y = (block.bottom * gridMetric) + (size.height / 2) + 20
            
            blockNode.position = CGPointMake(x, y)
            
            blockNode.fillColor = UIColor.blackColor()
            
            blockNode.physicsBody = SKPhysicsBody(rectangleOfSize: size)
            blockNode.physicsBody?.mass = 5
            blockNode.physicsBody?.dynamic = true
            
            //Collision??
            blockNode.physicsBody?.categoryBitMask = BodyType.block.rawValue

            blockNode.zPosition = 1
            
            addChild(blockNode)
            
        }
        
    }

    override func update(currentTime: CFTimeInterval) {
      
        
    }
    
}

enum ConsultantType: Int {
    
    case Man
    case Blue
    case Woman
    
}

class ConsultantNode: SKSpriteNode {
    
    var type: ConsultantType!
    
}

class BlockNode: SKShapeNode {
    
    var blockValue: Int!
    
}

struct Block {
    
    // x
    var left: CGFloat!
    
    // y
    var bottom: CGFloat!
    
    // width
    var wide: CGFloat!
    
    // height
    var tall: CGFloat!
    
    init(left l: CGFloat, boom b: CGFloat, wide w: CGFloat, tall t: CGFloat) {
        
        left = l
        bottom = b
        wide = w
        tall = t
        
    }
    
}

struct GameLevel {
    
    var level: Int?
    
//    var numberOfBlocks: Int?
    
    var arrayOfBlocks: [Block]?
    
}



let stageLayout: [Block] = [

    
    //first henge
    Block(left: 5, boom: 0, wide: 1, tall: 3),
    Block(left: 7, boom: 0, wide: 1, tall: 3),
    
    Block(left: 5, boom: 3, wide: 3, tall: 1),
    
    //second henge
    Block(left: 9, boom: 0, wide: 1, tall: 3),
    Block(left: 11, boom: 0, wide: 1, tall: 3),
    
    Block(left: 9, boom: 3, wide: 3, tall: 1),
    /*
    Block(left: 7, boom: 4, wide: 1, tall: 3),
    Block(left: 9, boom: 4, wide: 1, tall: 3),
    
    Block(left: 7, boom: 7, wide: 3, tall: 1)
    */
]



