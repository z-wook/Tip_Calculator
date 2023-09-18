//
//  SplitInputView.swift
//  Tip_Calculator
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit
import Combine
import CombineCocoa

final class SplitInputView: UIView {
    private let splitSubject = CurrentValueSubject<Int, Never>(1)
    var valuePublisher: AnyPublisher<Int, Never> {
        return splitSubject.removeDuplicates().eraseToAnyPublisher()
    }
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var headerView: HeaderView = {
        let view = HeaderView()
        view.configure(topText: "Split", bottomText: "the total")
        return view
    }()
    
    private lazy var decrementButton: UIButton = {
        let button = buildButton(
            text: "-",
            corners: [.layerMinXMaxYCorner, .layerMinXMinYCorner])
        
        button.tapPublisher.flatMap { [unowned self] _ in
            Just(splitSubject.value == 1 ? 1: splitSubject.value - 1)
        }.assign(to: \.value, on: splitSubject)
            .store(in: &cancellables)
        return button
    }()
    
    private lazy var incrementButton: UIButton = {
        let button = buildButton(
            text: "+",
            corners: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner])
        
        button.tapPublisher.flatMap { [unowned self] _ in
            Just(splitSubject.value + 1)
        }.assign(to: \.value, on: splitSubject)
            .store(in: &cancellables)
        return button
    }()
    
    private func buildButton(text: String, corners: CACornerMask) -> UIButton {
        let button = UIButton()
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = ThemeFont.bold(size: 20)
        button.addRoundCorners(corners: corners, radius: 8)
        button.backgroundColor = ThemeColor.primary
        return button
    }
    
    private lazy var quantityLabel: UILabel = {
        let label = LabelFactory.build(
            text: "1",
            font: ThemeFont.bold(size: 20),
            backgroundColor: .white)
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        
        [decrementButton, quantityLabel, incrementButton].forEach {
            stackView.addArrangedSubview($0)
        }
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        
        setLayout()
        observe()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func observe() {
        splitSubject.sink { [weak self] quantity in
            guard let self = self else { return }
            quantityLabel.text = quantity.stringValue
        }.store(in: &cancellables)
    }
    
    private func setLayout() {
        [headerView, stackView].forEach {
            addSubview($0)
        }
        
        stackView.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
        }
        
        [incrementButton, decrementButton].forEach { button in
            button.snp.makeConstraints {
                $0.width.equalTo(button.snp.height)
            }
        }
        
        headerView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalTo(stackView.snp.centerY)
            $0.trailing.equalTo(stackView.snp.leading).offset(-24)
            $0.width.equalTo(68)
        }
    }
}
