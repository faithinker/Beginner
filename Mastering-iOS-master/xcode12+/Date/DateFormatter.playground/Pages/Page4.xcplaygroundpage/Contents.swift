
/*:
 # Symbols
 */
import Foundation

let now = Date()
let weekdaySymbols = ["βοΈ", "π", "π₯", "π§", "π²", "π₯", "π"]
let am = "π"
let pm = "π"

let formatter = DateFormatter()
formatter.dateStyle = .full
formatter.timeStyle = .full

formatter.amSymbol = am
formatter.pmSymbol = pm

print(formatter.string(from: now))

formatter.amSymbol = am
formatter.pmSymbol = pm   // Symbol μλ ₯νλ©΄ μ¬λ¬ μ¬λ³Όμ΄ λμ΄
formatter.weekdaySymbols = weekdaySymbols

print(formatter.string(from: now))

// formatterλ₯Ό μ¬μ©νλ©΄ νΉμ  μ»΄ν¬λνΈλ μνλ μ¬λ³Όλ‘ λ°κΏ μ μλ€.
//: [Next](@next)
