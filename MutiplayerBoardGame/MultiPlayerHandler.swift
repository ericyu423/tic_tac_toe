//
//  MultiPlayerHandler.swift
//  MutiplayerBoardGame
//
//  Created by eric yu on 4/30/17.
//  Copyright © 2017 eric yu. All rights reserved.
//

import UIKit
import MultipeerConnectivity

enum Notes: String {
    
    case didChange = "MPC_DidChangeStateNotification"
    case didReceive = "MPC_DidRecieveDataNotification"
    
    var notification : Notification.Name  {
        return Notification.Name(rawValue: self.rawValue )
    }
}
class MultiPlayerHandler: NSObject,MCSessionDelegate,MCAdvertiserAssistantDelegate {
    //MARK: Variables
    var mcPeerID:MCPeerID!
    var mcSession:MCSession!
    var mcBrowserViewController:MCBrowserViewController!
    var mcAdvertiserAssistant:MCAdvertiserAssistant!
    
    
    //MARK: Custom Methods
    func setupPeerWithDisplayName(displayName:String){
        mcPeerID = MCPeerID(displayName: displayName)
    }
    
    func setupSession(){
        mcSession = MCSession(peer: mcPeerID)
        mcSession.delegate = self
        
    }
    
    func setupBrowser(){
        mcBrowserViewController = MCBrowserViewController(serviceType: "my-game", session: mcSession)
        
    }
    
    func advertiseSelf(advertise:Bool){
        if advertise {
            mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "my-game", discoveryInfo: nil, session: mcSession)
            mcAdvertiserAssistant.start()
        }else{
            mcAdvertiserAssistant!.stop()
            mcAdvertiserAssistant = nil
        }
        
    }
    
    
    //MARK: Session Delegate Methods
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        let userInfo:[String:Any] = ["peerID" : peerID, "state" : state.rawValue]
       
        DispatchQueue.main.async() {
            NotificationCenter.default.post(name: Notes.didChange.notification, object: nil, userInfo: userInfo)
            
        }
    }
    
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let userInfo:[String : Any] = ["data":data,"peerID":peerID]
        DispatchQueue.main.async() {
            NotificationCenter.default.post(name: Notes.didReceive.notification, object: nil, userInfo: userInfo)
            
        
            
        }
       

        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    
}
