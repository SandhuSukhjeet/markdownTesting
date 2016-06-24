/*:
# Networking
This playground file contains every code snippet that is present in the networking [README.md](networking-README.md) file.
 
 
For example consider the URL: https://username:password@www.example.com:8888/path.ext?param=value&query=value#ref  has the values as seen in below table. We can construct the URL using the NSURL methods. For example, let's look at how we can construct the above example URL.
*/
import Foundation
 let urlString = "http://www.example.com"
 let url = NSURL(string: urlString)
 let urlComponent = NSURLComponents.init(string: (url?.URLByAppendingPathComponent("path.ext").absoluteString)!)
 urlComponent?.port = 8888
 urlComponent?.user = "user"
 urlComponent?.password = "password"
 urlComponent?.queryItems = [(NSURLQueryItem.init(name: "param", value: "value")),(NSURLQueryItem.init(name: "query", value: "value"))]
 urlComponent?.fragment = "ref"
 print(urlComponent)  //prints: Optional(<NSURLComponents 0x7fead8e054f0> {scheme = http, user = user, password = password, host = www.example.com, port = 8888, path = /path.ext, query = param=value&query=value, fragment = ref})

 let newURL = urlComponent?.URL
 print(newURL)  //prints: Optional(http://user:password@www.example.com:8888/path.ext?param=value&query=value#ref)
/*:
 The NSURLSession object can be configured as in the below example code snippet:  
 */
 func getDataFromUrl(url: NSURL, completion: (data: NSData?) -> Void) {
    NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
        if let httpResponse = response as? NSHTTPURLResponse {
            if  httpResponse.statusCode != 200 {
                //Do something that shows an error
            } else {
                //Send the data
                completion(data: data)
            }
        }
    }.resume()
 }
/*:
 The code snippet above gives a sharedSession for which you don't need a configuration object, and you don't have to create a session object, as so you can directly call it as `NSURLSession.sharedSession()`. The above snippet of code is an example, in which we are giving a URL and fetching data from that which is expected to be an image, thus we give an error specifically for that. If the request has a successful response, then we return the data in a completion block to the calling function.
 
 The limitation with sharedSession are:
 
 * You cannot obtain data incrementally as it arrives from the server.
 
 * You cannot significantly customize the default connection behavior.
 
 * Your ability to perform authentication is limited.
 
 * You cannot perform background downloads or uploads while your app is not running.
 
 To out grow from the limitations in sharedSession we can use the default session configuration, which can be created by  
 */
 let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
 let session = NSURLSession(configuration: configuration)
/*:
You may design the endpoint as a point which refers to expectation of the data for a particular request. Which is to say, if you trying to fetch floor details in a store for your app, you could design the API such as to say endpoint be "getFloors". You'll be sure that this URL is getting you floor details. Similarly, parameters for the same request would be the identification for that store, say "storeID". So now you can construct a URL appending the value of baseURL with endpoint and parameter, for fetching details of the floors for that store.  
 */
