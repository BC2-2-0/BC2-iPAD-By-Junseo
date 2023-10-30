//
//  AmountLabel.swift
//  BC2-New
//
//  Created by 신아인 on 10/30/23.
//

import UIKit
import Then
import SnapKit

class AmountLabel: UIView {
    
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
    
    let pointLabel = UILabel().then{
        $0.text = "BC2 Point"
        $0.textColor = UIColor(named: "SubTextColor")
        $0.font = .boldSystemFont(ofSize: 16)
    }
    
    var amountLabel = UILabel().then{
        $0.text = " "
        $0.textColor = UIColor.black
        $0.font = .boldSystemFont(ofSize: 28)
    }
    
    func addView(){
        addSubview(pointLabel)
        addSubview(amountLabel)
    }
    
    func setLayout() {
        pointLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(200)
            $0.leading.equalToSuperview().offset(30)
        }
        amountLabel.snp.makeConstraints{
            $0.top.equalTo(pointLabel.snp.bottom).offset(9)
            $0.leading.equalToSuperview().offset(30)
        }
    }
}
