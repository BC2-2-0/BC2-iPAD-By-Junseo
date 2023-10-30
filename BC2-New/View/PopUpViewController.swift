//
//  PopUpViewController.swift
//  BC2-New
//
//  Created by 신아인 on 10/30/23.
//

import UIKit

class PopUpViewController: BaseVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isOpaque = false
        view.layer.backgroundColor = (UIColor.black.cgColor).copy(alpha: 0.5)
        addView()
        setLayout()
        addTarget()
    }
    
    private let infoButtonPop = PopUpView()
    
    private let closeButton = UIButton().then {
        $0.setImage(UIImage(systemName: "x.circle"), for: .normal)
        $0.tintColor = UIColor(named: "Button2Color")
        $0.addTarget(self, action: #selector(closePopup), for: .touchUpInside)
    }
    
    override func addView() {
        view.addSubview(infoButtonPop)
        view.addSubview(closeButton)
    }
    
    override func setLayout() {
        infoButtonPop.snp.makeConstraints{
            $0.width.equalTo(290)
            $0.height.equalTo(110)
            $0.centerX.centerY.equalToSuperview()
        }
        closeButton.snp.makeConstraints{
            $0.width.height.equalTo(30)
            $0.top.equalTo(infoButtonPop.snp.top).inset(5)
            $0.trailing.equalTo(infoButtonPop.snp.trailing).inset(5)
        }
    }
    
    @objc func closePopup(){
        self.dismiss(animated: true, completion: nil)
    }
}
