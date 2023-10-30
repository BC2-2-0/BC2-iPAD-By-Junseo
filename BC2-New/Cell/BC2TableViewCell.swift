//
//  BC2TableViewCell.swift
//  BC2-New
//
//  Created by 신아인 on 10/30/23.
//

import UIKit
import SnapKit
import Then

class BC2TableViewCell: UITableViewCell {
    let customLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 14.0)
        $0.textColor = .gray
    }
    let numberLabel = UILabel().then {
        $0.textColor = .darkGray
        $0.font = UIFont.systemFont(ofSize: 20.0)
    }
    let itemLabel = UILabel().then {
        $0.textColor = UIColor(named: "ItemTextColor")
        let attributedString = NSMutableAttributedString(string: "품목 : 아폴로")
        attributedString.addAttribute(.foregroundColor, value: UIColor.black
                                      , range: NSRange(location: 0, length: 4))
        $0.attributedText = attributedString
        $0.font = UIFont.systemFont(ofSize: 12.0)
    }
    let countLabel = UILabel().then {
        $0.text = "개수 : 1"
        $0.font = UIFont.systemFont(ofSize: 12.0)
    }
    let paymentAmountLabel = UILabel().then {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

        let result = numberFormatter.string(from: NSNumber(value: 10000))
        $0.text = "결제 금액 : \(result!)"
        $0.textAlignment = .left
        $0.textColor = .gray
        $0.font = UIFont.systemFont(ofSize: 12.0)
    }
    let paymentBalanceLabel = UILabel().then {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

        let result = numberFormatter.string(from: NSNumber(value: 1000))
        $0.text = "잔액 : \(result!)"
        $0.textAlignment = .left
        $0.textColor = .gray
        $0.font = UIFont.systemFont(ofSize: 12.0)
    }
    let rechargeLabel = UILabel().then {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

        let result = numberFormatter.string(from: NSNumber(value: 1000))
        $0.text = "충전 금액 : \(result!)"
        $0.textAlignment = .left
        $0.textColor = .gray
        $0.font = UIFont.systemFont(ofSize: 12.0)
    }
    let rechargeBalanceLabel = UILabel().then {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

        let result = numberFormatter.string(from: NSNumber(value: 1000))
        $0.text = "잔액 : \(result!)"
        $0.textAlignment = .left
        $0.textColor = .gray
        $0.font = UIFont.systemFont(ofSize: 12.0)
    }
    let cellView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.5
        $0.layer.shadowRadius = 4
        $0.layer.shadowOffset = CGSize(width: 2, height: 3)
        $0.layer.cornerRadius = 10
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        customLabel.translatesAutoresizingMaskIntoConstraints = false
        addView()
        setLayout()
    }
    init(description: String, reuseIdentifier: String?){
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        numberLabel.text = description
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    func addView(){
        addSubview(cellView)
        addSubview(numberLabel)
        addSubview(customLabel)
        addSubview(itemLabel)
        addSubview(countLabel)
        addSubview(paymentAmountLabel)
        addSubview(paymentBalanceLabel)
        addSubview(rechargeLabel)
        addSubview(rechargeBalanceLabel)
    }
    func setLayout(){
        cellView.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(320)
            $0.height.equalTo(100)
        }
        numberLabel.snp.makeConstraints{
            $0.top.equalTo(cellView.snp.top).inset(11)
            $0.trailing.equalTo(cellView.snp.trailing).inset(17)
        }
        customLabel.snp.makeConstraints{
            $0.top.equalTo(cellView.snp.top).inset(10)
            $0.leading.equalTo(cellView.snp.leading).inset(13)
        }
        itemLabel.snp.makeConstraints{
            $0.top.equalTo(cellView.snp.top).inset(42)
            $0.leading.equalTo(cellView.snp.leading).inset(13)
        }
        countLabel.snp.makeConstraints{
            $0.top.equalTo(cellView.snp.top).inset(70)
            $0.leading.equalTo(cellView.snp.leading).inset(13)
        }
        paymentAmountLabel.snp.makeConstraints{
            $0.top.equalTo(cellView.snp.top).inset(70)
            $0.leading.equalTo(cellView.snp.leading).inset(118)
        }
        paymentBalanceLabel.snp.makeConstraints{
            $0.top.equalTo(cellView.snp.top).inset(70)
            $0.leading.equalTo(cellView.snp.leading).inset(239)
        }
        rechargeLabel.snp.makeConstraints{
            $0.top.equalTo(cellView.snp.top).inset(70)
            $0.leading.equalTo(cellView.snp.leading).inset(26)
        }
        rechargeBalanceLabel.snp.makeConstraints{
            $0.top.equalTo(cellView.snp.top).inset(70)
            $0.leading.equalTo(cellView.snp.leading).inset(226)
        }
    }
}
