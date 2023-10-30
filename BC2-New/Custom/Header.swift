//
//  Header.swift
//  BC2-New
//
//  Created by 신아인 on 10/30/23.
//

import UIKit
import Then
import SnapKit

class Header: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addView()
    }
    
    let userNameLabel = UILabel().then{
        $0.text = " 님"
        $0.textColor = UIColor(named: "SubTextColor")
        $0.font = .systemFont(ofSize: 28)
        let font = UIFont.boldSystemFont(ofSize: 28)
    }
    
    let helloLabel = UILabel().then{
        $0.text = "안녕하세요!"
        $0.textColor = UIColor(named: "SubTextColor")
        $0.font = .systemFont(ofSize: 28)
    }
    
    func addView(){
        addSubview(userNameLabel)
        addSubview(helloLabel)
    }
}
