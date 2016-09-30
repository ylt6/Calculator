import Foundation

class CalculatorBrain {
    
    // MARK: - public API
    func setOperand(operand: Double) {
        if pending != nil {
            secondOperand = operand
            executePending()
        }
        else {
            accumulator = operand
        }
    }
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
                
            case .Constant(let value):
                accumulator = value
                
                
            case .UnarOperation(let function):
                accumulator = function(accumulator)
                
            case .BinaryOperation(let function):
                
                if let _tempAccumulator = tempAccumulator {
                    accumulator = _tempAccumulator
                    tempAccumulator = nil
                    
                    pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator, functionSymbol: symbol)
                }
                else {
                    if pending != nil {
                        pending!.binaryFunction = function
                        pending!.functionSymbol = symbol
                    }
                    else {
                        pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator, functionSymbol: symbol)
                    }
                }
                
            case .Equals:
                if let _tempAccumulator = tempAccumulator {
                    accumulator = _tempAccumulator
                    tempAccumulator = nil
                }
            }
        }
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
    
    func reset() {
        accumulator = 0.0
        tempAccumulator = nil
        pending = nil
        secondOperand = nil
    }
    
    // MARK: - private
    private var accumulator = 0.0
    
    private var pending: PendingBinaryOperationInfo?
    
    private enum Operation {
        case Constant(Double)
        case UnarOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π": Operation.Constant(M_PI),
        "e": Operation.Constant(M_E),
        "√": Operation.UnarOperation(sqrt),
        "×": Operation.BinaryOperation({ $0 * $1 }),
        "÷": Operation.BinaryOperation({ $0 / $1 }),
        "+": Operation.BinaryOperation({ $0 + $1 }),
        "−": Operation.BinaryOperation({ $0 - $1 }),
        "=": Operation.Equals,
    ]
    
    private var secondOperand: Double?
    private var tempAccumulator: Double?
    
    private func executePending() {
        if pending != nil {
            if let _secondOperand = secondOperand {
                tempAccumulator = pending!.binaryFunction(pending!.firstOperand, _secondOperand)
                secondOperand = nil
                pending = nil
            }
        }
    }
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
        var functionSymbol: String
    }
}
