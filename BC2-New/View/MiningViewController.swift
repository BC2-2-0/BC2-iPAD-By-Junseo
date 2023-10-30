//
//  MiningViewController.swift
//  BC2-New
//
//  Created by 신아인 on 10/30/23.
//

import UIKit
import EventSource

class MiningViewController: BaseVC {
    var isRandomCodeRunning = true
    
    var userName: String = " "
    var userEmail: String = " "
    
    var myMoney: Int = 0
    
    var codeArray: Array<Int> = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    var arrString = ""
    
    private var eventSource = EventSource(request: .init(url: URL(string: "http://13.125.77.165:3000/receive")!))
    
    private let headerView = Header()
    
    private let sub = SubView().then {
        $0.myAccountLabel.text = "채굴장"
    }
    
    private let box = BoxView()
    
    private let boxInLabel = AmountLabel()
    
    private let infoButton = UIButton().then {
        $0.setImage(UIImage(systemName: "info.circle.fill"), for: .normal)
        $0.tintColor = UIColor(named: "Button2Color")
        $0.addTarget(self, action: #selector(goInfo), for: .touchUpInside)
    }
    
    var miningCodeButton = PaymentButton().then {
        $0.backgroundColor = .white
        $0.setTitleColor(UIColor.black, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        $0.layer.shadowColor = UIColor(named: "ShadowColor")?.cgColor
        $0.layer.shadowOffset = CGSize(width: 2, height: 1)
        $0.layer.shadowRadius = 5
        $0.layer.shadowOpacity = 1
    }
    
    private let mainButton = PaymentButton().then{
        $0.setTitle("메인으로", for: .normal)
        $0.backgroundColor = UIColor(named: "Button2Color")
        $0.setTitleColor(UIColor(named: "MainTextColor"), for: .normal)
        $0.addTarget(self, action: #selector(goToMain), for: .touchUpInside)
    }
    
    override func addView() {
        changeNameLabel()
        changeAmountLabel()
        randomCode()
        view.addSubview(headerView)
        view.addSubview(block)
        view.addSubview(sub)
        view.addSubview(box)
        view.addSubview(boxInLabel)
        view.addSubview(infoButton)
        view.addSubview(coin)
        view.addSubview(coinAction)
        view.addSubview(miningCodeButton)
        view.addSubview(mainButton)
    }
    
    override func setLayout() {
        headerView.userNameLabel.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.equalTo(35)
        }
        headerView.helloLabel.snp.makeConstraints{
            $0.width.equalTo(130)
            $0.height.equalTo(30)
            $0.top.equalTo(headerView.userNameLabel.snp.bottom).offset(10)
            $0.leading.equalTo(35)
        }
        block.snp.makeConstraints{
            $0.width.equalTo(115)
            $0.height.equalTo(105)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(5)
            $0.leading.equalTo(230)
        }
        sub.snp.makeConstraints{
            $0.top.equalTo(headerView.snp.bottom).offset(60)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        box.snp.makeConstraints{
            $0.width.equalTo(350)
            $0.height.equalTo(700)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(sub.snp.top).offset(70)
        }
        boxInLabel.snp.makeConstraints {
            $0.top.equalTo(box.snp.top).offset(15)
            $0.leading.equalTo(box.snp.leading).offset(10)
        }
        infoButton.snp.makeConstraints{
            $0.width.height.equalTo(30)
            $0.top.equalTo(boxInLabel.pointLabel.snp.top)
            $0.trailing.equalTo(box.boxView.snp.trailing).inset(20)
        }
        coin.snp.makeConstraints{
            $0.width.height.equalTo(200)
            $0.top.equalTo(boxInLabel.amountLabel.snp.bottom).offset(35)
            $0.centerX.equalToSuperview()
        }
        coinAction.snp.makeConstraints{
            $0.width.equalTo(250)
            $0.top.equalTo(coin.snp.top).offset(-70)
            $0.bottom.equalTo(coin.snp.bottom).offset(150)
            $0.centerX.equalToSuperview()
        }
        miningCodeButton.snp.makeConstraints{
            $0.width.equalTo(288)
            $0.height.equalTo(45)
            $0.top.equalTo(coin.snp.bottom).offset(37)
            $0.centerX.equalToSuperview()
        }
        mainButton.snp.makeConstraints{
            $0.width.equalTo(288)
            $0.height.equalTo(45)
            $0.top.equalTo(miningCodeButton.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
    }
    override func configNavigation() {
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backButton.tintColor = .black
        self.navigationItem.backBarButtonItem = backButton
        self.view.backgroundColor = .white
        self.navigationItem.hidesBackButton = true
    }
    
    func randomCode(){
        serverSendEvent()
        print(myData.moneyValue)
        myMoney = UserDefaults.standard.integer(forKey: "money")
        print(myMoney)
        showMoney()
        DispatchQueue.global().async { [self] in
            let temp = 15
            var ranNum: Int
            while isRandomCodeRunning{
                
                arrString = ""
                for _ in 0...temp {
                    ranNum = Int.random(in: 0...24)
                    codeArray[temp] = ranNum
                    arrString += String(ranNum,radix:16)
                }
                print("\(arrString)")
                
                DispatchQueue.main.async {
                    miningCodeButton.setTitle(arrString, for: .normal)
                }
                
                if(arrString.contains("1") && arrString.contains("2") && arrString.contains("3") && arrString.contains("4") && arrString.contains("5")) {
                    DispatchQueue.main.async {
                        coinAction.play()
                        addMoney()
                        print("asdf", myMoney)
                        UserDefaults.standard.setValue(myMoney, forKey: "money")
                    }
                }
                Thread.sleep(forTimeInterval: 1)
            }
        }
        print(myMoney)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        Task {
            await eventSource.close()
        }
    }
    func changeNameLabel() {
        let result: String = userName
        headerView.userNameLabel.text = result + "님"
        let font = UIFont.boldSystemFont(ofSize: 28)
        let attributedText = NSMutableAttributedString(string: headerView.userNameLabel.text!)
        
        if let range = headerView.userNameLabel.text?.range(of: result) {
            let nsRange = NSRange(range, in: headerView.userNameLabel.text!)
            attributedText.addAttribute(.foregroundColor, value: UIColor.black, range: nsRange)
            attributedText.addAttribute(.font, value: font, range: nsRange)
        }
        
        headerView.userNameLabel.attributedText = attributedText
    }
    
    func changeAmountLabel() {
        let moneyFormatter: NumberFormatter = NumberFormatter()
        moneyFormatter.numberStyle = .decimal
        let result: String = moneyFormatter.string(for: myMoney)! + " 원"
        boxInLabel.amountLabel.text = result
    }
    func showMoney() {
        let moneyFormatter: NumberFormatter = NumberFormatter()
        moneyFormatter.numberStyle = .decimal
        let result: String = moneyFormatter.string(for: myMoney)! + " 원"
        boxInLabel.amountLabel.text = result
    }
    func addMoney() {
        myMoney += 100
        let moneyFormatter: NumberFormatter = NumberFormatter()
        moneyFormatter.numberStyle = .decimal
        let result: String = moneyFormatter.string(for: myMoney)! + " 원"
        boxInLabel.amountLabel.text = result
    }
    
    func serverSendEvent(){
        let eventSourceURL = "http://13.125.77.165:3000/receive"
        eventSource.connect()
        
        Task {
            for await event in eventSource.events {
                switch event {
                case .open:
                    print("성공")
                    print("Connection was opened.")
                case .error(let error):
                    print("에러")
                    print("Received an error:", error.localizedDescription)
                case .message(let message):
                    print("메시지")
                    print("Received a message", message.data ?? "데이터 없음")
                    
                    do {
                        let response = try JSONDecoder().decode(ChargeResponse
                            .self, from: message.data!.data(using: .utf8)!)
                        myMoney = UserDefaults.standard.integer(forKey: "money") + 10
                        
                        showMoney()
                        UserDefaults.standard.setValue(myMoney, forKey: "money")
                        
                    } catch {
                        
                    }
                case .closed:
                    print("Connection was closed.")
                }
            }
        }
        
    }
    
    @objc func goToMain(){
        let nextVC = MainViewController()
        nextVC.amount = myMoney
        nextVC.userName = self.userName
        nextVC.userEmail = self.userEmail
        
        isRandomCodeRunning = false
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func goInfo(){
        let nextVC = PopUpViewController()
        nextVC.modalPresentationStyle = .overCurrentContext
        self.present(nextVC, animated: true, completion: nil)
    }
}
