//
//  TipInputView.swift
//  Tip_Calculator
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit
import Combine
import CombineCocoa

final class TipInputView: UIView {
    private let tipSubject = CurrentValueSubject<Tip, Never>(.none)
    var valuePublisher: AnyPublisher<Tip, Never> {
        return tipSubject.eraseToAnyPublisher()
    }
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var headerView: HeaderView = {
        let view = HeaderView()
        view.configure(
            topText: "Choose",
            bottomText: "your tip")
        return view
    }()
    
    private lazy var tenPercentTipButton: UIButton = {
        let button = buildTipButton(tip: .tenPercent)
        button.tapPublisher.flatMap {
            Just(Tip.tenPercent)
        }.assign(to: \.value, on: tipSubject)
            .store(in: &cancellables)
        return button
    }()
    
    
    
    private lazy var fifteenPercentTipButton: UIButton = {
        let button = buildTipButton(tip: .fifteenPercent)
        button.tapPublisher.flatMap {
            Just(Tip.fifteenPercent)
        }.assign(to: \.value, on: tipSubject)
            .store(in: &cancellables)
        return button
    }()
    
    private lazy var twentyPercentTipButton: UIButton = {
        let button = buildTipButton(tip: .twentyPercent)
        button.tapPublisher.flatMap {
            Just(Tip.twentyPercent)
        }.assign(to: \.value, on: tipSubject)
            .store(in: &cancellables)
        return button
    }()
    
    private lazy var customTipButton: UIButton = {
        let button = UIButton()
        button.setTitle("Custom tip", for: .normal)
        button.titleLabel?.font = ThemeFont.bold(size: 20)
        button.backgroundColor = ThemeColor.primary
        button.tintColor = .white
        button.addCornerRadius(radius: 8)
        button.tapPublisher.sink { [weak self] _ in
            guard let self = self else { return }
            handleCustomTipButtton()
        }.store(in: &cancellables)
        return button
    }()
    
    private lazy var buttonHSackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        
        [tenPercentTipButton, fifteenPercentTipButton, twentyPercentTipButton].forEach {
            stackView.addArrangedSubview($0)
        }
        return stackView
    }()
    
    private lazy var buttonVSackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        
        [buttonHSackView, customTipButton].forEach {
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
    
    func reset() {
        tipSubject.send(.none)
    }
    
    private func buildTipButton(tip: Tip) -> UIButton {
        let button = UIButton(type: .custom)
        button.backgroundColor = ThemeColor.primary
        button.addCornerRadius(radius: 8)
        let text = NSMutableAttributedString(
            string: tip.stringValue,
            attributes: [
                .font: ThemeFont.bold(size: 20),
                .foregroundColor: UIColor.white
            ])
        text.addAttributes([
            .font: ThemeFont.demibold(size: 14)
        ], range: NSMakeRange(2, 1))
        button.setAttributedTitle(text, for: .normal)
        return button
    }
    
    private lazy var alert: UIAlertController = {
        let controller = UIAlertController(
            title: "Enter Custom tip",
            message: nil,
            preferredStyle: .alert)
        controller.addTextField { textField in
            textField.placeholder = "Make it generous!"
            textField.keyboardType = .numberPad
            textField.autocorrectionType = .no
        }
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel)
        let okAction = UIAlertAction(
            title: "Ok",
            style: .default) { [weak self] _ in
                guard let self = self else { return }
                guard let text = controller.textFields?.first?.text,
                      let value = Int(text) else { return }
                tipSubject.send(.custom(value: value))
            }
        [okAction, cancelAction].forEach {
            controller.addAction($0)
        }
        return controller
    }()
}

private extension TipInputView {
    func setLayout() {
        [headerView, buttonVSackView].forEach {
            addSubview($0)
        }
        
        headerView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(buttonVSackView.snp.leading).offset(-24)
            $0.width.equalTo(68)
            $0.centerY.equalTo(buttonHSackView.snp.centerY)
        }
        
        buttonVSackView.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
        }
    }
    
    func handleCustomTipButtton() {
        parentViewController?.present(alert, animated: true)
    }
    
    func observe() {
        tipSubject.sink { [weak self] tip in
            guard let self = self else { return }
            resetView()
            switch tip {
            case .none: break
            case .tenPercent:
                tenPercentTipButton.backgroundColor = ThemeColor.secondary
            case .fifteenPercent:
                fifteenPercentTipButton.backgroundColor = ThemeColor.secondary
            case .twentyPercent:
                twentyPercentTipButton.backgroundColor = ThemeColor.secondary
            case .custom(let value):
                customTipButton.backgroundColor = ThemeColor.secondary
                let text = NSMutableAttributedString(
                    string: "$\(value)",
                    attributes: [
                        .font: ThemeFont.bold(size: 20)
                    ])
                text.addAttributes([
                    .font: ThemeFont.bold(size: 14)
                ], range: NSMakeRange(0, 1))
                customTipButton.setAttributedTitle(text, for: .normal)
            }
        }.store(in: &cancellables)
    }
    
    func resetView() {
        [tenPercentTipButton, fifteenPercentTipButton, twentyPercentTipButton, customTipButton].forEach {
            $0.backgroundColor = ThemeColor.primary
        }
        let text = NSMutableAttributedString(
            string: "Custom tip",
            attributes: [.font: ThemeFont.bold(size: 20)])
        customTipButton.setAttributedTitle(text, for: .normal)
    }
}
