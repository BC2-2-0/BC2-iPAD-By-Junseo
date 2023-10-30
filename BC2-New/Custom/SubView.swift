//
//  SubView.swift
//  BC2-New
//
//  Created by 신아인 on 10/30/23.
//

import UIKit
import Then
import SnapKit

class SubView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addView()
        setLayout()
    }
    
    let subView: UIView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 30
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.layer.shadowColor = UIColor(named: "ShadowColor")?.cgColor
        $0.layer.shadowOffset = CGSize(width: 0, height: -5)
        $0.layer.shadowRadius = 4
        $0.layer.shadowOpacity = 0.6
    }
    
    let myAccountLabel = UILabel().then{
        $0.text = "내 계좌"
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    func addView(){
        addSubview(subView)
        addSubview(myAccountLabel)
    }
    
    func setLayout() {
        subView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(180)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        myAccountLabel.snp.makeConstraints{
            $0.top.equalTo(subView.snp.top).offset(40)
            $0.leading.equalTo(30)
        }
    }
}
