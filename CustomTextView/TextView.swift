//
//  TextView.swift
//  CustomTextView
//
//  Created by super_user on 5/7/15.
//  Copyright (c) 2015 DevCom. All rights reserved.
//

import UIKit

@IBDesignable
class TextView : UIView, UITextViewDelegate {
    
    private var _view: UIView!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    
    
    @IBInspectable var text: String? {
        set(text) {
            textView.text = text
            
            showPlaceholderIfNeed()
        }
        get {
            return textView.text
        }
    }
    
    
    @IBInspectable var placeholder: String? {
        set(text) {
            placeholderLabel.text = text
        }
        get {
            return placeholderLabel.text
        }
    }
    
    
    /*
    * MARK - init
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    deinit {
        removeContentSizeObserver()
    }
    
    
    /*
    * MARK - UITextViewDelegate
    */
    
    func textViewDidChange(textView: UITextView) {
        showPlaceholderIfNeed()
    }
    
    @IBAction func textViewDidTap(sender: UITapGestureRecognizer) {
        placeholderLabel.hidden = true
        
        textView.becomeFirstResponder()
    }
    
    /*
    * MARK - KVO
    */
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject],
        context: UnsafeMutablePointer<Void>) {
            
            var top = (textView.bounds.size.height - textView.contentSize.height * textView.zoomScale) / 2.0
            top = top < 0.0 ? 0.0 : top
            textView.contentOffset = CGPoint(x: textView.contentOffset.x, y: -top)
    }
    
    
    /*
    * MARK - private
    */
    
    private func setup() {
        
        xibSetup()
        
        addContentSizeObserver()
        
        showPlaceholderIfNeed()
        
        textView.delegate = self
    }
    
    private func xibSetup() {
        _view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        _view.frame = bounds
        
        // Make the view stretch with containing view
        _view.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(_view)
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "TextView", bundle: bundle)
        
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    
    private func showPlaceholderIfNeed() {
        placeholderLabel.hidden = !textView.text.isEmpty
    }
    
    private func addContentSizeObserver() {
        textView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    private func removeContentSizeObserver() {
        textView.removeObserver(self, forKeyPath: "contentSize")
    }
}
