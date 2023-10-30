//
//  StartViewController.swift
//  BC2-New
//
//  Created by 신아인 on 10/30/23.
//

import UIKit
import Firebase
import GoogleSignIn
import Firebase
import FirebaseAuth

class StartViewController: BaseVC{
    
    var userName: String = " "
    var userEmail: String = " "
    
    private let googleSignupImage = UIImage(named: "GoogleSignup")
    
    private let mainLabel = UILabel().then{
        $0.text = "BC2 Pay"
        $0.textColor = UIColor(named: "MainTextColor")
        $0.font = .boldSystemFont(ofSize: 50)
    }
    
    private let subLabel = UILabel().then{
        $0.text = "빠르고 편한 결제 시스템"
        $0.textColor = UIColor(named: "SubTextColor")
        $0.font = .systemFont(ofSize: 15)
    }
    
    private let googleSignupButton = GIDSignInButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.shadowColor = UIColor(named: "ShadowColor")?.cgColor
        $0.layer.shadowOffset = CGSize(width: 1, height: 4)
        $0.layer.shadowOpacity = 1
        $0.layer.shadowRadius = 6
        $0.style = .wide
        
        $0.addTarget(self, action: #selector(signinWithGoogle), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 이전에 로그인한 사용자가 있는 경우 자동으로 로그인
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if let error = error {
                // 오류가 발생한 경우
                print("이전 로그인 복원 실패: \(error.localizedDescription)")
                // 원하는 작업을 수행하거나 로그인 화면을 표시할 수 있습니다.
            } else if let user = user {
                // 이전 로그인이 성공한 경우
                print("이전 로그인 복원 성공: \(user)")
                // 원하는 작업을 수행하거나 다음 화면으로 이동할 수 있습니다.
                // Firebase에 로그인한 후에 필요한 작업 수행
                    if let user = Auth.auth().currentUser {
                        let email = user.email
                        let name = user.displayName
                        self.userEmail = email ?? "Unknown"
                        self.userName = name ?? "Unknown"
                    }
                    
                    let mainVC = MainViewController()
                    mainVC.userName = self.userName
                    mainVC.userEmail = self.userEmail
                    
                    DispatchQueue.main.async {
                        // 메인 뷰로 이동
                        self.navigationController?.setViewControllers([mainVC], animated: false)
                    }
            } else {
                // 이전에 로그인한 사용자가 없는 경우
                print("이전 로그인한 사용자 없음")
                // 원하는 작업을 수행하거나 로그인 화면을 표시할 수 있습니다.
            }
        }
    }
    
    override func addView() {
        view.addSubview(mainLabel)
        view.addSubview(subLabel)
        view.addSubview(block)
        view.addSubview(googleSignupButton)
    }
    
    override func setLayout(){
        mainLabel.snp.makeConstraints{
            $0.height.equalTo(60)
            $0.width.equalTo(190)
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(40)
            $0.centerX.equalToSuperview()
        }
        subLabel.snp.makeConstraints{
            $0.height.equalTo(17)
            $0.width.equalTo(150)
            $0.top.equalTo(mainLabel.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
        }
        block.snp.makeConstraints{
            $0.height.equalTo(240)
            $0.width.equalTo(253)
            $0.top.equalTo(subLabel.snp.bottom).offset(120)
            $0.centerX.equalToSuperview()
        }
        googleSignupButton.snp.makeConstraints{
            $0.height.equalTo(56)
            $0.width.equalTo(320)
            $0.bottom.equalToSuperview().offset(-90)
            $0.centerX.equalToSuperview()
        }
    }
    
    @objc func signinWithGoogle() {
        googleSignupButton.translatesAutoresizingMaskIntoConstraints = false
        
        googleSignupButton.addAction(.init(handler: { [weak self] _ in
            guard let self = self else { return }
            
            GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in
                if let error {
                    print(error.localizedDescription)
                    return
                }
                
                guard let user = result?.user,
                    let idToken = user.idToken?.tokenString
                else {
                    return
                }
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
                
                Auth.auth().signIn(with: credential) { authResult, error in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    
                    // Firebase에 로그인한 후에 필요한 작업 수행
                    if let user = Auth.auth().currentUser {
                        let email = user.email
                        let name = user.displayName
                        self.userEmail = email ?? "Unknown"
                        self.userName = name ?? "Unknown"
                    }
                    
                    let nextVC = MainViewController()
                    nextVC.userName = self.userName
                    nextVC.userEmail = self.userEmail
                    self.navigationController?.setViewControllers([nextVC], animated: false)
                }
            }
            
        }), for: .touchUpInside)
        
    }
}
