//
//  BaseVC.swift
//  BC2-New
//
//  Created by 신아인 on 10/30/23.
//

import UIKit
import SnapKit
import Then
import Lottie

class BaseVC: UIViewController {

    lazy var success = LottieAnimationView(name: "success").then {
        $0.contentMode = .scaleAspectFill
        $0.loopMode = .loop
        $0.play()
    }
    
    lazy var block = LottieAnimationView(name: "block").then {
        $0.contentMode = .scaleAspectFill
        $0.loopMode = .loop
        $0.play()
    }
    
    lazy var coin = LottieAnimationView(name: "coin").then {
        $0.contentMode = .scaleAspectFill
        $0.loopMode = .loop
        $0.play()
    }
    
    lazy var coinAction = LottieAnimationView(name: "coinAction").then {
        $0.contentMode = .scaleAspectFit
        $0.loopMode = .playOnce
    }
    
    //@available(*, unavailable)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        realmConnection()
        addView()
        setLayout()
        addTarget()
        delegate()
        configNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
    }
    func realmConnection(){}
    func addView(){}
    func setLayout(){}
    func addTarget(){}
    func delegate(){}
    func configNavigation(){}
}
