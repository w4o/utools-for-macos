//
//  ViewController.swift
//  encode
//
//  Created by Frank on 2016/11/30.
//  Copyright © 2016年 Frank. All rights reserved.
//

import Cocoa
import CryptoSwift


class ViewController: NSViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        initPage()
        
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    @IBOutlet weak var numChk: NSButton!
    
    @IBOutlet weak var abcLowerCaseChk: NSButton!
    
    @IBOutlet weak var abcUpperCaseChk: NSButton!
    
    @IBOutlet weak var charChk: NSButton!
    
    @IBOutlet weak var lengthTxt: NSTextField!
    
    @IBOutlet weak var genResultTxt: NSTextField!
    
    @IBOutlet weak var genBtn: NSButton!
    
    @IBOutlet weak var lengthSlider: NSSlider!
    
    @IBOutlet weak var lengthStep: NSStepper!
    
    
    let numArr:[String] = ["0","1","2","3","4","5","6","7","8","9"]
    ,abcLowerCaseArr:[String] = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
    ,abcUpperCaseArr:[String] = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    ,charArr:[String] = ["!","@","#","$","%","^","&","*"]
    
    
    // 生成按钮点击动作
    @IBAction func genBtnAction(_ sender: Any) {
        
       let result = genPass()
        
        genResultTxt.stringValue = result
        
    }
    
    // 复制按钮 动作
    @IBAction func copyBtnAction(_ sender: Any) {
        setTextToPasteBoard(text: genResultTxt.stringValue)
    }
    
    // 生成并复制按钮动作
    @IBAction func genAndCopyBtnAction(_ sender: Any) {
        
        let result = genPass()
        
        genResultTxt.stringValue = result
        
        setTextToPasteBoard(text: result)
    }
    // 生成密码
    func genPass() -> String {
        let length:Int32 = lengthTxt.intValue
        
        ,isNum = numChk.state
        ,isChar = charChk.state
        ,isAbcLowerCase = abcLowerCaseChk.state
        ,isAbcUpperCase = abcUpperCaseChk.state
        
        var strBox:[String] = []
        
        if isNum  == 1 {
            strBox = strBox + numArr
        }
        if isChar == 1 {
            strBox = strBox + charArr
        }
        if isAbcLowerCase == 1 {
            strBox = strBox + abcLowerCaseArr
        }
        if isAbcUpperCase == 1 {
            strBox = strBox + abcUpperCaseArr
        }
        
        let arrLength:UInt32 = UInt32(strBox.count)
        
        var result = ""
        
        
        for _:Int32 in 1 ... length {
            
            let random = arc4random() % arrLength
            result = result + strBox[Int(random)]
        }
        
        return result
    }
    
    // 复制剪切板
    func setTextToPasteBoard(text: String)  {
        let pasteBoard = NSPasteboard.general()
        pasteBoard.declareTypes([NSStringPboardType], owner: nil)
        pasteBoard.writeObjects([text as NSPasteboardWriting])
    }
    
    // 长度文本框 动作
    @IBAction func lengthTxtAction(_ sender: Any) {
        
        let length = lengthTxt.stringValue
        lengthSlider.stringValue = length
        lengthStep.stringValue = length
        
    }
    // 长度滑动条 动作
    @IBAction func lengthSliderAction(_ sender: Any) {
        
        let length = lengthSlider.doubleValue
        lengthTxt.intValue = Int32(round(length))
        lengthStep.intValue = Int32(round(length))
        
    }
    // 长度步进 动作
    @IBAction func lengthStepAction(_ sender: Any) {
        
        let length = lengthStep.intValue
        lengthTxt.intValue = length
        lengthSlider.intValue = length
        
    }
    
    // ------------------------------
    
    
    var type = "URL";
    
    func initPage(){
        
        keyTxt.stringValue = ""
        //sourceTxt.stringValue = ""
        resultTxt.stringValue = ""
        keyTxt.isEnabled = false
        decodeBtn.isEnabled = true
        
    }
    
    
    //加密 按钮
    @IBOutlet weak var encodeBtn: NSButton!
    //解密 按钮
    @IBOutlet weak var decodeBtn: NSButton!
    // 密钥 文本框
    @IBOutlet weak var keyTxt: NSTextField!
    // 源 文本框
    @IBOutlet weak var sourceTxt: NSTextField!
    // 结果 文本框
    @IBOutlet weak var resultTxt: NSTextField!
    // 类型
    @IBOutlet weak var typeSel: NSPopUpButton!
    
    // 加密按钮事件
    @IBAction func encodeBtnAction(_ sender: Any) {
        
        let sourceString = sourceTxt.stringValue
        
        let keyString = keyTxt.stringValue
        
        var encryptedString = ""
        
        let sourceByte = sourceString.utf8.map({$0})
        
        let keyByte = keyString.utf8.map({$0})
        
        switch type {
            
        case "URL":
            encryptedString = sourceString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            break
        case "SHA1":
            encryptedString = sourceString.sha1()
            break
        case "SHA224":
            encryptedString = sourceString.sha224()
            break
        case "SHA256":
            encryptedString = sourceString.sha256()
            break
        case "SHA384":
            encryptedString = sourceString.sha384()
            break
        case "SHA512":
            encryptedString = sourceString.sha512()
            break
        case "MD5(16)":
            encryptedString = sourceString.md5()
            let index = encryptedString.index(encryptedString.startIndex, offsetBy:16)
            encryptedString = encryptedString.substring(to: index)
            break
        case "MD5(32)":
            encryptedString = sourceString.md5()
            break
        case "HmacSHA1":
            encryptedString = try! HMAC(key: keyByte, variant: .sha1).authenticate(sourceByte).toHexString()
            break
        case "HmacSHA224":
            encryptedString = "待开发"
            break
        case "HmacSHA256":
            encryptedString = try! HMAC(key: keyByte, variant: .sha256).authenticate(sourceByte).toHexString()
            break
        case "HmacSHA384":
            encryptedString = try! HMAC(key: keyByte, variant: .sha384).authenticate(sourceByte).toHexString()
            break
        case "HmacSHA512":
            encryptedString = try! HMAC(key: keyByte, variant: .sha512).authenticate(sourceByte).toHexString()
            break
        case "HmacMD5":
            encryptedString = try! HMAC(key: keyByte, variant: .md5).authenticate(sourceByte).toHexString()
            break
        case "AES":
            let iv: Array<UInt8> = AES.randomIV(AES.blockSize)
            encryptedString = try! AES(key: keyByte, iv: iv, blockMode: .CBC, padding: PKCS7()).encrypt(sourceByte).toHexString()
            
            print(keyByte.count * 8)
            break
        case "DES":
            encryptedString = "待开发"
            break
        case "Rabbit":
            encryptedString = "待开发"
            //encryptedString =  try! Rabbit(key: keyByte).encrypt(sourceByte).toHexString()
            
            break
            
        case "RC4":
            encryptedString = "待开发"
            break
            
        case "TripleDES":
            encryptedString = "待开发"
            break
            
        case "Base64":
            encryptedString = (sourceString.data(using: .utf8)?.base64EncodedString())!
            break
            
        default:
            break
        }
        
        resultTxt.stringValue = String(encryptedString)
        
        
        //let alert = NSAlert()
        //alert.informativeText = "encode"
        //alert.messageText = "tips"
        //alert.runModal()
    }
    
    
    // 解密按钮事件
    @IBAction func decodeBtnAction(_ sender: Any) {
        
        let sourceString = sourceTxt.stringValue
        
        let sourceByte = sourceString.utf8.map({$0})
        
        
        let keyString = keyTxt.stringValue
        
        var decryptedString = ""
        
        switch type {
            
        case "URL":
            decryptedString = sourceString.removingPercentEncoding!
            break
        case "Rabbit":
            decryptedString = try! Rabbit(key: keyString).decrypt(sourceByte).toHexString()
            break
        case "Base64":
            decryptedString = "待开发"
            break
        case "AES":
            decryptedString = "待开发"
            break
        case "DES":
            decryptedString = "待开发"
            break
        case "Rabbit":
            decryptedString = "待开发"
            break
        case "RC4":
            decryptedString = "待开发"
            break
        case "TripleDES":
            decryptedString = "待开发"
            break
        default:
            break
        }
        
        resultTxt.stringValue = String(decryptedString)
        
    }
    
    // 下拉列表改变事件
    @IBAction func typeSelAction(_ sender: Any) {
        
        initPage()
        
        type = typeSel.selectedItem!.title
        
        
        // 不需要填写密钥的加密算法
        if type == "URL" || type == "SHA1" || type == "SHA224" || type=="SHA256" || type=="SHA384" || type=="SHA512" || type=="MD5(16)" || type=="MD5(32)" || type == "Base64" {
            keyTxt.isEnabled = false
        }
        
        // 需要填写密钥的加密算法
        if type == "HmacSHA1" || type == "HmacSHA224" || type == "HmacSHA256" || type == "HmacSHA384" || type == "HmacSHA512" || type == "HmacMD5" || type == "AES" || type == "DES" || type == "Rabbit" || type == "RC4" || type == "TripleDES" {
            keyTxt.isEnabled = true
        }
        
        // 不能解密的加密算法
        if type == "SHA1" || type == "SHA224" || type=="SHA256" || type=="SHA384" || type=="SHA512" || type=="MD5(16)" || type=="MD5(32)" || type=="HmacSHA1" || type=="HmacSHA224" || type=="HmacSHA256" || type=="HmacSHA384" || type=="HmacSHA512" || type=="HmacMD5" {
            decodeBtn.isEnabled = false
        }
        
        // 能解密的算法
        if  type == "URL" || type == "AES" || type == "DES" || type == "Rabbit" || type == "RC4" || type == "TripleDES" || type == "Base64" {
            decodeBtn.isEnabled = true
        }
        
    }
    
    
}

