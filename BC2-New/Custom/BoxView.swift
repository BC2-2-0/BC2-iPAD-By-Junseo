//
//  BoxView.swift
//  BC2-New
//
//  Created by 신아인 on 10/30/23.
//

import UIKit
import Then
import SnapKit

class BoxView: UIView {
    
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
    
    let boxView: UIView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 13
        $0.layer.shadowColor = UIColor(named: "ShadowColor")?.cgColor
        $0.layer.shadowOffset = CGSize(width: 0, height: 2)
        $0.layer.shadowRadius = 4
        $0.layer.shadowOpacity = 1
    }
    
    func addView(){
        addSubview(boxView)
    }
    
    func setLayout(){
        boxView.snp.makeConstraints{
            $0.width.equalTo(320)
            $0.height.equalTo(700)
            $0.top.equalToSuperview().offset(190)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-30)
        }
    }
}
