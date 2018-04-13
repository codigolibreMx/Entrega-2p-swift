//
//  ViewController.swift
//  Entrega-2p
//
//  Created by UX Lab - ISC Admin on 3/21/18.
//  Copyright © 2018 UX Lab - ISC Admin. All rights reserved.
//

import UIKit
import Alamofire
class ViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var user: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var login_button: UIButton!
    
    @IBOutlet weak var messageField: UITextField!
    
    var emailField: String?
    var emailRecoverField: String?
    var passField: String?
    
    var json: String = ""
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user.delegate = self
        password.delegate = self
        super.viewDidLoad()
//        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        print("hi")
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func login(_ sender: Any) {
        guard let User = user.text, let Pass = password.text else {
            // ONLY EXECUTES IF parseJson IS nil
            // MUST EXIT CURRENT SCOPE AS A RESULT
            return // or throw NSError()
        }
        Alamofire.request("https://6ht6ovuahj.execute-api.us-east-1.amazonaws.com/api/login/", method: .post, parameters: ["username" : User , "password" : Pass],encoding: JSONEncoding.default, headers: nil)
            .responseJSON{  response in
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        if let result = response.result.value {
                            let JSON = result as! NSDictionary
                            self.json = JSON.allValues[0] as! String
                            //print(JSON.allValues[0]) //token
                                DispatchQueue.main.async {
                                    self.performSegue(withIdentifier: "pushHome", sender: sender)
                                    
                                }
                        }
                        
                        
                    default:
                        print("error with response status: \(status)")
                        self.modalText(texto: "Datos no validos")
                    }
                }
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return true
    }
    
    @IBAction func register(_ sender: UIButton) {
//        let registerComplete = UIAlertController(title: "Register Complete", message: nil, preferredStyle: .alert)
        let alert = UIAlertController(title: "Register", message: nil, preferredStyle: .alert)
        
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Default action"), style: .cancel, handler: { _ in
        }))
//        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
//
//        }))
        alert.addTextField { (userField) in
            userField.placeholder = "email"
            userField.textAlignment = .center
            
        }
        alert.addTextField { (passField) in
            passField.placeholder = "password"
            passField.textAlignment = .center
            passField.isSecureTextEntry  = true
            
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            let emailField = alert.textFields![0] as UITextField
            let passField = alert.textFields![1] as UITextField
            self.emailField = emailField.text!
            self.passField = passField.text!
            self.register()
        }))

        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func Forgot(_ sender: UIButton) {
        let alert2 = UIAlertController(title: "Forgot Password", message: nil, preferredStyle: .alert)
        
        
        alert2.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Default action"), style: .cancel, handler: { _ in
        }))
        
        alert2.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            let emailRecoverField = alert2.textFields![0] as UITextField
            self.emailRecoverField = emailRecoverField.text!
            self.forgotPassword()
        }))
        alert2.addTextField { (forgotField) in
            forgotField.placeholder = "email"
            forgotField.textAlignment = .center
        }
        self.present(alert2, animated: true, completion: nil)
    }
    
    func forgotPassword(){
        Alamofire.request("https://6ht6ovuahj.execute-api.us-east-1.amazonaws.com/api/forgot/", method: .post, parameters: ["email" : self.emailRecoverField ?? ""],encoding: JSONEncoding.default, headers: nil)
            .responseJSON{  response in
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        if let result = response.result.value {
                            let JSON = result as! NSDictionary
                            print(JSON)
                            self.modalText(texto: "Correo de recuperación enviado")
                        }
                        
                    default:
                        print("error with response status: \(status)")
                        self.modalText(texto: "Correo no valido")
                    }
                }
        }
    }
    func register(){
        Alamofire.request("https://6ht6ovuahj.execute-api.us-east-1.amazonaws.com/api/register/", method: .post, parameters: ["email" : self.emailField ?? "", "password" : self.passField ?? ""],encoding: JSONEncoding.default, headers: nil)
            .responseJSON{  response in
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        if let result = response.result.value {
                            let JSON = result as! NSDictionary
                            print(JSON)
                            self.modalText(texto: "Registro completado correctamente")
                        }
                        
                    default:
                        print("error with response status: \(status)")
                        self.modalText(texto: "Datos no validos")
                    }
                }
        }
    }
    
    func modalText(texto: String){
        let alert = UIAlertController(title: texto, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
        }))

        self.present(alert, animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination  as! TableViewController // Get our ColourView
        vc.usuario = self.user.text!
        vc.contraseña = self.password.text!
        vc.tok = json
    }
//    @objc func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y == 0{
//                self.view.frame.origin.y -= keyboardSize.height
//            }
//        }
//    }
//    
//    @objc func keyboardWillHide(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y != 0{
//                self.view.frame.origin.y += keyboardSize.height
//            }
//        }
//    }
//    
//   
    
}




