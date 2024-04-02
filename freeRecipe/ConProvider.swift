import UIKit
import WatchConnectivity

class ConProvider: NSObject, WCSessionDelegate {
    
    private let session: WCSession
    var info: [Con] = []
    var recievedInfo : [Con] = []
    var lastMessage : CFAbsoluteTime = 0
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        
#if os(iOS)
        print("Connection provider inited on phone")
#endif
        
#if os(watchOS)
        print("Connection provider inited on watch")
#endif
        
        self.connect()
    }
    
    func connect() {
        guard WCSession.isSupported() else {
            print("WCSession is not supported")
            return
        }
        
        session.activate()
    }
    
    func send(message: [String:Any]) -> Void {
        session.sendMessage(message, replyHandler: nil) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
#if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
#endif
    
    func initToSend(recipes:Recipes) {
        info.removeAll()
        
        for item in recipes.items {
            var obj = Con()
            obj.initWithData(name: item.name, steps: item.steps, ingredFirst: item.ingredFirst, ingredSecond: item.ingredSecond)
            info.append(obj)
        }
        
        let encoder = JSONEncoder()
        let jsonData = try! encoder.encode(info)
        
        sendWatchMessage(jsonData)
    }
    
    func sendWatchMessage(_ msgData : Data) {
        let currentTime = CFAbsoluteTimeGetCurrent()
        
        if lastMessage + 0.5 > currentTime {
            return
        }
        
        if (session.isReachable) {
            print("Sending watch msg")
            let message = ["progData" : msgData]
            session.sendMessage(message, replyHandler: nil)
            lastMessage = CFAbsoluteTimeGetCurrent()
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("entered didrecieved message")
        
        if let progData = message["progData"] as? Data {
            
            print("progData Recieved")
            let decoder = JSONDecoder()
            
            do {
                
                let loadedPerson = try decoder.decode([Con].self, from: progData)
                self.recievedInfo = loadedPerson
                
                print("Recieved and DECODED INFO!")
            }
            catch{
                print("Error decoding data: \(error)")
            }
            
            
        }
    }
    
}
