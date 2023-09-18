//
//  CalculatorVM.swift
//  Tip_Calculator
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import Foundation
import Combine

final class CalculatorVM {
    struct Input {
        let billPublisher: AnyPublisher<Double, Never>
        let tipPublisher: AnyPublisher<Tip, Never>
        let splitPublisher: AnyPublisher<Int, Never>
    }
    
    struct Output {
        let updateViewPublisher: AnyPublisher<Result, Never>
    }
    
    func transform(input: Input) -> Output {
        let updateViewPublisher = Publishers.CombineLatest3(
            input.billPublisher,
            input.tipPublisher,
            input.splitPublisher).flatMap { [unowned self] (bill, tip, split) in
                let totalTip = getTipAmount(bill: bill, tip: tip)
                let totalbill = bill + totalTip
                let amountPerPerson = totalbill / Double(split)
                let result = Result(
                    amountPerPerson: amountPerPerson,
                    totalBill: totalbill,
                    totalTip: totalTip)
                return Just(result)
            }.eraseToAnyPublisher()
        return Output(updateViewPublisher: updateViewPublisher)
    }
    
    private func getTipAmount(bill: Double, tip: Tip) -> Double {
        switch tip {
        case .none:
            return 0
        case .tenPercent:
            return bill * 0.1
        case .fifteenPercent:
            return bill * 0.15
        case .twentyPercent:
            return bill * 0.2
        case .custom(let value):
            return Double(value)
        }
    }
}
