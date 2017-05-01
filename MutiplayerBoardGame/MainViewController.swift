//
//  ViewController.swift
//  MutiplayerBoardGame
//
//  Created by eric yu on 4/28/17.
//  Copyright © 2017 eric yu. All rights reserved.
//

import UIKit


class MainViewController: UIViewController {
    //MARK: variables
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
 
            v.append(bt)
        }
        
        return v
    }()
    func handleTapped (_ sender: UITapGestureRecognizer){
        print(sender.view!.tag)
    }
 
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
        /*
        stackView[0].addArrangedSubview(pButton[0])
        stackView[0].addArrangedSubview(pButton[1])
        stackView[0].addArrangedSubview(pButton[2])
        
        stackView[1].addArrangedSubview(pButton[3])
        stackView[1].addArrangedSubview(pButton[4])
        stackView[1].addArrangedSubview(pButton[5])
        
        stackView[2].addArrangedSubview(pButton[6])
        stackView[2].addArrangedSubview(pButton[7])
        stackView[2].addArrangedSubview(pButton[8])*/
        
        
        stackView[0].addArrangedSubview(pView[0])
        stackView[0].addArrangedSubview(pView[1])
        stackView[0].addArrangedSubview(pView[2])
        
        stackView[1].addArrangedSubview(pView[3])
        stackView[1].addArrangedSubview(pView[4])
        stackView[1].addArrangedSubview(pView[5])
        
        stackView[2].addArrangedSubview(pView[6])
        stackView[2].addArrangedSubview(pView[7])
        stackView[2].addArrangedSubview(pView[8])
      
        stackView[0].anchor(top: boardView.topAnchor, left: boardView.leftAnchor, bottom: nil, right: boardView.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: (widthBoard - 40 - 20) / 3)
    
        stackView[1].anchor(top: nil, left: boardView.leftAnchor, bottom: nil, right: boardView.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: (widthBoard - 40 - 20) / 3)
        
        
        stackView[1].centerYAnchor.constraint(equalTo: boardView.centerYAnchor).isActive = true

        
        stackView[2].anchor(top: nil, left: boardView.leftAnchor, bottom: boardView.bottomAnchor, right: boardView.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 10, paddingRight: 20, width: 0, height: (widthBoard - 40 - 20) / 3)
        
    }
    
}
//MARK: handle taps
extension MainViewController {
    func leftBarButtonTapped(){
        
    }
    func rightBarButtonTapped(){
        
    }
    func handlePlayButton(){
        boardView.drawIt()
        pView[0].drawItO()
        
    }
    func handleTapOnPieces(_ sender: UIButton){
        print(sender.tag)
    }

    
    
}



