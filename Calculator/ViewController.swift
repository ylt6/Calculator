import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    
    private var brain = CalculatorBrain()
    
    private var userIsInTheMiddleOfTyping = false
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            if isInteger(newValue) {
                display.text = String(Int(newValue))
            }
            else {
                display.text = String(newValue)
            }
        }
    }
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentInDisplay = display.text!
            
            switch digit {
            case "1","2","3","4","5","6","7","8","9":
                if textCurrentInDisplay != "0" {
                    display.text = textCurrentInDisplay + digit
                }
                else {
                    display.text = digit
                }
                
            case ".": if isInteger(displayValue) && !display.text!.hasSuffix(".") {
                        display.text = textCurrentInDisplay + digit
                }
            case "0": if displayValue != 0.0 {
                        display.text = textCurrentInDisplay + digit
                }
            default:
                print("Some other character")
                
            }
        }
        else {
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
    }
    
    @IBAction private func performOperation(_ sender: UIButton) {
        // click some operation after clicking digits
        // this step could be skipped if user click some operation, then click another operation right away
        if userIsInTheMiddleOfTyping {
            brain.setOperand(operand: displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(symbol: mathematicalSymbol)
        }
        
        displayValue = brain.result
    }
    
    @IBAction private func clear() {
        brain.reset()
        displayValue = brain.result
    }
 }
