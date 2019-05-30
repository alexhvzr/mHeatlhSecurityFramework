//
//  ViewController.swift
//  PasswordVerification
//
//  Created by Alex Hayden van Zuiden-Rylander on 4/29/19.
//  Copyright © 2019 Alex Hayden van Zuiden-Rylander. All rights reserved.
//
/*
 Module Name:
 
 ViewController.swift
 
 Abstract:
 
 This module provides methods for validating a password and it's srength.
 Storing private data into the encrypted keychain API.
 Using biometirc authentication to verify the user to get access to the stored variables.
 
 Methods:
 
 textFieldShouldReturn          - What happens when the user inputs something into a text field
 passwordVerificationButton     - Button, calls validate on the text passed into the password field.
 getKeychainValues              - Button that get's the encypted data in the keychain if set.
 validate                       - Verifies the passwords strength, won't store if "weak"
 viewDidLoad                    - Loads the application interfaces and calls anything that comes after load.
 setupView                      - Defines the setup view of text. Mainly hides text until error / success.
 
 */


import UIKit
// MARK: FaceID & TouchID authentication
import LocalAuthentication

//import KeychainSwift



class ViewController: UIViewController, UITextFieldDelegate {
    // MARK: properties
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet var passwordVerificationLabel: UILabel!
    @IBOutlet weak var PassWordTextField: UITextField!
    @IBOutlet weak var successLabel: UILabel!
    
    @IBOutlet weak var PasswordFromKeychain: UILabel!
    //    class URLCredential : NSObject{
//
//    }

    // This enum is just in case there is an error loading the information into the keychain.
    enum KeychainError: Error {
        case noPassword
        case unexpectedPasswordData
        case unhandledError(status: OSStatus)
    }
    
    // MARK: Keychain
    // Creating the keychain object to work with apples keychain API.
    let keychain = KeychainSwift(keyPrefix: "test")
    
    // bioAuth is setup to use the users face or touch ID for later verification security measures.
    let bioAuth = LAContext()   // Creating a way to check for face or touch ID.
    

    
    
//    static let server = "www.example.com"   // Need to connect with a server.
    
//    lazy var credentials = Credentials.init(username: <#T##String#>, password: <#T##String#>)
    

    
//    let account = credentials.username
//    let password = credentials.password.data(using: String.Encoding.utf8)!
//    var query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
//                                kSecAttrAccount as String: account,
//                                kSecAttrServer as String: server,
//                                kSecValueData as String: password]
//
    
//    @IBOutlet weak var createAccountLabel: UILabel!
    
    
    
    // MARK: UITextFieldDelegate
    /*
     This function are the actions taken when the user types in information into each field.
     Right now it is set to switch to the next text field when the user clicks enter.
     The special case is for the password text field. Once the password is verified to be
     strong enough it is then stored into iOS's inherit API called Keychain. Keychain
     is an place to store small amounts of data. It encripts the information.
     With the KeychainWrapper.swift class it is now possible to set and get information stored in the keychain.
     SET: (string/data/picture, String Key)
     
     GET: (Key)
    */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        switch textField {
        case firstNameTextField:
            lastNameTextField.becomeFirstResponder()
        case lastNameTextField:
            PassWordTextField.becomeFirstResponder()
        case PassWordTextField:
            // Validate Text Field
            let (valid, message) = validate(textField)
            
            if valid {
            
                keychain.set(textField.text!, forKey: "password")
                
//                print(keychain.get("password"))
                
                // This if statemeent is checking if the phone has either face or touch ID.
                // Any iOS or macOS before this didn't have either of those functionalities.
                if #available(iOS 8.0, macOS 10.12.1, *){
                    
                }
                emailTextField.becomeFirstResponder()
              
            }
            
            // Update Password Validation Label
            self.passwordVerificationLabel.text = message
            
            // Show/Hide Password Validation Label
            UIView.animate(withDuration: 0.25, animations: {
               self.passwordVerificationLabel.isHidden = valid
            })
            
