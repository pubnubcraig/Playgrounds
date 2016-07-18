import UIKit
import XCPlayground
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true
/*:
 # Getting Started with Swift and PubNub
 
 In this playground, you will run through the basics of utilizing the PubNub Swift SDK in your iOS project. You will learn about:
 - Configuring a PubNub client
 - Listening to a PubNub channel
 - Subscribing to a PubNub channel
 - Publishing to a PubNub channel
 - Receiving messages
 
 With these skills you'll be able to incorporate realtime functionality into your iOS applications.
 
 ---
 
 ## Configuring a PubNub client
 
 In order to use the PubNub features, you must create a PubNub instance property. Open your `AppDelegate.swift` file and add this before the class declaration:
 */

import PubNub
/*:
 We will then create the PubNub instance, replace the keys passed into `PNConfiguration()` with your own respective publish and subscribe keys.
 */
class AppDelegate: UIResponder, UIApplicationDelegate {
    
  var window: UIWindow?
  lazy var client: PubNub = {
        let config = PNConfiguration(publishKey: "pub-c-63c972fb-df4e-47f7-82da-e659e28f7cb7", subscribeKey: "sub-c-28786a2e-31a3-11e6-be83-0619f8945a4f")
        let pub = PubNub.clientWithConfiguration(config)
        return pub
    }()
}


/*:
 > **Note:**
 The client variable is declared inside of the example classes below just so the PubNub methods can be demonstrated in the playground. It is still recommended as shown above, to declare it in the `AppDelegate` and access the client variable through the `AppDelegate` when you need it in other classes.
*/
 
/*:
 ## Listen
 
 In order to receive messages from a channel, you must declare your current instance as a listener. Below, the `ListenViewController` class becomes a listener using the `addListener()` method in the `viewDidLoad()` by passing in `self`.
 > **Note:**
 Make sure to add the `PNObjectEventListener` protocol in your class declaration.
 */

import PubNub

class ListenViewController: UIViewController, PNObjectEventListener {
    lazy var client: PubNub = {
        let config = PNConfiguration(publishKey: "pub-c-63c972fb-df4e-47f7-82da-e659e28f7cb7", subscribeKey: "sub-c-28786a2e-31a3-11e6-be83-0619f8945a4f")
        let pub = PubNub.clientWithConfiguration(config)
        return pub
    }()
    override func viewDidLoad() {
        client.addListener(self)
    }
}

/*:
 ## Subscribe
 
 Let's go ahead and use the `subscribe()` function next. This function causes the client to create an open TCP socket to the PubNub Real-Time Network and begin listening for messages on a specified channel. To subscribe to a channel the client must send the appropriate subscribeKey at initialization.
 By default a newly subscribed client will only receive messages published to the channel after the `subscribeToChannels()` call completes. Include the code in the `viewDidLoad()` function to subscribe to a channel.
 */

import PubNub

class ListenSubViewController: UIViewController {
    var client: PubNub = {
        let config = PNConfiguration(publishKey: "pub-c-63c972fb-df4e-47f7-82da-e659e28f7cb7", subscribeKey: "sub-c-28786a2e-31a3-11e6-be83-0619f8945a4f")
        let pub = PubNub.clientWithConfiguration(config)
        return pub
    }()
    override func viewDidLoad() {
        client.subscribeToChannels(["my_channel"], withPresence: false)
    }
}

/*:
 ## Publish
 
 You can publish to a channel with the `publish()` function. To publish a message you must first specify a valid publishKey at initialization. A successfully published message is replicated across the PubNub Real-Time Network and sent simultaneously to all subscribed clients on a channel.
 */

import PubNub

class PublishObject: NSObject {
    var client: PubNub = {
        let config = PNConfiguration(publishKey: "pub-c-63c972fb-df4e-47f7-82da-e659e28f7cb7", subscribeKey: "sub-c-28786a2e-31a3-11e6-be83-0619f8945a4f")
        let pub = PubNub.clientWithConfiguration(config)
        return pub
    }()
    
    override init() {
        super.init()
        client.publish("Hello from the PubNub Swift SDK cody has a big butt haha", toChannel: "my_channel",
                       compressed: false, withCompletion: { (status) -> Void in
                        if status.error {
                            // Error publishing message to specified channel.
                            print("Error")
                        } else {
                            // Handle message publish error. Check 'category' property
                            // to find out possible reason because of which request did fail.
                            // Review 'errorData' property (which has PNErrorData data type) of status
                            // object to get additional information about issue.
                            //
                            // Request can be resent using: status.retry()
                            print("Success")
                        }
        })
    }
}

let publishObject = PublishObject()
/*:
 Once a `PublishObject` instance is created, the client will publish a message to 'my_channel' and you can see in the playground whether the message successfully went through or failed with the print statement that is executed.
 */

/*:
 ## Receiving messages
 
Once you declare your current instance as a listener and are subscribed to a channel, you can receive messages with the `client(_:didReceiveMessage:)` PubNub callback function. Below we publish the message: "Hello from the PubNub Swift SDK to "my_channel". If the message successfully went through, you're able to see that same message from the `print()` statement in the `client(_:didReceiveMessage:)` function.
 */

class PubNubCallbackDemoObject: NSObject, PNObjectEventListener {
    var client: PubNub = {
        let config = PNConfiguration(publishKey: "pub-c-63c972fb-df4e-47f7-82da-e659e28f7cb7", subscribeKey: "sub-c-28786a2e-31a3-11e6-be83-0619f8945a4f")
        let pub = PubNub.clientWithConfiguration(config)
        return pub
    }()
    
    override init() {
        super.init()
        client.addListener(self)
        client.subscribeToChannels(["my_channel"], withPresence: false)
        client.publish("Hello from the PubNub Swift SDK", toChannel: "my_channel",
                       compressed: false, withCompletion: { (status) -> Void in
                        if status.error {
                            // Error publishing message to specified channel.
                            print("Error")
                        } else {
                            // Handle message publish error. Check 'category' property
                            // to find out possible reason because of which request did fail.
                            // Review 'errorData' property (which has PNErrorData data type) of status
                            // object to get additional information about issue.
                            //
                            // Request can be resent using: status.retry()
                            print("Success")
                        }
        })
    }
    
    // Handle new message from one of channels on which client has been subscribed.
    func client(client: PubNub, didReceiveMessage message: PNMessageResult) {
        // Handle new message stored in message.data.message
        if message.data.actualChannel != nil {
            
            // Message has been received on channel group stored in
            // message.data.subscribedChannel
        }
        else {
            
            // Message has been received on channel stored in
            // message.data.subscribedChannel
        }
        
        print("Received message: \(message.data.message) on channel " +
            "\((message.data.actualChannel ?? message.data.subscribedChannel)!) at " +
            "\(message.data.timetoken)")
        
        //Only needed when running in playground
        XCPlaygroundPage.currentPage.finishExecution()
    }
}

let pubNubCallbackDemoObject = PubNubCallbackDemoObject()

/*:
 
---
 
# Conclusion
 
Those are the basics to get you up and running with the PubNub Swift SDK. Check out the [PubNub Swift API reference guide](https://www.pubnub.com/docs/swift/api-reference#subscribe).
 */