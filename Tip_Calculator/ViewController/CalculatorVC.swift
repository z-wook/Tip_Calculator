//
//  ViewController.swift
//  Tip_Calculator
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit
import SnapKit
import Combine

class CalculatorVC: UIViewController {

    private let logoView = LogoView()
    private let resultView = ResultView()
    private let billInputView = BillInputView()
    private let tipInputView = TipInputView()
    private let splitInputView = SplitInputView()
    private let viewModel = CalculatorVM()
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 36
        
        [logoView, resultView, billInputView, tipInputView, splitInputView, UIView()].forEach {
            stackView.addArrangedSubview($0)
        }
        return stackView
    }()
    
    private lazy var viewTapPublisher: AnyPublisher<Void, Never> = {
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        view.addGestureRecognizer(tapGesture)
        return tapGesture.tapPublisher.flatMap { _ in
            Just(())
        }.eraseToAnyPublisher()
    }()
    
    private lazy var logoViewTapPublisher: AnyPublisher<Void, Never> = {
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        tapGesture.numberOfTapsRequired = 2
        logoView.addGestureRecognizer(tapGesture)
        return tapGesture.tapPublisher.flatMap { _ in
            Just(())
        }.eraseToAnyPublisher()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        bind()
        observe()
    }
}

private extension CalculatorVC {
    func bind() {
        let input = CalculatorVM.Input(
            billPublisher: billInputView.valuePublisher,
            tipPublisher: tipInputView.valuePublisher,
            splitPublisher: splitInputView.valuePublisher,
            logoViewTapPublisher: logoViewTapPublisher)
        let output = viewModel.transform(input: input)
        
        output.updateViewPublisher.sink { [weak self] result in
            guard let self = self else { return }
            resultView.configure(result: result)
        }.store(in: &cancellables)
        
        output.restCalculatorPublisher.sink { [weak self] _ in
            guard let self = self else { return }
            billInputView.reset()
            tipInputView.reset()
            splitInputView.reset()
            
            UIView.animate(
                withDuration: 0.1,
                delay: 0,
                usingSpringWithDamping: 5.0,
                initialSpringVelocity: 0.5,
                options: .curveEaseInOut) {
                    self.logoView.transform = .init(scaleX: 1.5, y: 1.5)
                } completion: { _ in
                    UIView.animate(withDuration: 0.1) {
                        self.logoView.transform = .identity
                    }
                }
        }.store(in: &cancellables)
    }
    
    func observe() {
        viewTapPublisher.sink { [weak self] _ in
            guard let self = self else { return }
            view.endEditing(true)
        }.store(in: &cancellables)
    }
    
    func setLayout() {
        view.backgroundColor = ThemeColor.bg
        view.addSubview(vStackView)
        
        vStackView.snp.makeConstraints {
            $0.leading.equalTo(view.snp.leadingMargin).offset(16)
            $0.trailing.equalTo(view.snp.trailingMargin).offset(-16)
            $0.bottom.equalTo(view.snp.bottomMargin).offset(-16)
            $0.top.equalTo(view.snp.topMargin).offset(16)
            
            logoView.snp.makeConstraints {
                $0.height.equalTo(48)
            }
            
            resultView.snp.makeConstraints {
                $0.height.equalTo(224)
            }
            
            billInputView.snp.makeConstraints {
                $0.height.equalTo(56)
            }
            
            tipInputView.snp.makeConstraints {
                $0.height.equalTo(56 + 56 + 15)
            }
            
            splitInputView.snp.makeConstraints {
                $0.height.equalTo(56)
            }
        }
    }
}
