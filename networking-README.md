# Networking  

We use networking in our apps extensively, for sending requests to the server and to fetch the response and read the data returned from the server. These requests are HTTP requests, which can be created using frameworks provided in Swift.  

In apps, when we send the requests to the server, we send it through a URL. This URL will have the location and query instructions to fetch the data from the server according to the API specification. The API specification will have detailed documentation of format of the request and the expected format for the response from the server, which will be implemented in code in the API.  

We have to construct our URL in accordance with the API specification. When we create a URL from a String in Swift we can provide it with details such as the scheme, user, password, host, port, path, path extension, path component, query and fragment. This String should be converted to a URL by converting it by `NSURL(string: )`.

For example consider the URL: https://username:password@www.example.com:8888/path.ext?param=value&query=value#ref  has the values as seen in below table.  

| Component        | Value            |
|:-----------------|:-----------------|
| Scheme           | https            |
| User             | username         |
| Password         | password         |
| Host             | www.example.com  |
| Port             | 8888             |
| Path             | /path.ext        |
| Path Extension   | ext              |
| Path Component   | ["/","path.ext"] |
| query            | param=value      |
|                  | query=value      |
| Fragment         | ref              |

We can construct the URL using the NSURL methods. For example, let's look at how we can construct the above example URL.  

(**NOTE:** *Every code snippet present in this file is exported to an interactive [playground file](Networking-Playground.playground), so you can open it up on Xcode and experiment with it*)  

```swift
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
```

