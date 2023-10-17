//
//  MicroBean.swift
//
//
//  Created by Moonbeom KWON on 2023/10/17.
//

import Combine
import Foundation


#if canImport(UIKit)
import UIKit

public class MicroBean<VC, VM, VI> where VC: ViewControllerConfigurable & ViewContollerInteractable,
                                         VM: ViewModelConfigurable,
                                         VI: ViewInteractorConfigurable,
                                         VC.I == VM.VC.I,
                                         VC.O == VM.VC.O,
                                         VC.IM == VI.VC.IM {

    private let viewController: VC
    private let viewModel: VM
    private let viewInteractor: VI

    private let messageObserver: (Result<VC.O, Error>) -> Void
    private var cancellables = Set<AnyCancellable>()

    public init(withVC viewController: VC,
                viewModel: VM,
                viewInteractor: VI,
                observeMessage: @escaping (Result<VC.O, Error>) -> Void) {

        self.viewController = viewController
        self.viewModel = viewModel
        self.viewInteractor = viewInteractor

        self.messageObserver = observeMessage
        self.bindViewModel(self.viewModel)
    }
}

extension MicroBean {
    public func handleInputMessage(inputMessage: VC.I) {
        self.viewModel.handleMessage(inputMessage)
    }
}

private extension MicroBean {
    func bindViewModel(_ viewModel: VM) {
        viewModel.outputSubject
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: self.handleResult(_:))
            .store(in: &self.cancellables)
    }

    func handleResult(_ result: Result<VC.O, Error>) {
        let handleOutputMessage: (VC.O) -> Void = {
            self.messageObserver(.success($0))
            self.viewInteractor.handleMessage(self.viewController.convertToInteraction(from: $0))
        }

        let handleError: (Error) -> Void = {
            self.messageObserver(.failure($0))
        }

        result.fold(success: handleOutputMessage,
                    failure: handleError)
    }
}

#endif