let endpoint = "getFloors"
let storeID = "1234"
if let baseURL = NSURL(string: "http://www.examples.com") {
    //Create a urlComponents which can be parsed to a URL later.
    let urlComponents = NSURLComponents.init(string: baseURL.URLByAppendingPathComponent(endpoint).absoluteString)!
    
    //Add the query to the urlComponents.
    urlComponents.queryItems = [NSURLQueryItem.init(name: "storeId", value: storeID)]
    
    //Get the URL from the components.
    let url = urlComponents.URL!
    
    // Do something with the url.
}
/*:
The above code give the url to be `http://www.examples.com/getFloors?storeId=1234`, this would make it clearly understandable to the user and anyone who reads the URL, that this fetches the floors for the store having the given storeId.

You can create a NSURLRequest object from the URL, and get the data from that to be used in the app. In the NSURLRequest object which you can replace by creating a NSURLMutableRequest object instead, can be used to give the HTTPMethod (.GET, .POST etc) and modify the HTTPHeaderFields for the request.
 
For handling the HTTPMethod which are .GET, .POST etc to be given to the NSURLRequest, we cannot specify it directly as we cannot get the methos value without an instance of the URLRequest object, so we can create an enum to hold all possible values that HTTPMethod can take and select that in the NSURLRequest object instance once it is created.

*/
public enum Method: String {
    case OPTIONS, GET, HEAD, POST, PUT, PATCH, DELETE, TRACE, CONNECT
}
func URLRequest(method: Method, URLString: String, headers: [String: String]? = nil) -> NSMutableURLRequest
{
    // Create a mutable URL request
    let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: URLString)!)
    // Provide the HTTPMethod for the request
    mutableURLRequest.HTTPMethod = method.rawValue
    // If there are header fields, set those for the request
    if let headers = headers {
        for (headerField, headerValue) in headers {
            mutableURLRequest.setValue(headerValue, forHTTPHeaderField: headerField)
        }
    }
    // Return the created request, which can be handled by the caller
    return mutableURLRequest
}
/*:
The header fields give information about the type of the request and the data values associated with the request. The header field values will be checked by the server for handling the request properly. We can set the header values, as per our API design and requirements.

We can also get the data as JSON from the server, which can be converted to readable data type in Swift, which is a Dictionary and each data can be read separately and assigned to a distinguished identifier for that value.

The JSON as in the response for the request:
```
{
    "errors": [],
    "result": {
        "floors": [{
        "floorId": "166D1A8B-2DFE-45C5-8E50-29639E1DE4E6",
        "storeId": "ST001",
        "name": "Floor 1",
        "numTotalItems": 3,
        "numDisplays": 5,
        "numDisplaysChecked": 0,
        "numTotalItemsChecked": 0,
        "floorImage": {
        "imageUrl": "http://www.example.com/getImage?ImageId=27e866379347d9741033521f2d76d775910019d1fbe76af5757113c27505fd00ccb19d8810632cb5f41604c23cf5ab297ecc15cdb7ebcf3e3e37d9f384ea44bd",
        "imageHash": "27e866379347d9741033521f2d76d775910019d1fbe76af5757113c27505fd00ccb19d8810632cb5f41604c23cf5ab297ecc15cdb7ebcf3e3e37d9f384ea44bd"
        }
        }, {
        "floorId": "43967813-4E0B-467D-B571-B93865708DD7",
        "storeId": "ST001",
        "name": "Floor 1",
        "numTotalItems": 0,
        "numDisplays": 0,
        "numDisplaysChecked": 0,
        "numTotalItemsChecked": 0,
        "floorImage": {
        "imageUrl": null,
        "imageHash": null
        }
        }]
    }
}
```
We can extract the data from the JSON as:
*/
struct JSON {
    //You should make the below init() public
    init(data:NSData, options opt: NSJSONReadingOptions = .AllowFragments, error: NSErrorPointer = nil) {
        do {
            let object: AnyObject = try NSJSONSerialization.JSONObjectWithData(data, options: opt)
            //This is the object that will have the data from the JSON. This should be handled so as to get the data in form of Array, String, Dictionary etc and return that to the caller.
            self.init(object: object)
        } catch let aError as NSError {
            if error != nil {
                error.memory = aError
            }
            self.init(object: NSNull())
        }
    }
    
    init(object: AnyObject) {
       //Do something with the object
    }
}

/*:
```
 let data = NSData()
 let json = JSON(data: data)
 ```
Where JSON() can be designed to be a function or a structure(the case here) or any data structure you feel is appropriate, and should return a Dictionary with the values.
If JSON is in the above shown JSON example format, then the data can be retrived as below example:
 ```
 guard let floorsJsonArray = json["result"] ["floors"].array else {
    //Show error saying can't get data from JSON
 }
 //Do something with the data
```
Now you can get the values from the JSON object, from a function:  
 `if let floor = Floor(fromJson: floorJson)`  
 
 Where Floor class is having:
 
```
init?(fromJson json: JSON) {
    guard
        let name = json["name"].string,
        let floorId = json["floorId"].string,
        let storeId = json["storeId"].string,
        let numDisplays = json["numDisplays"].int,
        let numDisplaysChecked = json["numDisplaysChecked"].int,
        let numTotalItemsChecked = json["numTotalItemsChecked"].int,
        let numTotalItems = json["numTotalItems"].int
        else {
            return nil
    }
    self.name = name
    self.floorId = floorId
    self.storeId = storeId
    let floorImage = json["floorImage"]
    if let image = CVMDisplayImage(fromJson: floorImage) {
        self.image = image
    } else {
        self.image = nil
    }
    self.numDisplays = numDisplays
    self.numDisplaysChecked = numDisplaysChecked
    self.numTotalItemsChecked = numTotalItemsChecked
    self.numTotalItems = numTotalItems
}
 ```
 The above shown way of extracting data from the response is one of many ways from which you can accomplish the same.
 */

