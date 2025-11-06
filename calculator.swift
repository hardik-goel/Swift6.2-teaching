func calculate(_ a: Double, _ b: Double, op: String) -> Double? {
    switch op {
    case "+": return a + b
    case "-": return a - b
    case "*": return a * b
    case "/": return b != 0 ? a / b : nil
    default: return nil
    }
}

print("Enter first number:")
if let a = Double(readLine() ?? "") {
    print("Enter operator (+, -, *, /):")
    let op = readLine() ?? ""
    print("Enter second number:")
    if let b = Double(readLine() ?? "") {
        if let result = calculate(a, b, op: op) {
            print("Result: \(result)")
        } else {
            print("Invalid operation or divide by zero.")
        }
    }
}

