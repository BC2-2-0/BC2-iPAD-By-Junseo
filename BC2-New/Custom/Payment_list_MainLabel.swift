//
//  Payment_list_MainLabel.swift
//  BC2-New
//
//  Created by 신아인 on 10/30/23.
//

import UIKit
import Then
import SnapKit
final class PaymentListMainLabel: UILabel {
    let FirstLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 24.0)
        $0.text = "Block Chain\n거래 내역"
        $0.numberOfLines = 2
        $0.textColor = UIColor(named: "MainTextColor1")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        setLayout()
        attribute()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addView()
        setLayout()
        attribute()
    }
    func attribute(){
        let attributedStr = NSMutableAttributedString(string: FirstLabel.text!)
        attributedStr.addAttribute(.foregroundColor, value: UIColor(named: "MainTextColor2"), range: (FirstLabel.text! as NSString).range(of: "거래 내역"))
        FirstLabel.attributedText = attributedStr
    }
    func addView(){
        addSubview(FirstLabel)
    }
    func setLayout(){
        FirstLabel.snp.makeConstraints{ make in
            make.leading.equalTo(safeAreaInsets).inset(20)
            make.top.equalTo(safeAreaLayoutGuide).inset(44)
        }
    }
}
