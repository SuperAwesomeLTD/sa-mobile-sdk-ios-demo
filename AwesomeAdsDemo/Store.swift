//
//  Store.swift
//  AwesomeAdsDemo
//
//  Created by Gabriel Coman on 29/09/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit
import RxSwift

protocol State {}

typealias Reducer <S: State> = (S, Event) -> S

protocol HandlesStateUpdates {
    func handle(_ state: AppState) -> Void
}

class Store <S: State> {
    
    private var reducer: Reducer<S>
    private var state: S {
        didSet {
            handlers.forEach { handl in
                if let han = handl as? HandlesStateUpdates {
                    han.handle(self.state as! AppState)
                }
            }
        }
    }
    
    private let handlers: NSMutableArray = NSMutableArray()
    
    private let bag = DisposeBag()
    
    init(state: S, reducer: @escaping Reducer<S>) {
        self.state = state
        self.reducer = reducer
    }
    
    func dispatch(_ event: Event) {
        self.state = self.reducer(self.state, event)
    }
    
    func dispatch(_ action: Observable<Event>) {
        let observable = action
        observable
            .subscribe(onNext: { event in
                self.dispatch(event)
            })
            .addDisposableTo(bag)
    }
    
    func addListener (_ listener: HandlesStateUpdates) {
        handlers.add(listener)
    }
    
    func removeListener(_ listener: HandlesStateUpdates) {
        handlers.remove(listener)
    }
    
    func getCurrentState () -> AppState {
        return state as! AppState
    }
}

