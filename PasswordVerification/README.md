#  iOS Security Framework

This application was developed to test the security framework developed in swift files. The objective was to develop a framework that other developers code use in order to create a secure app without having the security background. It uses the apple keychain API to store the users data in the keychaim. Keychain is an internal API in iOS that encrypts and stores small data. To access this data the user must either use biometrics or enter their password.

# What methods are in this?

## - textFieldShouldReturn()
>This method is the functionality of what happens when the user inputs something into a text field. In the case of the application it should return the next text field in succession. The only difference is when the password text field is entered the application will try to grab faceID or touchID if the user has a phone capable. If not, it will get the users input for the password and verify if the password passed is strong through methods such as "validate".

## - passwordVerificationButton()
>This is a button that the was used for testing to see that the verification calls validate on the text passed into the password field.

## - getKeychainValues()
>This button in the application was to see that the encrypted data stored in the keychain could be retrieved. The text field within the app changed to show what password was stored.

## - validate()
>Verifies the passwords strength, won't store if "weak". What this means is that the password that the user enters is at least 8 characters long, the password has a capital letter, a lower case letter, a number and a special character.

## - viewDidLoad()
> Loads the application interfaces and calls anything that comes after load. This function is inherent in the iOS app development process. It verifies that everything that should've loaded in the application did. 

## - setupView()
>Defines the setup view of text. The function definces what is supposed to be hidden from the user unitl there is an error message that needs to indicate that the input was an error or show nothing in that case that the input was valid.

# Wrappers used:

## - KeychainSwift
This was a wrapper that was implemented by someone else who's work was available on github and worked into this application. It provided a simple way for me to use the keychain API. 



