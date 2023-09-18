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
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 36
        
        [logoView, resultView, billInputView, tipInputView, splitInputView, UIView()].forEach {
            stackView.addArrangedSubview($0)
        }
        return stackView
    }()
    
    private let viewModel = CalculatorVM()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        bind()
    }
}

private extension CalculatorVC {
    func bind() {
        let input = CalculatorVM.Input(
            billPublisher: billInputView.valuePublisher,
            tipPublisher: tipInputView.valuePublisher,
            splitPublisher: splitInputView.valuePublisher)
        let output = viewModel.transform(input: input)
        
        output.updateViewPublisher.sink { [weak self] result in
            guard let self = self else { return }
            resultView.configure(result: result)
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