        default:
            emailTextField.resignFirstResponder()
            
        }
        
        
        return true;
    }
    

    
    // MARK: Actions
    /*
     This function is the action that happens when the user clicks the "verify" button within the app.
     It then validates the string passed into the password field.
     If the password isn't considered strong enough it shows the passwordverification label.
    */
    @IBAction func passwordVerificationButton(_ sender: UIButton) {
        
        // Validate Text Field
        let (valid, message) = validate(PassWordTextField)
        
        // Update Password Validation Label
        self.passwordVerificationLabel.text = message
        
        // Show/Hide Password Validation Label
        UIView.animate(withDuration: 0.25, animations: {
            self.passwordVerificationLabel.isHidden = valid
        })
        
    }
    
    // This is the button to show that the users information is actually stored in the keychain.
    @IBAction func getKeychainValues(_ sender: UIButton) {
        
        let myContext = LAContext()
        let myLocalizedReasonString = "Biometric Authntication testing !! "
        
        var authError: NSError?
        if #available(iOS 8.0, macOS 10.12.1, *) {
            if myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                myContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString) { success, evaluateError in
                    
                    DispatchQueue.main.async {
                        if success {
                            // User authenticated successfully, take appropriate action
                            self.successLabel.isHidden = false
                            self.successLabel.text = "Successfully Authenticated"
                        } else {
                            // User did not authenticate successfully, look at error and take appropriate action
                            self.successLabel.textColor = UIColor.red
                            self.successLabel.isHidden = false
                            self.successLabel.text = "Couldn't Authenicate"
                        }
                    }
                }
            } else {
                // Could not evaluate policy; look at authError and present an appropriate message to user
                self.successLabel.textColor = UIColor.black
                self.successLabel.isHidden = false
                successLabel.text = "Could not evaluate policy."
            }
        } else {
            // Fallback on earlier versions
            self.successLabel.textColor = UIColor.black
            self.successLabel.isHidden = false
            successLabel.text = "This feature is not supported."
        }
        
        
    
        self.PasswordFromKeychain.text = keychain.get("password")

    }
    
    
    // MARK: File Private Fucntions
    /*  This method is file private because file private access restricts the use of an entity to its own defining source file.
        This gives the user access throughout the entire file.
        The method is to validate the users password, making sure it's a "strong" password before.
     Returns: A boolean true or false depending on if the password matches the constraints. It also returns a string prompting what was wrong that the user needs to fix.
    */
    fileprivate func validate(_ textField: UITextField) -> (Bool, String?) {
        guard let text = textField.text else {
            return (false, nil)
        }
        
        if textField == PassWordTextField {         // Checks if there is minimum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character.
            if text.count < 8 {
                if text.count == 0 {
                    return (false, "Password cannot be empty.")
                }
                return (false, "Password too short.");
            }
            // Checks if there is a number.
            let number = ".*[0-9]+.*"
            if (!NSPredicate(format: "SELF MATCHES %@", number).evaluate(with: text)){
                return(false, "Password must contain a number.")
            }
            
            // Checks if there's a lower case character.
            let lowerCase = ".*[a-z]+.*"
            if(!NSPredicate(format: "SELF MATCHES %@", lowerCase).evaluate(with: text)){
                return(false, "Password needs lower case.")
            }
            
            // Checks if there's an upper case character.
            let upperCase = ".*[A-Z]+.*"
            if(!NSPredicate(format: "SELF MATCHES %@", upperCase).evaluate(with: text)){
                return(false, "Password needs upper case.")
            }
            
            // Checks if there is a special character
            let specialCharacter = ".*[!@#$%^&*()\\-_=+{}|?>.<,:;~`’]+.*"
            if(!NSPredicate(format: "SELF MATCHES %@", specialCharacter).evaluate(with: text)){
                return(false, "Password needs a special character.")
            }
            
            // This method checks all of the above mthods, but the error message wasn't specific enough.
//            let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
//            return (NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: text), "Invalid Password")
        }
      
        
        return (text.count > 0, "This field cannot be empty.")      // Checks if the text has no value
    }
    
    
    /*
     This function is a standard function in all iOS apps. What it does is once the view controller has loaded its view hierarchy into the memory,
     it runs the initialization on views that are loaded from the files.
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Handle the test feild's user input through delgate callbacks.
        PassWordTextField.delegate = self; // self refers to the viewController class becuase it's refenced inside the scope of the view controller.
        // Do any additional setup after loading the view.
        
        // Setup View
        setupView()
        
        
    }
    // MARK: - View Methods
    /*
     This File private function just hides the verification message in the app that appears only if the user enters in a
     "weak" password.
     */
    fileprivate func setupView() {
        // Configure Password Validation Label
        passwordVerificationLabel.isHidden = true
        successLabel.isHidden = true
    }

}

