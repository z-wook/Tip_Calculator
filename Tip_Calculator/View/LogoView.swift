//
//  LogoView.swift
//  Tip_Calculator
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit

final class LogoView: UIView {
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "icCalculatorBW")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var topLabel: UILabel = {
        let label = UILabel()
        let text = NSMutableAttributedString(
            string: "Mr TIP",
            attributes: [.font: ThemeFont.demibold(size: 16)])
        text.addAttributes([.font: ThemeFont.bold(size: 24)], range: NSMakeRange(3, 3))
        label.attributedText = text
        return label
    }()
    
    private lazy var bottomLabel: UILabel = {
        LabelFactory.build(
            text: "Calculator",
            font: ThemeFont.demibold(size: 20),
            textAlignment: .left)
    }()
    
    private lazy var hStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = 8
        
        [imageView, vStackView].forEach {
            view.addArrangedSubview($0)
        }
        return view
    }()
    
    private lazy var vStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = -4
        
        [topLabel, bottomLabel].forEach {
            view.addArrangedSubview($0)
        }
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        self.addSubview(hStackView)
        
        hStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.height.equalTo(imageView.snp.width)
        }
    }
}
