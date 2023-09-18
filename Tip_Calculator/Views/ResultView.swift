//
//  ResultView.swift
//  Tip_Calculator
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit

final class ResultView: UIView {
    
    private lazy var headerlabel: UILabel = {
        LabelFactory.build(
            text: "Total p/person",
            font: ThemeFont.demibold(size: 18))
    }()
    
    private lazy var amountPerPersonLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        let text = NSMutableAttributedString(
            string: "$0",
            attributes: [.font: ThemeFont.bold(size: 48)])
        text.addAttributes(
            [.font: ThemeFont.bold(size: 24)],
            range: NSMakeRange(0, 1))
        label.attributedText = text
        return label
    }()
    
    private lazy var horizontalLineView: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeColor.separator
        return view
    }()
    
    private lazy var totalBillView: AmountView = {
        let view = AmountView(
            title: "Total bill",
            textAlignment: .left)
        return view
    }()
    
    private lazy var totalTipView: AmountView = {
        let view = AmountView(
            title: "Total tip",
            textAlignment: .right)
        return view
    }()
    
    private lazy var hStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        [totalBillView, UIView(), totalTipView].forEach {
            stackView.addArrangedSubview($0)
        }
        return stackView
    }()
    
    private func buildSpacerView(height: CGFloat) -> UIView {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
        return view
    }
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        
        [headerlabel, amountPerPersonLabel, horizontalLineView, buildSpacerView(height: 0), hStackView].forEach {
            stackView.addArrangedSubview($0)
        }
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(result: Result) {
        let text = NSMutableAttributedString(
            string: result.amountPerPerson.currencyFormatted,
            attributes: [.font: ThemeFont.bold(size: 48)])
        text.addAttributes([
            .font: ThemeFont.bold(size: 24)
        ], range: NSMakeRange(0, 1))
        amountPerPersonLabel.attributedText = text
        totalBillView.configure(amount: result.totalBill)
        totalTipView.configure(amount: result.totalTip)
    }
    
    private func setLayout() {
        backgroundColor = .systemBackground
        addSubview(vStackView)
        
        vStackView.snp.makeConstraints {
            $0.top.equalTo(snp.top).offset(24)
            $0.leading.equalTo(snp.leading).offset(24)
            $0.trailing.equalTo(snp.trailing).offset(-24)
            $0.bottom.equalTo(snp.bottom).offset(-24)
        }
        
        horizontalLineView.snp.makeConstraints {
            $0.height.equalTo(2)
        }
        
        addShadow(
            offset: CGSize(width: 0, height: 3),
            color: .black,
            radius: 12,
            opacity: 0.1)
    }
}
