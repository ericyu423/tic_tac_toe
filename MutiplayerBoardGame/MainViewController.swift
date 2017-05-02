//
//  ViewController.swift
//  MutiplayerBoardGame
//
//  Created by eric yu on 4/28/17.
//  Copyright © 2017 eric yu. All rights reserved.
//

import UIKit
import MultipeerConnectivity


class MainViewController: UIViewController {
    //MARK: variables
    var currentPlayer: String!
    var appDelegate: AppDelegate = {
        var app = AppDelegate()
        app = UIApplication.shared.delegate as! AppDelegate
        return app
    }()
    
    let boardImageView: UIImageView = {
      let iv = UIImageView(image: UIImage(named: "field"))
         iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
 
    var boardView: TicTacView = {
        var bv = TicTacView()
        bv.translatesAutoresizingMaskIntoConstraints = false
        bv.backgroundColor = .white
        return bv
    }()
    
    var playButton: UIButton = {
      
        var bt = UIButton(type: .system)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.backgroundColor = .clear
        bt.layer.borderColor = UIColor.black.cgColor
        bt.layer.borderWidth = 1
        bt.addTarget(self, action: #selector(handlePlayButton), for: .touchUpInside)
        bt.setTitleColor(.black, for: UIControlState.normal)
        bt.setTitle("Start Game", for: .normal)
        bt.tintColor = .black
        bt.titleLabel?.textColor = .black
        bt.layer.cornerRadius = 10
        return bt
    }()
    
    lazy var pView:[gamePieceView] = {
        var v = [gamePieceView]()
        for i in 1...9 {
            var bt = gamePieceView()
            bt.backgroundColor = .clear
            bt.tag = i
            bt.isUserInteractionEnabled = true
            bt.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapped)))
            bt.clearsContextBeforeDrawing = true
 
            v.append(bt)
        }
        return v
    }()
  
 
    let stackView: [UIStackView] = {
       var sv = [UIStackView]()
        for i in 0...2 {
            let stackView = UIStackView()
            
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.distribution = .fillEqually
            stackView.axis = .horizontal
            stackView.spacing = 25
            stackView.backgroundColor = .red
            sv.append(stackView)
        }
        return sv
    }()

    var widthBoard: CGFloat {
        return min(view.frame.width - 10, view.frame.height - 10)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .white
        setUpNavigationBar()
        
        appDelegate.multiplayerHandler.setupPeerWithDisplayName(displayName: UIDevice.current.name)
        appDelegate.multiplayerHandler.setupSession()
        appDelegate.multiplayerHandler.advertiseSelf(advertise: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(peerChnagedStateWithNotification), name: Notes.didChange.notification, object: nil)
  
        NotificationCenter.default.addObserver(self, selector: #selector(handleReceivedDataWithNotification), name: Notes.didReceive.notification, object: nil)
        
        currentPlayer = "x"
    }
    
    func peerChnagedStateWithNotification(_ notification: NSNotification){
        let userInfo = NSDictionary(dictionary: notification.userInfo!)
        let state = userInfo.object(forKey: "state") as! Int
        
        if state != MCSessionState.connecting.rawValue{
            self.navigationItem.title = "Connected"
        }
    }
    
    func handleReceivedDataWithNotification(_ notification: NSNotification){
        
        
        let userInfo = notification.userInfo! as Dictionary
        let receivedData: Data = userInfo["data"] as! Data
        
        do {
            
            
            let message = try JSONSerialization.jsonObject(with: receivedData  , options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
            
            let senderPeerID: MCPeerID = userInfo["peerID"] as! MCPeerID
            let senderDisplayName = senderPeerID.displayName
            
            //get  string from json dict
            
            var view:Int? = message.object(forKey: "field") as? Int
            var player:String? = message.object(forKey: "player") as? String
            
            if view != nil && player != nil {
                pView[view!].player = player
                pView[view!].setPlayer(player: player!)
                
                if player == "x"{
                    currentPlayer = "o"
                }else{
                    currentPlayer = "x"
                }
                
                //TODO: check result
                
                
            }
                
            
            
            
            
        }catch{
            
        }
        
    }
    

    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutPlayButton()
        layoutGameBoard()
        layoutPieces()
        
   
    }
    

}

