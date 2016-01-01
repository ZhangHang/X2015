//
//  KeyboardNotificationObserver.swift
//  X2015
//
//  Created by Hang Zhang on 1/1/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

public final class KeyboardNotificationObserver {
    
    public typealias keyboardOffsetChangeHandlerType = (keyboardOffset: CGFloat) -> Void
    
    private let keyboardOffsetChangeHandler: keyboardOffsetChangeHandlerType
    private weak var viewControllerView: UIView?
    private var pause: Bool = true
    
    init(viewControllerView: UIView!, keyboardOffsetChangeHandler: keyboardOffsetChangeHandlerType!){
        self.viewControllerView = viewControllerView
        self.keyboardOffsetChangeHandler = keyboardOffsetChangeHandler
        registerForKeyboardNotifications()
    }
    
    deinit{
        deregisterForKeyboardNotifications()
    }
    
    // MARK: - Notifications
    
    private func registerForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "keyboardWillChangeFrameNotification:",
            name: UIKeyboardWillChangeFrameNotification,
            object: nil)
    }
    
    private func deregisterForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc
    private func keyboardWillChangeFrameNotification(notification: NSNotification) {
        if (pause){
            return
        }
        
        let n = KeyboardNotification(notification)
        let keyboardFrame = n.frameEndForView(viewControllerView!)
        let animationDuration = n.animationDuration
        let animationCurve = n.animationCurve
        
        let viewFrame = viewControllerView!.frame
        let newBottomOffset = viewFrame.maxY - keyboardFrame.minY
        
        viewControllerView!.layoutIfNeeded()
        UIView.animateWithDuration(animationDuration,
            delay: 0,
            options: UIViewAnimationOptions(rawValue: UInt(animationCurve << 16)),
            animations: {
                self.keyboardOffsetChangeHandler(keyboardOffset: newBottomOffset)
            },
            completion: nil
        )
    }
    
    // MARK: - Public methods
    
    public func startMonitor() {
        pause = false
    }
    
    public func stopMonitor() {
        pause = true
    }
    
}