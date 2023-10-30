//
//  AddPriceButton.swift
//  BC2-New
//
//  Created by 신아인 on 10/30/23.
//

import UIKit
import Then
import SnapKit

final class AddPriceButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        layer.cornerRadius = 8
        backgroundColor = UIColor(named: "PopUpViewButtonBG")
        setTitle("+ 1000", for: .normal)
        setTitleColor(UIColor.black, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 15)
    }
}
