//
//  ViewController.swift
//  iOS-Calculator
//
//  Created by Kaiscer Vasquez on 12/2/23.
//

import UIKit

final class ViewController: UIViewController {
    
    // MARK: Outlets
    
    // Result
    
    @IBOutlet weak var resultLabel: UILabel!
    
   
    
    // Numbers
    @IBOutlet weak var number0: UIButton!
    @IBOutlet weak var number1: UIButton!
    @IBOutlet weak var number2: UIButton!
    @IBOutlet weak var number3: UIButton!
    @IBOutlet weak var number4: UIButton!
    @IBOutlet weak var number5: UIButton!
    @IBOutlet weak var number6: UIButton!
    @IBOutlet weak var number7: UIButton!
    @IBOutlet weak var number8: UIButton!
    @IBOutlet weak var number9: UIButton!
    @IBOutlet weak var numberDecimal: UIButton!
    
    // Operator
    
    @IBOutlet weak var operatorAC: UIButton!
    @IBOutlet weak var operatorPlusMinus: UIButton!
    @IBOutlet weak var operatorPercent: UIButton!
    @IBOutlet weak var operatorDivision: UIButton!
    @IBOutlet weak var operatorMultiplication: UIButton!
    
    @IBOutlet weak var operatorAddition: UIButton!
    @IBOutlet weak var operatorEqual: UIButton!
    
    @IBOutlet weak var operatorSubstraction: UIButton!
    
    
    // MARK: - Variable privadas para controlar el scope
    
    private var total: Double = 0
    private var temp: Double = 0                    // Valor temporal
    private var operating = false                    // Nos indicarĂ¡ si se ha seleccionado un operador
    private var decimal = false                      // Nos indicarĂ¡ si el valor es decimal
    private var operation: operationType = .none      // operacion actual
    
    
    // MARK: - Constantes
    
    // De esta manera accedemos al separador locas del iphone
    private let kDecimalSeparator = Locale.current.decimalSeparator!
    private let kMaxLength = 9
    private let ktotal = "total"
    
    private enum operationType{
        case none, addiction, Substraction, multiplication, division, percent
    }
    
