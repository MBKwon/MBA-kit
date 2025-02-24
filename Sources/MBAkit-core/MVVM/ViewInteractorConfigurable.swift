//
//  ViewInteractorConfigurable.swift
//  MBAkit
//
//  Created by Moonbeom KWON on 2/24/25.
//

#if canImport(UIKit)
import UIKit

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
    
    func convertToInteraction(from outputMessage: O) -> IM
}
#endif
