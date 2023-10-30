//
//  ReaderViewController.swift
//  BC2-New
//
//  Created by 신아인 on 10/30/23.
//

import UIKit
import SnapKit

class ReaderViewController: BaseVC, ReaderViewDelegate {

    var userEmail: String = " "
    var userName: String = " "
    var myMoney = 0

    private let QRLabel = UILabel().then {
        $0.text = "화면에 있는 QR을 인식해 주세요 !"
        $0.textColor = UIColor.white
        $0.font = .systemFont(ofSize: 15)
    }

    private let cancleButton = UIButton().then {
        $0.layer.cornerRadius = 20
        $0.layer.borderWidth = 1
        $0.setTitle("취소", for: .normal)
        $0.layer.borderColor = UIColor.white.cgColor
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
        $0.addTarget(self, action: #selector(goToMain), for: .touchUpInside)
    }

    override func addView(){
        let readerView = ReaderView(frame: view.bounds)
        readerView.delegate = self
        view.addSubview(readerView)
        view.addSubview(QRLabel)
        view.addSubview(cancleButton)
    }

    override func setLayout() {
        QRLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(290)
            $0.centerX.equalToSuperview()
        }
        cancleButton.snp.makeConstraints {
            $0.width.equalTo(60)
            $0.height.equalTo(40)
            $0.top.equalTo(QRLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
    }

    func readerComplete(status: ReaderStatus) {
        
    }
    func readerViewDidCancel() {
        DispatchQueue.main.async {
            self.dismiss(animated: false)
        }
    }
    func presentAlertController(_ alertController: UIAlertController) {
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }

    @objc func goToMain(){
        DispatchQueue.main.async {
            self.dismiss(animated: false)
        }
    }
}
