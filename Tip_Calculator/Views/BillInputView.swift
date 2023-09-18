//
//  BillInputView.swift
//  Tip_Calculator
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit
import Combine
import CombineCocoa

final class BillInputView: UIView {
    let billSubject = PassthroughSubject<Double, Never>()
    var valuePublisher: AnyPublisher<Double, Never> {
        return billSubject.eraseToAnyPublisher()
    }
    private var cancellables = Set<AnyCancellable>()
    
    private let headerView: HeaderView = {
        let view = HeaderView()
        view.configure(
            topText: "Enter",
            bottomText: "your bill")
        return view
    }()
    
    private lazy var textFieldContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.addCornerRadius(radius: 8)
        return view
    }()
    
    private lazy var currencyDenominationLabel: UILabel = {
        let label = LabelFactory.build(
            text: "$",
            font: ThemeFont.bold(size: 24))
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.font = ThemeFont.demibold(size: 28)
        textField.keyboardType = .decimalPad
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.tintColor = ThemeColor.text
        textField.textColor = ThemeColor.text
        // Add tolbar
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 36))
        toolBar.barStyle = .default
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(
            title: "Done",
            style: .plain,
            target: self,
            action: #selector(doneButtonTapped))
        toolBar.items = [
            UIBarButtonItem(
                barButtonSystemItem: .flexibleSpace,
                target: nil,
                action: nil),
            doneButton
        ]
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        return textField
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
        textField.text = nil
        billSubject.send(0)
    }
}

private extension BillInputView {
    @objc func doneButtonTapped() {
        textField.endEditing(true)
    }
    
    func observe() {
        textField.textPublisher.sink { [weak self] text in
            guard let self = self else { return }
            billSubject.send(text?.doubleValue ?? 0)
        }.store(in: &cancellables)
    }
    
    func setLayout() {
        [textField, currencyDenominationLabel].forEach {
            textFieldContainerView.addSubview($0)
        }
        
        [headerView, textFieldContainerView].forEach {
            self.addSubview($0)
        }
        
        headerView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalTo(textFieldContainerView.snp.centerY)
            $0.width.equalTo(68)
            $0.trailing.equalTo(textFieldContainerView.snp.leading).offset(-24)
        }
        
        textFieldContainerView.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
        }
        
        currencyDenominationLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(textFieldContainerView.snp.leading).offset(16)
        }
        
        textField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(currencyDenominationLabel.snp.trailing).offset(16)
            $0.trailing.equalTo(textFieldContainerView.snp.trailing).offset(-16)
        }
    }
}
