import Foundation
import UIKit

enum ValidateError: Error {
    case invalidData(String)
}

protocol ValidatorDelegate {
    func isValidEmailAddress(email: String) -> Bool
    func isValidPhoneNumber(phone: String?) -> Bool
    func isValidPassword(password: String) -> Bool
    
    func validateString(_ value: String) -> Bool
    func validateInt(_ value: Int) -> Bool
    func validateDouble(_ value: Double) -> Bool
}

extension ValidatorDelegate {
    
    func isValidEmailAddress(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        if emailTest.evaluate(with: email) {
            return true
        }
        return false
    }
    //===========================================================
    // This function is used to check the phone number validity
    //===========================================================
    func isValidPhoneNumber(phone: String?) -> Bool {
        let charcterSet  = NSCharacterSet(charactersIn: "+0123456789").inverted
        let inputString = phone?.components(separatedBy: charcterSet)
        let filtered = inputString?.joined(separator: "")
        return (phone == filtered) && ((filtered!.count) == 10)
    }
    //==============================================================
    // This function is used to check the strong password validity
    //==============================================================
    func isValidPassword(password: String) -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$_!%*?&#])[A-Za-z\\dd$@$_!%*?&#]{6,}"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        if passwordTest.evaluate(with: password) {
            return true
        }
        return false
    }
}

extension ValidatorDelegate {
    
    func validateString(_ value: String) -> Bool {
        guard (value != "") else {
            return false
        }
        return true
    }
    
    func validateInt(_ value: Int) -> Bool {
        guard (value > 0) else {
            return false
        }
        return true
    }
    
    func validateDouble(_ value: Double) -> Bool {
        guard (value > 0.0) else {
            return false
        }
        return true
    }
}
