//
//  ChargeSuccessViewController.swift
//  BC2-New
//
//  Created by 신아인 on 10/30/23.
//

import UIKit

class ChargeSuccessViewController: BaseVC {
    
    var userName: String = " "

    private let successCheck = BaseVC().success

    private let goMainButton = UIButton().then{
        $0.layer.cornerRadius = 10
        $0.backgroundColor = UIColor(named: "Button1Color")
        $0.setTitle("메인으로", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        $0.addTarget(self, action: #selector(goToMain), for: .touchUpInside)
    }
    
    private let paymentFinishLabel = UILabel().then {
        $0.text = "결제가\n완료되었습니다."
        $0.numberOfLines = 2
        $0.font = UIFont.systemFont(ofSize: 23)
        $0.textAlignment = .center
    }
    
    private let thankyouLabel = UILabel().then {
        $0.text = "저희 BC2를 이용해 주셔서 감사합니다."
        $0.textColor = UIColor(named: "MainTextColor2")
        $0.numberOfLines = 2
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.textAlignment = .center
    }

    override func addView() {
        view.addSubview(successCheck)
        view.addSubview(goMainButton)
        view.addSubview(paymentFinishLabel)
        view.addSubview(thankyouLabel)
    }
    
    override func setLayout() {
        successCheck.snp.makeConstraints {
            $0.width.equalTo(300)
            $0.height.equalTo(300)
            $0.top.equalToSuperview().offset(120)
            $0.centerX.equalToSuperview()
        }
        paymentFinishLabel.snp.makeConstraints {
            $0.top.equalTo(successCheck.snp.bottom).offset(-70)
            $0.centerX.equalToSuperview()
        }
        thankyouLabel.snp.makeConstraints {
            $0.top.equalTo(paymentFinishLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
        goMainButton.snp.makeConstraints {
            $0.width.equalTo(320)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().offset(-70)
            $0.centerX.equalToSuperview()
        }
    }
    
    @objc func goToMain(){
        let nextVC = MainViewController()
        nextVC.userName = self.userName
        self.navigationController?.setViewControllers([nextVC], animated: true)
    }

}
