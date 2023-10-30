//
//  ChargeViewController.swift
//  BC2-New
//
//  Created by 신아인 on 10/30/23.
//

import UIKit
import Bootpay_SPM
import CryptoKit
import RealmSwift

class ChargeViewController: BaseVC, UITextFieldDelegate {
    var amount = 0
    var userName: String = " "
    private let email: String
    
    private let chargeMoneyLabel = UILabel().then {
        $0.text = "충전할 금액을 입력해 주세요"
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    private let chargeMoneyTextField = UITextField().then {
        $0.layer.cornerRadius = 10
        $0.placeholder = "금액을 입력하세요"
        $0.textColor = UIColor(named: "MainTextColor2")
        $0.backgroundColor = UIColor(named: "PopUpViewButtonBG")
        $0.leftViewMode = .always
        $0.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        $0.font = .systemFont(ofSize: 18)
        $0.keyboardType = .numberPad
    }
    
    private let addThousandButton = AddPriceButton().then {
        $0.addTarget(self, action: #selector(addThousand), for: .touchUpInside)
    }
    
    
    private let addFiveThousandButton = AddPriceButton().then{
        $0.setTitle("+ 5000", for: .normal)
        $0.addTarget(self, action: #selector(addFiveThousand), for: .touchUpInside)
    }
    
    private let addMillionButton = AddPriceButton().then{
        $0.setTitle("+ 10000", for: .normal)
        $0.addTarget(self, action: #selector(addMillion), for: .touchUpInside)
    }
    
    private let chargeButton = UIButton().then{
        $0.layer.cornerRadius = 10
        $0.backgroundColor = UIColor(named: "Button1Color")
        $0.setTitle("충전하기", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        $0.addTarget(self, action: #selector(requestPayment), for: .touchUpInside)
    }
    
    init(email: String) {
        self.email = email
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addView() {
        view.addSubview(chargeMoneyLabel)
        view.addSubview(chargeMoneyTextField)
        view.addSubview(addThousandButton)
        view.addSubview(addFiveThousandButton)
        view.addSubview(addMillionButton)
        view.addSubview(chargeButton)
    }
    
    override func setLayout() {
        chargeMoneyLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(110)
            $0.leading.equalToSuperview().offset(35)
        }
        chargeMoneyTextField.snp.makeConstraints {
            $0.width.equalTo(320)
            $0.height.equalTo(50)
            $0.top.equalTo(chargeMoneyLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        addThousandButton.snp.makeConstraints {
            $0.width.equalTo(73)
            $0.height.equalTo(38)
            $0.top.equalTo(chargeMoneyTextField.snp.bottom).offset(13)
            $0.leading.equalToSuperview().offset(35)
        }
        addFiveThousandButton.snp.makeConstraints {
            $0.width.equalTo(75)
            $0.height.equalTo(38)
            $0.top.equalTo(chargeMoneyTextField.snp.bottom).offset(13)
            $0.leading.equalTo(addThousandButton.snp.trailing).offset(10)
        }
        addMillionButton.snp.makeConstraints {
            $0.width.equalTo(83)
            $0.height.equalTo(38)
            $0.top.equalTo(chargeMoneyTextField.snp.bottom).offset(13)
            $0.leading.equalTo(addFiveThousandButton.snp.trailing).offset(10)
        }
        chargeButton.snp.makeConstraints {
            $0.width.equalTo(320)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().offset(-70)
            $0.centerX.equalToSuperview()
        }
    }
    
    override func configNavigation() {
        self.navigationItem.hidesBackButton = false
    }
    
    //화면 터치시 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // 입력 시작시 키보드 올림  ==> textField delegate
    func textFieldDidBeginEditing(_ chargeMoneyTextField: UITextField) {
        chargeMoneyTextField.becomeFirstResponder()
    }
    
    var _applicationId = "64237fd23049c8001c178ad4"
    func generatePayload() -> Payload {
        let payload = Payload()
        payload.applicationId = _applicationId
        
        payload.price = Double(amount)
        payload.orderId = String(NSTimeIntervalSince1970)
        payload.pg = "토스"
        payload.method = "계좌이체"
        payload.orderName = "테스트아이템"
        payload.extra = BootExtra()
        
        payload.extra?.cardQuota = "3"
        
        let customParams: [String: String] = [
            "callbackParam1": "value12",
            "callbackParam2": "value34",
            "callbackParam3": "value56",
            "callbackParam4": "value78",
        ]
        
        payload.metadata = customParams
        
        
        let user = BootUser()
        user.username = "테스트"
        user.phone = "01012345678"
        payload.user = user
        return payload
    }
    
    @objc func requestPayment() {
        guard let chargeAmountText = chargeMoneyTextField.text, !chargeAmountText.isEmpty else {
            showAlert(message: "충전할 금액을 입력해 주세요")
            return
        }
        
        let payload = generatePayload()
        Bootpay.requestPayment(viewController: self, payload: payload)
            .onCancel { data in
                print("-- cancel: (data)")
            }
            .onIssued { data in
                print("-- issued: (data)")
            }
            .onConfirm { data in
                print("-- confirm: (data)")
                return true //재고가 있어서 결제를 최종 승인하려 할 경우
                //                Bootpay.transactionConfirm()
                //                return false //재고가 없어서 결제를 승인하지 않을때
            }
            .onDone { [weak self] data in
                guard let self else {
                    return
                }
                let currentMoney = UserDefaults.standard.integer(forKey: "money")
                let balance = currentMoney + amount
                UserDefaults.standard.setValue(balance, forKey: "money")
                let charge = ChargeRealmEntity(balance: "\(balance)", charged_money: "\(amount)", emailHash: SHA256.hash(data: self.email.data(using: .utf8)!).compactMap { String(format: "%02x", $0)}.joined())
                let realm = try! Realm()
                
                try! realm.write {
                    realm.add(charge)
                }
                
                let nextVC = ChargeSuccessViewController()
                nextVC.userName = self.userName
                self.navigationController?.setViewControllers([nextVC], animated: false)
                
                print("-- done: (data)")
            }
            .onError { data in
                print("-- error: (data)")
            }
            .onClose {
                print("-- close")
            }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "충전 실패", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func addThousand() {
        if let text = chargeMoneyTextField.text, let currentAmount = Int(text) {
            amount = currentAmount
        }
        amount += 1000
        chargeMoneyTextField.text = "\(amount)"
    }
    
    @objc func addFiveThousand() {
        if let text = chargeMoneyTextField.text, let currentAmount = Int(text) {
            amount = currentAmount
        }
        amount += 5000
        chargeMoneyTextField.text = "\(amount)"
    }
    @objc func addMillion() {
        if let text = chargeMoneyTextField.text, let currentAmount = Int(text) {
            amount = currentAmount
        }
        amount += 10000
        chargeMoneyTextField.text = "\(amount)"
    }
}
