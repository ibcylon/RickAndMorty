//
//  CharacterDetailViewModel.swift
//  RickAndMortyDB
//
//  Created by Kanghos on 2023/09/12.
//

import Foundation

import RxCocoa
import RxSwift

protocol CharacterDetailDelegate: AnyObject {
  func toList()
}

final class CharacterDetailViewModel: ViewModelType {
  private let service: RMCharacterService
  private let model: RMCharacter  
  init(
    service: RMCharacterService,
    model: RMCharacter
  ) {
    self.service = service
    self.model = model
  }

  var delegate: CharacterDetailDelegate?
  
  struct Input {
    let trigger: Driver<Void>
    let backButtonTrigger: Driver<Void>
  }

  struct Output {
    let character: Driver<RMCharacter>
    let toList: Driver<Void>
    let error: Driver<Error>
  }
  
  func transform(input: Input) -> Output {
    let initialCharacter = Driver.just(model)
    let errorSubject = PublishSubject<Error>()
    let character = input.trigger.withLatestFrom(initialCharacter)
      .flatMapLatest { [unowned self] initial in
        service.getSingleItem(id: "\(initial.id)")
          .do(onError: { error in
            errorSubject.onNext(error)
          })
          .asDriverOnErrorJustComplete()
      }
    let toList = input.backButtonTrigger
      .do(onNext: { [weak self] in
        self?.delegate?.toList()
      })

    let error = errorSubject.asDriverOnErrorJustComplete()
    return Output(
      character: character,
      toList: toList,
      error: error
    )
  }
}