//MARK: viewDidLod functions
extension MainViewController{
    func setUpNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Connect", style: .plain, target: self, action: #selector(leftBarButtonTapped))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New Game", style: .plain, target: self, action: #selector(rightBarButtonTapped))
    
    
    
    
    }
    
    func layoutGameBoard(){
        
        view.addSubview(boardView)
        
        boardView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true

        boardView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
   
        boardView.widthAnchor.constraint(equalToConstant: widthBoard).isActive = true
        boardView.heightAnchor.constraint(equalTo: boardView.widthAnchor, constant: 0).isActive = true
        
        
    }
    
    func layoutPlayButton(){
        view.addSubview(playButton)
        
        playButton.anchor(top: topLayoutGuide.bottomAnchor , left: nil , bottom: nil, right: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        playButton.widthAnchor.constraint(equalToConstant: view.frame.width/3).isActive = true
        
        
        
    }
    
    func layoutPieces() {
  /*
        view.addSubview(stackView[0])
        view.addSubview(stackView[1])
        view.addSubview(stackView[2])*/
        
        
        boardView.addSubview(stackView[0])
        boardView.addSubview(stackView[1])
        boardView.addSubview(stackView[2])

        for i in 0...2 {
            for j in 0...2 {
                stackView[i].addArrangedSubview(pView[j + (i * 3)])
            }  //(0,0),(0,1),(0,2),(1,3),(1,4),(1,5)...(2,8)
        }
        
        stackView[0].anchor(top: boardView.topAnchor, left: boardView.leftAnchor, bottom: nil, right: boardView.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: (widthBoard - 40 - 20) / 3)
    
        stackView[1].anchor(top: nil, left: boardView.leftAnchor, bottom: nil, right: boardView.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: (widthBoard - 40 - 20) / 3)
        
        
        stackView[1].centerYAnchor.constraint(equalTo: boardView.centerYAnchor).isActive = true

        
        stackView[2].anchor(top: nil, left: boardView.leftAnchor, bottom: boardView.bottomAnchor, right: boardView.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 10, paddingRight: 20, width: 0, height: (widthBoard - 40 - 20) / 3)
        
    }
    
}

//MARK: MCBrowserViewControllerDelegate Methods
extension MainViewController: MCBrowserViewControllerDelegate {
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        
        browserViewController.dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController){
      browserViewController.dismiss(animated: true, completion: nil)
    }
    
}

//MARK: handle taps
extension MainViewController{
    
    func leftBarButtonTapped(){//connect
        if appDelegate.multiplayerHandler.mcSession != nil {
            appDelegate.multiplayerHandler.setupBrowser()
            appDelegate.multiplayerHandler.mcBrowserViewController.delegate = self
            self.present(appDelegate.multiplayerHandler.mcBrowserViewController, animated: true, completion: nil)
        }
        
    }
    func rightBarButtonTapped(){
        
    }
    func handlePlayButton(){
        boardView.drawIt()
        
        for i in 0...8 { pView[i].clear()}
    }
    func handleTapOnPieces(_ sender: UIButton){
        print(sender.tag)
    }
    func handleTapped (_ sender: UITapGestureRecognizer){
        //MARK: Add conditions, player, and isActive
        let tappedView = sender.view! as! gamePieceView
        tappedView.setPlayer(player: currentPlayer)
        let messageDict:[String:Any] = ["field":tappedView.tag, "player":currentPlayer]
        
       
        do {
             let messageData = try JSONSerialization.data(withJSONObject: messageDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            
             try appDelegate.multiplayerHandler.mcSession.send(messageData, toPeers: appDelegate.multiplayerHandler.mcSession.connectedPeers, with:.reliable)
        }catch{
            //handle error
        }
        
        //TODO: check Result
    
      
        
       
    
    
    }
  
}





