
import UIKit

private let defaults = NSUserDefaults.standardUserDefaults()
private let _singleton = HTTPRequest()

let API_URL = "https://fierce-wave-2814.herokuapp.com"

class HTTPRequest: NSObject {
    
    //when accessed this will be railsrequest.session - singleton class
    class func session() -> HTTPRequest { return _singleton }
    
    var getMapLevelList: [AnyObject] = []
    var getMapLevel: [AnyObject] = []
    
    func getMapLevelJSONRequest(completion: () -> Void) {
        
        var info = [
            
            "method" : "GET",
            "endpoint" : "/levels"
            
            ] as [String:AnyObject]
        
        requestWithInfo(info, andCompletion: { (responseInfo) -> Void in
            
//            println(responseInfo)
            
            if let dataForMap = responseInfo as? [AnyObject] {
                
                //if let dataForMap = responseInfo?["level"] as? String {
                
                self.getMapLevelList = dataForMap
                println(dataForMap)
                
                completion()
                
                //}
                
            }
            
        })
        
        
    }
    
    func getMapLevelWithID(idNumber: Int) {
        
        var info = [
        
            "method" : "GET",
            "endpoint" : "/levels/\(idNumber)"
        
            ] as [String:AnyObject]
        
        requestWithInfo(info, andCompletion: { (responseInfo) -> Void in
            
            println(responseInfo)
            
            if let dataForMap = responseInfo as? [AnyObject] {
                
                self.getMapLevel = dataForMap
                
            }
            
        })
        
        
    }
    
    //we make the completion optional nil if it doesn't complete
    func requestWithInfo(info: [String:AnyObject], andCompletion completion: ((responseInfo: AnyObject?) -> Void)?) {
        
        let endpoint = info["endpoint"] as! String
        
        //query parameters for GET request
        if let query = info["query"] as? [String:AnyObject] {
            
            var first = true
            
            for (key,value) in query {
                
                //choose sign if it is first ?(then) else :
                var sign = first ? "?" : "&"
                
                //endpoint += endpoint + "\(sign)\(key)=\(value)"
                
                //set first the first time it runs
                first = false
                
            }
            
        }
        
        if let url = NSURL(string: API_URL + endpoint) {
            
            let request = NSMutableURLRequest(URL: url)
            
            //NSMutableURLRequest is needed to with HTTPMethod
            request.HTTPMethod = info["method"] as! String
            
            //////// BODY (only run this code if HTTPMethod != "GET"
            
            if let bodyInfo = info["parameters"] as? [String:AnyObject] {
                
                let requestData = NSJSONSerialization.dataWithJSONObject(bodyInfo, options: NSJSONWritingOptions.allZeros, error: nil)
                
                let jsonString = NSString(data: requestData!, encoding: NSUTF8StringEncoding)
                
                let postLength = "\(jsonString!.length)"
                
                request.setValue(postLength, forHTTPHeaderField: "Content-Length")
                
                let postData = jsonString?.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
                
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                request.HTTPBody = postData
                
            }
            
            //////// BODY
            
            
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (response, data, error) -> Void in
                
                //println("test 1 \(response)")
                //println(data)
                //println(error)
                
                //dictionary that comes back
                if let json: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: nil) {
                    
                    //safe optional in case no data comes back
                    //responseInfo completion block is a function being run above
                    completion?(responseInfo: json)
                    
                }
                
            })
            
        }
        
        
    }
    
    
}
