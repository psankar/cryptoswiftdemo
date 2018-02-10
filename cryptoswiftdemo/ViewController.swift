//
//  ViewController.swift
//  cryptoswiftdemo
//
//  Created by Sankar PS on 10/02/18.
//  Copyright © 2018 Sankar PS. All rights reserved.
//

import UIKit
import CryptoSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.


        var plainText = "Hello"

        if false {
            plainText = "Loooooong text"
        }

        let base64EncodedKey = "uSPsF3wHWCIhyrLc1KmslVTwmJHwylv8M8VgEGT1/zo="
        let base64EncodedInitialVector = "re4wa+QaPK4="

        let key = Array(Data(base64Encoded: base64EncodedKey)!)
        let iv = Array(Data(base64Encoded: base64EncodedInitialVector)!)

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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

