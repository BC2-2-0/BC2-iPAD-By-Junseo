//
//  PopUpView.swift
//  BC2-New
//
//  Created by 신아인 on 10/30/23.
//

import UIKit
import Then
import SnapKit

class PopUpView: UIView {
    
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
    
    let popup: UIView = UIView().then {
        $0.backgroundColor = UIColor(named: "Button1Color")
        $0.layer.cornerRadius = 13
    }
    
    let infoLabel = UILabel().then{
        $0.text = "16진수로 변환된 코드에 1, 2, 3, 4, 5, 6, 7, 8, 9가\n  모두 포함되었을 경우 100원을 얻을 수 있습니다"
        $0.numberOfLines = 2
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 13)
    }
    
    func addView(){
        addSubview(popup)
        addSubview(infoLabel)
    }
    
    func setLayout(){
        popup.snp.makeConstraints{
            $0.width.equalTo(290)
            $0.height.equalTo(110)
        }
        infoLabel.snp.makeConstraints{
            $0.centerX.centerY.equalTo(popup)
        }
    }

}
