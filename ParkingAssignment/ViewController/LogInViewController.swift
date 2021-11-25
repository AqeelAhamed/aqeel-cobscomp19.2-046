//
//  LogInViewController.swift
//  ParkingAssignment
//
//  Created by Aqeel Ahmed on 3/2/21.
//

import UIKit
import FirebaseAuth
import Firebase

class LogInViewController:UIViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
 
    //MARK: This function is used to check the email address validity
    func isValidEmailAddress(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        if emailTest.evaluate(with: email) {
            return true
        }
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func didTappedOnLogin(_ sender: Any) {
        do {
            if try validateForm() {
                loginRequest()
            }
        } catch ValidateError.invalidData(let message) {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
        } catch {
            let alert = UIAlertController(title: "Error", message: "Missing Data", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func didTappedOnForgotPassword(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Auth", bundle: Bundle.main).instantiateViewController(withIdentifier: "ForgotPasswordVC") as? ForgotPasswordViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func didTappedOnSignUp(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Auth", bundle: Bundle.main).instantiateViewController(withIdentifier: "RegisterVC") as? RegisterViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func loginRequest(){
        Auth.auth().signIn(withEmail: txtEmail.text!, password: txtPassword.text!) { authResult, error in
            if let user = authResult?.user {
                
                let ref = Database.database().reference().child(user.uid)
                
                ref.observe(.value, with: { snapshot in
                    let resData = snapshot.value as! NSDictionary
                    let nic = resData.value(forKey:"nic_no") as? String
                    
                    let vehicle = resData.value(forKey:"vehicle_no") as? String
                    
                    
                    LocalUser.saveLoginData(user: UserModal(id: user.uid,avatarUrl:user.photoURL?.absoluteString ?? "", nic: nic ?? "", vehicleNo: vehicle ?? "", email: user.email ?? ""))
                    let nc = UIStoryboard.init(name: "TabBar", bundle: Bundle.main).instantiateViewController(withIdentifier: "TabBarVC")
                    self.resetWindow(with: nc)
                })
            }else if let error = error { 
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
    
    //MARK: Validate Login User
    public func validateLoginUser(completion: (_ status: Bool, _ message: String) -> ()) {
        do {
            if try validateForm() {
                completion(true, "Success")
            }
        } catch ValidateError.invalidData(let message) {
            completion(false, message)
        } catch {
            completion(false, "Missing Data")
        }
    }
    
    func validateForm() throws -> Bool {
        guard (txtEmail.text != nil), let value = txtEmail.text else {
            throw ValidateError.invalidData("Invalid Email")
        }
        guard !(value.trimLeadingTralingNewlineWhiteSpaces().isEmpty) else {
            throw ValidateError.invalidData("Email Empty")
        }
        guard isValidEmailAddress(email: value) else {
            throw ValidateError.invalidData("Invalid Email")
        }
        guard !((txtPassword.text ?? "").isEmpty) else {
            throw ValidateError.invalidData("Passowrd is Empty")
        }
        return true
    }
 
}
