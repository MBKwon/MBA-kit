//
//  ViewModelConfigurable.swift
//  MBArchitecture
//
//  Created by Moonbeom KWON on 2023/09/11.
//

import Combine

#if canImport(UIKit)
import UIKit

// MARK: - View Model
public protocol InputMessage { }
public protocol OutputMessage { }

public protocol ViewModelConfigurable where VC: ViewControllerConfigurable {
    
    associatedtype VC
    
    var outputSubject: PassthroughSubject<Result<VC.O, Error>, Never> { get }
    
    func handleMessage(_ inputMessage: VC.I)
}

public protocol ViewControllerConfigurable where Self: UIViewController,
                                                 VM: ViewModelConfigurable,
                                                 I: InputMessage,
                                                 O: OutputMessage {
    associatedtype VM
    associatedtype I
    associatedtype O
}

#endif
