//
//  PaymentButton.swift
//  BC2-New
//
//  Created by 신아인 on 10/30/23.
//

import UIKit
import Then
import SnapKit

final class PaymentButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        layer.cornerRadius = 12
        backgroundColor = UIColor(named: "Button1Color")
        setTitle("QR 결제", for: .normal)
        setTitleColor(UIColor.white, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 16)
    }
}
