//
//  ViewController.swift
//  MovingContentUnderKeyboard
//
//  Created by Toshiaki Nakamura on 2017/03/08.
//  Copyright © 2017年 Toshiaki Nakamura. All rights reserved.
//
//  reference：https://developer.apple.com/library/content/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/KeyboardManagement/KeyboardManagement.html
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var upperTextField: UITextField!
    @IBOutlet weak var lowerTextField: UITextField!
    private var activeTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.upperTextField.delegate = self
        self.lowerTextField.delegate = self
        
        self.registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.removeForKeyBoardNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown(notification:)), name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    private func removeForKeyBoardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWasShown(notification: Notification) {
        guard let info = notification.userInfo, let keyboardRect = info[UIKeyboardFrameEndUserInfoKey] as? CGRect, let activeField = self.activeTextField else {
            return
        }
        // キーボードの高さは、size.heightではなくorigin.yで求めること
        // iPadで外付けキーボードを使用したときに表示されるアクセサリービューの高さを求めるため（iPadで外付けキーボードを使用してキーボードが画面に表示されない場合でも、heightはキーボードを表示した数値になる）
        var viewRect = self.view.frame;
        let height = viewRect.height - keyboardRect.origin.y
        print("Rect=\(keyboardRect)&Height=\(height)")
        
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, height, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        viewRect.size.height -= (viewRect.height - height)
        if !viewRect.contains(activeField.frame.origin) {
            self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
        }
    }
    
    func keyboardWillBeHidden(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeTextField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