For further details on how to construct the URL for various component values, visit [NSHipster tutorial link](http://nshipster.com/nsurl/) and a [detailed blog here](https://grokswift.com/building-urls/).  

For details about the URL and components, read through Apple's documentation on [NSURL](https://developer.apple.com/library/ios/documentation/Cocoa/Reference/Foundation/Classes/NSURL_Class/index.html#//apple_ref/occ/cl/NSURL).  

HTTP protocol is used for creating requests, from a URL with a method for the request which are GET, POST, UPDATE and DELETE.  

 * GET – The GET method queries our database and retrieves content. GET can be restricted to one, many, or all items. For example, each and every time you go to google.com or view your Facebook/Twitter feed, you are performing a GET request.  

 * POST – The POST verb sends data to the server and then saves it. For example, when you compose a new Facebook or Twitter post and then press the Post/Tweet button, you are creating new content and thus using POST.  

 * UPDATE – The UPDATE method allows you to modify content. When you edit a Facebook post, the UPDATE is being used.  

 * DELETE – As the name implies, DELETE method calls for the deletion of content. When you press the delete button on a Facebook or Twitter post, this method is called.  


**Note**: Starting in iOS 9.0 and OS X v10.11, a new security feature called App Transport Security (ATS) is enabled by default for all HTTP connections made with NSURLSession. ATS requires that HTTP connections use HTTPS. To allow HTTP connection from the app, you should change the details in the information property list file, which is accessed in Xcode. Read through details for [NSAppTransportSecurity](https://developer.apple.com/library/mac/documentation/General/Reference/InfoPlistKeyReference/Articles/CocoaKeys.html#//apple_ref/doc/uid/TP40009251-SW33) and about the [info.plist](https://developer.apple.com/library/mac/documentation/General/Reference/InfoPlistKeyReference/Articles/AboutInformationPropertyListFiles.html#//apple_ref/doc/uid/TP40009254-SW1) file before you edit the details in it.


We have to create a request and then execute the request to get the data from the server. We create the request by creating an object of [NSURLRequest](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSURLRequest_Class/). (More so, to mutate a single request object for a series of URL load requests instead of creating an immutable NSURLRequest object for each load, we create [NSMutableURLRequest](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSMutableURLRequest_Class/index.html#//apple_ref/occ/cl/NSMutableURLRequest) object.)  

The requests are handled in [NSURLSession](https://developer.apple.com/library/mac/documentation/Foundation/Reference/NSURLSession_class/index.html#//apple_ref/occ/cl/NSURLSession). For a URL Session, there should be a configuration for which we use a configuration object. You use this object to configure the timeout values, caching policies, connection requirements, and other types of information that you intend to use with your NSURLSession object.  

The configuration object should be configured appropriately, as the session configured with this object will copy the settings as given in the object and use it to configure the session. Once configured, if you make changes to the configuration object, this will not be reflected in the session object. You'll have to create a new session object and configure it with the changed settings. To read in detail on configuration, see the Apple's documentation for [NSURLSessionConfiguration](https://developer.apple.com/library/mac/documentation/Foundation/Reference/NSURLSessionConfiguration_class/index.html#//apple_ref/occ/clm/NSURLSessionConfiguration/backgroundSessionConfigurationWithIdentifier:).  

The NSURLSession object can be configured as in the below example code snippet:  

```swift
func getDataFromUrl(url: NSURL, completion: (data: NSData?) -> Void) {
      NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
          if let httpResponse = response as? NSHTTPURLResponse {
              if  httpResponse.statusCode != 200 {
                  log.error(error)
                  CVMDataStore.logError("Image could not be downloaded", request: nil, response: httpResponse)
              } else {
                  completion(data: data)
              }
          }
      }.resume()
  }
```

The code snippet above gives a sharedSession for which you don't need a configuration object, and you don't have to create a session object, as so you can directly call it as `NSURLSession.sharedSession()`. The above snippet of code is an example, in which we are giving a URL and fetching data from that which is expected to be an image, thus we give an error specifically for that. If the request has a successful response, then we return the data in a completion block to the calling function.

 The limitation with sharedSession are:  

 * You cannot obtain data incrementally as it arrives from the server.

 * You cannot significantly customize the default connection behavior.  

 * Your ability to perform authentication is limited.

 * You cannot perform background downloads or uploads while your app is not running.

To out grow from the limitations in sharedSession we can use the default session configuration, which can be created by  

```Swift
let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
let session = NSURLSession(configuration: configuration)
```  

The session object can be created with three types of sessionConfiguration objects:

 * [defaultSessionConfiguration](https://developer.apple.com/library/mac/documentation/Foundation/Reference/NSURLSessionConfiguration_class/index.html#//apple_ref/occ/clm/NSURLSessionConfiguration/defaultSessionConfiguration):

 This configuration creates a new configuration object for managing upload and download tasks using the default options. The default session configuration uses a persistent disk-based cache (except when the result is downloaded to a file) and stores credentials in the user’s keychain. It also stores cookies (by default) in the same shared cookie store as the NSURLConnection and NSURLDownload classes.  

 * [epheremalSessionConfiguration](https://developer.apple.com/library/mac/documentation/Foundation/Reference/NSURLSessionConfiguration_class/index.html#//apple_ref/occ/clm/NSURLSessionConfiguration/ephemeralSessionConfiguration):  

 This configuration creates an object that will configure the session which will not store any data to disk, where as it will store the cache, credential and other data to RAM. Thus, in this configuration the if the user quits the app, the data will guaranteed be lost. More so, the cache size when the app is alive, will be limited to the size of the RAM.

 * [backgroundSessionConfigurationWithIdentifier](https://developer.apple.com/library/mac/documentation/Foundation/Reference/NSURLSessionConfiguration_class/index.html#//apple_ref/occ/clm/NSURLSessionConfiguration/backgroundSessionConfigurationWithIdentifier:):  

 This configuration creates the object that when a session is configured with will create the session to have an identifier, and this allows the app to transfer the data in another thread, which is very useful as this will be kept alive and session will be running with the network transfers even when the app is closed by the user.

We can create a URL with *endpoint* and *parameters*/*queryItem* as given in an API for a baseURL, and send a request to get data from it.

You may design the endpoint as a point which refers to expectation of the data for a particular request. Which is to say, if you trying to fetch floor details in a store for your app, you could design the API such as to say endpoint be "getFloors". You'll be sure that this URL is getting you floor details. Similarly, parameters for the same request would be the identification for that store, say "storeID". So now you can construct a URL appending the value of baseURL with endpoint and parameter, for fetching details of the floors for that store.

```Swift
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
```  

The above code give the url to be `http://www.examples.com/getFloors?storeId=1234`, this would make it clearly understandable to the user and anyone who reads the URL, that this fetches the floors for the store having the given storeId.  

You can create a NSURLRequest object from the URL, and get the data from that to be used in the app. In the NSURLRequest object which you can replace by creating a NSURLMutableRequest object instead, can be used to give the HTTPMethod (.GET, .POST etc) and modify the HTTPHeaderFields for the request.  


```Swift
func URLRequest(
    method: Method,
    _ URLString: URLStringConvertible,
    headers: [String: String]? = nil)
    -> NSMutableURLRequest
{
    let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: URLString.URLString)!)
    mutableURLRequest.HTTPMethod = method.rawValue

    if let headers = headers {
        for (headerField, headerValue) in headers {
            mutableURLRequest.setValue(headerValue, forHTTPHeaderField: headerField)
        }
    }

    return mutableURLRequest
}
```

The header fields give information about the type of the request and the data values associated with the request. The header field values will be checked by the server for handling the request properly. We can set the header values, as per our API design and requirements.

`let headers = ["Authorization": credentials.authorizationHeader, "X-ADC-Request-Id": NSUUID().UUIDString]`  

This would provide the header fields Authorization and X-ADC-Request_Id in the request, as seen in the below image.

![headerFields](ScreenShots/HeaderFields.png "Header Field For The Request")  

We can also get the data as JSON from the server, which can be converted to readable data type in Swift, which is a Dictionary and each data can be read separately and assigned to a distinguished identifier for that value.

The JSON as in the response for the request:  

```json
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

```Swift
let json = JSON(data: data)
guard let floorsJsonArray = json["result"] ["floors"].array else {
  //Show error saying can't get data from JSON
}
//Do something with the data
```  


Where JSON( ) is can be designed to be a function or a structure(the case here) or any data structure you feel is appropriate, and should return a Dictionary with the values.

```Swift
struct JSON {
  public init(data:NSData, options opt: NSJSONReadingOptions = .AllowFragments, error: NSErrorPointer = nil) {
        do {
           let object: AnyObject = try NSJSONSerialization.JSONObjectWithData(data, options: opt)
           self.init(object)
           } catch let aError as NSError {
             if error != nil {
               error.memory = aError
             }
           self.init(NSNull())
         }
  }
 }
 ```   

Now you can get the values from the JSON object, from a function:

```Swift
if let floor = Floor(fromJson: floorJson)

//Where Floor class is :

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

The above way of extracting data from the response is one of many ways from which you can accomplish the same.

There are very good and informative stuff about networking and NSURLSession which you should read to gather more detailed information before you jump into implementation of networking for your app,

 * For NSURLSession tutorial in depth:[click here](http://code.tutsplus.com/series/working-with-nsurlsession--mobile-22700). This has the tutorial in Objective-C, which is similar to Swift and should not be a problem to understand. There are four parts and it is highly recommended to read the [first part](http://code.tutsplus.com/tutorials/networking-with-nsurlsession-part-1--mobile-21394) without a miss, as they explain in depth the difference with NSURLConnection and NSURLSession, which to use and when to use each of it.  

 * For Apple's documentation on using NSURLSession:[click here](https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/URLLoadingSystem/Articles/UsingNSURLSession.html).  

 * For [Raywenderlich's](https://www.raywenderlich.com) tutorial with a sample project:[click here](https://www.raywenderlich.com/110458/nsurlsession-tutorial-getting-started)  

 * For URL loading system Apple documentation:[click here](https://developer.apple.com/library/prerelease/content/documentation/Cocoa/Conceptual/URLLoadingSystem/URLLoadingSystem.html#//apple_ref/doc/uid/10000165i).  

 * For a very informative blog on networking in swift:[click here](https://medium.com/swift-programming/http-in-swift-693b3a7bf086#.wisl8wxas).  