    // Formateo de valores auxiliares usando closure()
    private let auxFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 100
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 100
        return formatter
        
    }()
    // Formateador auxiliar para poder mostrar numero en formato cientifico
    
    private let auxTotalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = ""
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 100
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 100
        return formatter
        
    }()
    // Formateo de valores por pantalla por defecto usando closure()
    
    private let printFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = locale.groupingSeparator
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 9
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 8
        return formatter
    }()
    
    private let printScinetificFormatter: NumberFormatter = {
       let formatte = NumberFormatter()
        formatte.numberStyle = .scientific
        formatte.maximumFractionDigits = 3
        formatte.exponentSymbol = "e"
        return formatte
    }()
    
     
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //UI
        number0.round()
        number1.round()
        number2.round()
        number3.round()
        number4.round()
        number5.round()
        number6.round()
        number7.round()
        number8.round()
        number9.round()
        numberDecimal.round()
        
        operatorAC.round()
        operatorPlusMinus.round()
        operatorPercent.round()
        operatorDivision.round()
        operatorMultiplication.round()
        operatorAddition.round()
        operatorEqual.round()
        operatorSubstraction.round()      
        
        numberDecimal.setTitle(kDecimalSeparator, for: .normal)
        total = UserDefaults.standard.double(forKey: ktotal)
        
        result()
    }
    
    
    
    
    
    
    // MARK: - Button Actions
    
    
    @IBAction func operatorACAction(_ sender: UIButton) {
        clear()
        sender.shine()
    }
    
    @IBAction func operatorPlusMinusAction(_ sender: UIButton) {
        // Este boton cambia el valor del numero
        // Si tenemos -5 al multiplicarlo por -1 para a ser 5
        temp = temp * (-1)
        resultLabel.text = printFormatter.string(from:  NSNumber(value: temp))
        sender.shine()
    }
    @IBAction func operatorPercentAction(_ sender: UIButton) {
        
        // De esta manera nos aseguramos de esjucarta la operacion anterior
        if operation != .percent{
            result()
        }
        // Cambiamos el valor de operating a true ya que estamos operando
        // En operation indicamo la operaciĂ³n
        operating = true
        operation = .percent
        result()
 
        sender.shine()
    }
    @IBAction func operatorDivisionAction(_ sender: UIButton) {
        // Comprobamos que no haya operacion pendiente
        if operation != .none{
            result()
        }
        operating = true
        operation = .division
        sender.selectOperation(true)
        sender.shine()
    }
    @IBAction func operatorMultiplicationAction(_ sender: UIButton) {
        if operation != .none{
            result()
        }
        operating = true
        operation = .multiplication
        sender.selectOperation(true)
        sender.shine()
    }
    
    
    @IBAction func operatorSubstraction(_ sender: UIButton) {
        if operation != .none{
            result()
        }
        operating = true
        operation = .Substraction
        sender.selectOperation(true)
        sender.shine()
    }
    
    
    
    @IBAction func operatorAdditionAction(_ sender: UIButton) {
        
        if operation != .none{
            result()
        }
        
        operating = true
        operation = .addiction
        sender.selectOperation(true)
        sender.shine()
    }
    @IBAction func operatorEqualAction(_ sender: UIButton) {
        if operation != .none{
            result()
        }
        sender.shine()
    }
    

    @IBAction func numberDecimalAction(_ sender: UIButton) {
        let currentTemp = auxTotalFormatter.string(from: NSNumber(value: temp))!
        if !operating && currentTemp.count >= kMaxLength{
            return
        }
        resultLabel.text = resultLabel.text! + kDecimalSeparator
        decimal = true
        selectVisualOperation()
        sender.shine()
    }
    
    
    @IBAction func numberAction(_ sender: UIButton) {
       
        // Si se ha pulsado un nĂºmero lo primero que hacemos es cambiar el titulo de AC a C
        operatorAC.setTitle("C", for: .normal)
        // Controlamos que no introduscan mĂ¡n de 9 nĂºmeros
        var currentTemp = auxTotalFormatter.string(from: NSNumber(value: temp))!
        if !operating && currentTemp.count >= kMaxLength{
            return
        }
        
        currentTemp = auxFormatter.string(from: NSNumber(value: temp))!
        
        // Hemos seleccionado una operaciĂ³n
        if operating{
            total = total == 0 ? temp : total
            resultLabel.text = ""
            currentTemp = ""
            operating = false
        }
        // Hemos seleccionado decimal
        if decimal{
            currentTemp = "\(currentTemp)\(kDecimalSeparator)"
            decimal = false
        }
        
        let number = sender.tag
        temp = Double(currentTemp + String(number))!
        resultLabel.text = printFormatter.string(from: NSNumber(value: temp))
        
        selectVisualOperation()
        sender.shine()
       // print(sender.tag)
    }
    
    // Limpia los valores
    
    private func clear(){
        operation = .none
        operatorAC.setTitle("AC", for: .normal)
        if temp != 0 {
            temp = 0
            resultLabel.text = "0"
        }else {
            total = 0
            
        }
    }
    
    // Obtiene el resultado final
    
    private func result(){
        
        switch operation{
            
        case .none:
            // No hacemos nada
             break
        case .addiction:
            total = total + temp
            break
        case .Substraction:
            total = total - temp
            break
        case .multiplication:
            total = total * temp
            break
        case .division:
            total = total / temp
            break
        case .percent:
            temp = temp / 100
            total = temp
            break
            
        }
        // Formateo
        if let currentTotal = auxTotalFormatter.string(from: NSNumber(value: total)), currentTotal.count > kMaxLength{
            resultLabel.text = printScinetificFormatter.string(from: NSNumber(value: total))
        }else{
            resultLabel.text = printFormatter.string(from: NSNumber(value: total))

        }
        
        operation = .none
        selectVisualOperation()
        UserDefaults.standard.set(total, forKey: ktotal)
       
                           
        print("Total :\(total)")
    }
    
    private func selectVisualOperation(){
        if operating{
            operatorAddition.selectOperation(false)
            operatorSubstraction.selectOperation(false)
            operatorMultiplication.selectOperation(false)
            operatorDivision.selectOperation(false)
        }else{
            switch operation{
                
            case .none, .percent:
                operatorAddition.selectOperation(false)
                operatorSubstraction.selectOperation(false)
                operatorMultiplication.selectOperation(false)
                operatorDivision.selectOperation(false)

                break
            case .addiction:
                operatorAddition.selectOperation(true)
                operatorSubstraction.selectOperation(false)
                operatorMultiplication.selectOperation(false)
                operatorDivision.selectOperation(false)
                break
            case .Substraction:
                operatorAddition.selectOperation(false)
                operatorSubstraction.selectOperation(true)
                operatorMultiplication.selectOperation(false)
                operatorDivision.selectOperation(false)
                break
            case .multiplication:
                operatorAddition.selectOperation(false)
                operatorSubstraction.selectOperation(false)
                operatorMultiplication.selectOperation(true)
                operatorDivision.selectOperation(false)
                break
            case .division:
                operatorAddition.selectOperation(false)
                operatorSubstraction.selectOperation(false)
                operatorMultiplication.selectOperation(false)
                operatorDivision.selectOperation(true)
                break
            }
        }
    }
    
    
}

