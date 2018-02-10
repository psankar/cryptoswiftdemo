//
//  ViewController.swift
//  cryptoswiftdemo
//
//  Created by Sankar PS on 10/02/18.
//  Copyright © 2018 Sankar PS. All rights reserved.
//

import UIKit
import CryptoSwift

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let imagePicker = UIImagePickerController()
    var key : Array<UInt8> = []
    var iv : Array<UInt8> = []

    @IBOutlet weak var labelMsg: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false

        let base64EncodedKey = "uSPsF3wHWCIhyrLc1KmslVTwmJHwylv8M8VgEGT1/zo="
        let base64EncodedInitialVector = "re4wa+QaPK4="
        key = Array(Data(base64Encoded: base64EncodedKey)!)
        iv = Array(Data(base64Encoded: base64EncodedInitialVector)!)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        if let userPickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {

            let imageData:NSData = UIImagePNGRepresentation(userPickedImage)! as NSData
            let plainText = imageData.base64EncodedString(options: .lineLength64Characters)

//            Uncomment the section if you want to save the selected image
// as a base64 encoded file.
//            let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("output.txt")
//            do {
//                // Write contents to file
//                try plainText.write(to: path, atomically: true, encoding: .utf8)
//            }
//            catch let error as NSError {
//                print("Ooops! Something went wrong: \(error)")
//                return
//            }
//            print("Image picked, saved at \(path) and about to encrypt")

            imagePicker.dismiss(animated: true, completion: nil)

            do {
                let cipher = try ChaCha20(key: key, iv: iv).encrypt(plainText.bytes).toBase64()!
                print("Plain text: ", plainText)
                print("Encrypted text: ", cipher)

                let cipherBytes = Data(base64Encoded: cipher)!
                let decrypted = try ChaCha20(key: key, iv: iv).decrypt(cipherBytes.bytes)
                let decryptedText = String(data: Data(decrypted), encoding: .utf8)!
                print("Decrypted text: ", decryptedText)

                if decryptedText != plainText {
                    print("Exiting due to failure of encryption / decryption")
                    exit(EXIT_FAILURE)
                }
            }
            catch {
                print("Exiting due to failure of encryption / decryption")
                exit(EXIT_FAILURE)
            }
        } else {
            print("Exiting due to failure during image picking")
            exit(EXIT_FAILURE)
        }
    }

    @IBAction func buttonTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

