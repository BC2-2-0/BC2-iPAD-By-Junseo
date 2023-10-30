//
//  MainViewController.swift
//  BC2-New
//
//  Created by 신아인 on 10/30/23.
//

import UIKit
import EventSource
import Firebase
import RealmSwift
import GoogleSignIn
//import FirebaseAuth

class MoneyData: Object,Decodable {
    @Persisted(primaryKey: true) var id: String
    @Persisted var balance: Int
    convenience init(balance: Int) {
        self.init()
        self.id = UUID().uuidString
        self.balance = balance
    }
}

//var responseBalance: Int = 0
var check: Int = 0
let myData = MyData.shared

class MainViewController: BaseVC {
    
    var userName: String = " "
    var userEmail: String = " "
    var myMoney: Int = 0
    
    var amount: Int {
        get {
            return UserDefaults.standard.integer(forKey: "Amount")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "Amount")
        }
    }
    
    var balances: String = " "
    
    var changeAmount: String = " "
    
    //var amount = 0
    
    var moneyCount: Int = 0
    
    private let headerView = Header()
    
    private let sub = SubView()
    
    private let box = BoxView()
    
    private let boxInLabel = AmountLabel()
    
    private let goPaymentListBtn = UIButton().then{
        $0.setTitle("거래 내역 조회 ", for: .normal)
        $0.setTitleColor(UIColor(named: "MainTextColor"), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        $0.tintColor = UIColor(named: "MainTextColor")
        $0.contentHorizontalAlignment = .leading
        $0.semanticContentAttribute = .forceRightToLeft
        $0.addTarget(self, action: #selector(goToListViewController), for: .touchUpInside)
    }
    
    private let miniBlock = BaseVC().block
    
    private let logoutButton = UIButton().then {
        $0.setImage(UIImage(systemName: "person.crop.circle.fill"), for: .normal)
        $0.tintColor = UIColor(named: "Button2Color")
        $0.addTarget(self, action: #selector(logout), for: .touchUpInside)
    }
    
    private let paymentButton = PaymentButton().then {
        $0.addTarget(self, action: #selector(goToQR), for: .touchUpInside)
    }
    
    private let miningButton = PaymentButton().then{
        $0.setTitle("코인 채굴", for: .normal)
        $0.backgroundColor = UIColor(named: "Button2Color")
        $0.setTitleColor(UIColor(named: "MainTextColor"), for: .normal)
        $0.addTarget(self, action: #selector(showPopup), for: .touchUpInside)
    }
    
    private let popUpView = UIView().then {
        $0.backgroundColor = UIColor.white
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    
    private let backgroundView = UIView().then {
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    private let coinRechargeLabel = UILabel().then {
        $0.text = "코인 충전"
        $0.font = UIFont.boldSystemFont(ofSize: 20.0)
        $0.isHidden = true
    }
    
    private let coinImageView = UIImageView().then {
        $0.image = UIImage(named: "CoinImage")
    }
    
    private let rechargeImageView = UIImageView().then {
        $0.image = UIImage(named: "CoinImage")
    }
    
    private let goMiningButton = UIButton().then {
        $0.backgroundColor = UIColor(named: "PopUpViewButtonBG")
        $0.layer.cornerRadius = 8
        $0.setTitle("\n\n채굴하기", for: .normal)
        $0.titleLabel?.numberOfLines = 3
        $0.setTitleColor(UIColor.black, for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
        $0.addTarget(self, action: #selector(goToMining), for: .touchUpInside)
    }
    
    private let goRechargeButton = UIButton().then {
        $0.backgroundColor = UIColor(named: "PopUpViewButtonBG")
        $0.layer.cornerRadius = 8
        $0.setTitle("\n\n충전하기", for: .normal)
        $0.titleLabel?.numberOfLines = 3
        $0.setTitleColor(UIColor.black, for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
        $0.addTarget(self, action: #selector(goToCharge), for: .touchUpInside)
    }
    
    override func realmConnection() {
        let realm = try! Realm()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        let balance = MoneyData(balance: myData.moneyValue)
        
        try! realm.write {
            realm.add(balance)
        }
        showMoney(myData.moneyValue)
    }
    private var eventSource: EventSource?
    
    override func addView() {
        if (UserDefaults.standard.value(forKey: "money") == nil) {
            UserDefaults.standard.setValue(10000, forKey: "money")
        }
        myData.moneyValue = UserDefaults.standard.integer(forKey: "money")
        changeNameLabel()
        serverSendEvent()
        view.addSubview(headerView)
        view.addSubview(miniBlock)
        view.addSubview(sub)
        view.addSubview(box)
        view.addSubview(boxInLabel)
        view.addSubview(goPaymentListBtn)
        view.addSubview(logoutButton)
        view.addSubview(block)
        view.addSubview(paymentButton)
        view.addSubview(miningButton)
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
        miniBlock.snp.makeConstraints {
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
        goPaymentListBtn.snp.makeConstraints{
            $0.width.equalTo(100)
            $0.height.equalTo(17)
            $0.top.equalTo(boxInLabel.amountLabel.snp.bottom).offset(10)
            $0.leading.equalTo(boxInLabel.amountLabel.snp.leading)
        }
        logoutButton.snp.makeConstraints{
            $0.width.height.equalTo(30)
            $0.top.equalTo(boxInLabel.pointLabel.snp.top)
            $0.trailing.equalTo(box.boxView.snp.trailing).inset(20)
        }
        block.snp.makeConstraints{
            $0.width.equalTo(170)
            $0.height.equalTo(200)
            $0.top.equalTo(goPaymentListBtn.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
        }
        paymentButton.snp.makeConstraints{
            $0.width.equalTo(288)
            $0.height.equalTo(45)
            $0.top.equalTo(block.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        miningButton.snp.makeConstraints{
            $0.width.equalTo(288)
            $0.height.equalTo(45)
            $0.top.equalTo(paymentButton.snp.bottom).offset(10)
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
    
    func hidePopup() {
        self.goMiningButton.isHidden = true
        self.goRechargeButton.isHidden = true
        self.coinImageView.isHidden = true
        self.rechargeImageView.isHidden = true
        UIView.animate(withDuration: 0.1, animations: {
            self.popUpView.alpha = 0
            self.backgroundView.alpha = 0
            self.coinRechargeLabel.alpha = 0
            //self.coinImageView.alpha = 0
            //self.rechargeImageView.alpha = 0
        }) { _ in
            self.popUpView.removeFromSuperview()
            self.backgroundView.removeFromSuperview()
        }
    }
//    override func configNavigation() {
//        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//        backButton.tintColor = .black
//        self.navigationItem.backBarButtonItem = backButton
//        self.view.backgroundColor = .white
//        self.navigationItem.hidesBackButton = true
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myData.moneyValue = UserDefaults.standard.integer(forKey: "money")
        print(UserDefaults.standard.integer(forKey: "money"))
        showMoney(UserDefaults.standard.integer(forKey: "money"))
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let point = touch.location(in: self.view)
            if !popUpView.frame.contains(point) {
                hidePopup()
            }
        }
    }
    
    func popUpViewAddView(){
        self.view.addSubview(backgroundView)
        self.view.addSubview(popUpView)
        self.view.addSubview(coinRechargeLabel)
        self.view.addSubview(goMiningButton)
        self.view.addSubview(goRechargeButton)
        self.view.addSubview(coinImageView)
        self.view.addSubview(rechargeImageView)
    }
    func popUpViewLayout() {
        popUpView.snp.makeConstraints{
            $0.bottom.equalTo(view.safeAreaInsets).inset(0)
            $0.width.equalToSuperview()
            $0.height.equalTo(172)
        }
        coinRechargeLabel.snp.makeConstraints{
            $0.bottom.equalTo(view.safeAreaInsets).inset(124)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        goMiningButton.snp.makeConstraints{
            $0.width.equalTo(153)
            $0.height.equalTo(80)
            $0.bottom.equalTo(view.safeAreaInsets).inset(25)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
        goRechargeButton.snp.makeConstraints{
            $0.width.equalTo(153)
            $0.height.equalTo(80)
            $0.bottom.equalTo(view.safeAreaInsets).inset(25)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
        coinImageView.snp.makeConstraints{
            $0.width.equalTo(24)
            $0.height.equalTo(24)
            $0.leading.equalTo(goMiningButton.snp.leading).inset(65)
            $0.top.equalTo(goMiningButton.snp.top).inset(16)
        }
        rechargeImageView.snp.makeConstraints{
            $0.width.equalTo(24)
            $0.height.equalTo(24)
            $0.leading.equalTo(goRechargeButton.snp.leading).inset(65)
            $0.top.equalTo(goRechargeButton.snp.top).inset(16)
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        Task {
            await eventSource?.close()
        }
    }
    func showMoney(_ balance: Int) {
        let moneyFormatter: NumberFormatter = NumberFormatter()
        moneyFormatter.numberStyle = .decimal
        let result: String = moneyFormatter.string(for: balance)! + " 원"
        boxInLabel.amountLabel.text = result
    }
    
    func performLogout() {
        do {
            try Auth.auth().signOut()
            let startVC = StartViewController()
            // GIDSignIn 인스턴스 초기화
            GIDSignIn.sharedInstance.signOut()
            self.navigationController?.setViewControllers([startVC], animated: false)
        } catch {
            print("로그아웃 실패: \(error.localizedDescription)")
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
    
    func serverSendEvent(){
        print("ASD")
        //        print(charge(email: self.userEmail, balance: self.myMoney, charged_money: 100))
        let moneyFormatter: NumberFormatter = NumberFormatter()
        moneyFormatter.numberStyle = .decimal
        let eventSourceURL = "http://13.125.77.165:3000/receive"
        let eventSource = EventSource(request: .init(url: URL(string: eventSourceURL)!))
        self.eventSource = eventSource
        print(myData.moneyValue)
        eventSource.connect()
        Task {
            for await event in eventSource.events {
                switch event {
                case .open:
                    print("성공")
                    print("Connection was opened. main")
                case .error(let error):
                    print("에러")
                    print("Received an error:", error.localizedDescription)
                case .message(let message):
                    do {
                        let response = try JSONDecoder().decode(ChargeResponse.self, from: message.data!.data(using: .utf8)!)
                        myData.moneyValue = UserDefaults.standard.integer(forKey: "money") + 10
                        print(myData.moneyValue)
                        let result: String = moneyFormatter.string(for: myData.moneyValue)! + " 원"
                        boxInLabel.amountLabel.text = result
                        print(myData.moneyValue)
                        
                        UserDefaults.standard.setValue(myData.moneyValue, forKey: "money")
                    } catch {
                        
                    }
                    print("메시지")
                    print("Received a message", message.data ?? "데이터 없음")
                case .closed:
                    print("Connection was closed.")
                }
            }
        }
    }
}
    
    
    
extension MainViewController {
    
    @objc func goToListViewController(){
        let nextVC = ListViewController()
        self.navigationController?.pushViewController(nextVC, animated: false)
    }
    
    @objc func logout(){
        let alert = UIAlertController(title: "로그아웃", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "확인", style: .destructive) { [weak self] _ in
            // 로그아웃 처리
            self?.performLogout()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func goToQR(){
        let nextVC = ReaderViewController()
        nextVC.userEmail = self.userEmail
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true, completion: nil)
    }
    
    @objc func goToMining(){
        let nextVC = MiningViewController()
        nextVC.myMoney = amount
        nextVC.userName = self.userName
        nextVC.userEmail = self.userEmail
        self.navigationController?.pushViewController(nextVC, animated: false)
        self.coinRechargeLabel.isHidden = true
        self.goMiningButton.isHidden = true
        self.goRechargeButton.isHidden = true
        self.coinImageView.isHidden = true
        self.rechargeImageView.isHidden = true
        self.backgroundView.isHidden = true
        self.popUpView.isHidden = true
        //        Task {
        //            await eventSource?.close()
        //        }
    }
    
    @objc func goToCharge(){
        let nextVC = ChargeViewController(email: userEmail)
        nextVC.userName = self.userName
        self.navigationController?.pushViewController(nextVC, animated: false)
    }
    
    @objc func showPopup() {
        popUpViewAddView()
        popUpViewLayout()
        self.coinRechargeLabel.isHidden = false
        self.goMiningButton.isHidden = false
        self.goRechargeButton.isHidden = false
        self.coinImageView.isHidden = false
        self.rechargeImageView.isHidden = false
        self.backgroundView.isHidden = false
        self.popUpView.isHidden = false
        self.backgroundView.frame = view.bounds
        popUpView.alpha = 0
        backgroundView.alpha = 0
        coinRechargeLabel.alpha = 0
        goMiningButton.alpha = 0
        goRechargeButton.alpha = 0
        coinImageView.alpha = 0
        rechargeImageView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.popUpView.alpha = 1
            self.backgroundView.alpha = 1
            self.coinRechargeLabel.alpha = 1
            self.goMiningButton.alpha = 1
            self.goRechargeButton.alpha = 1
            self.coinImageView.alpha = 1
            self.rechargeImageView.alpha = 1
        }
    }
    
}
