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
    
    var viewModel: VM { get }
    var cancellables: Set<AnyCancellable> { get }
    
    func bindViewModel(_ viewModel: VM)
    func handleResult(_ result: Result<O, Error>)
}

// MARK: - View Interactor
public protocol InteractionMessage { }

public protocol ViewInteractorConfigurable where VC: ViewContollerInteractable {
    
    associatedtype VC
    
    func handleMessage(_ interactionMessage: VC.IM)
}

public protocol ViewContollerInteractable where Self: UIViewController,
                                                VI: ViewInteractorConfigurable,
                                                IM: InteractionMessage,
                                                O: OutputMessage {
    associatedtype VI
    associatedtype IM
    associatedtype O
    
    var viewInteractor: VI { get }
    
    func convertToInteraction(from outputMessage: O) -> IM
}
#endif
