//
//  CharacterSearchViewController.swift
//  RickAndMortyDB
//
//  Created by Kanghos on 2023/09/03.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class CharacterSearchViewController: UIViewController {
  private let characterListView: CharacterListView

  var viewModel: CharacterSearchViewModel!
  var listViewModel: CharacterListViewModel!
  private var disposeBag = DisposeBag()
  init() {
    self.characterListView = CharacterListView()
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    RMLogger.dataLogger.debug("[deinit] \(self)")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    setUpViews()
    bind()
//    setAlert()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

  private func setUpViews() {
    self.view.backgroundColor = .white

    self.view.addSubview(characterListView)
    characterListView.snp.makeConstraints {
      $0.edges.equalTo(self.view.safeAreaLayoutGuide)
    }

    self.title = "Characters"
    self.navigationController?.navigationBar.prefersLargeTitles = true
  }

  func bind() {
    self.characterListView.viewModel = self.listViewModel
    self.characterListView.bind()

    let item = UIBarButtonItem(title: "로그아웃", style: .plain, target: self, action: nil)
    self.navigationItem.rightBarButtonItem = item

    let logOutTrigger =
    item.rx.tap
      .flatMapLatest { [weak self] _ in
        Observable<Void>.create { observer in
          let alertController = UIAlertController(title: nil, message: "로그아웃하시겠습니까?", preferredStyle: .alert)
          let action = UIAlertAction(title: "로그아웃", style: .destructive) { _ in
            observer.onNext(Void())
          }
          let cancel = UIAlertAction(title: "취소", style: .cancel)
          alertController.addAction(action)
          alertController.addAction(cancel)
          self?.present(alertController, animated: true)

          return Disposables.create {
            observer.onCompleted()
          }
        }
      }
      .asDriverOnErrorJustComplete()

    let input = CharacterSearchViewModel.Input(
      toItemTrigger: self.rx.viewWillAppear.map { _ in }.asDriver(onErrorDriveWith: .empty()),
      logout: logOutTrigger
    )
    let output = viewModel.transform(input: input)
    output.toItem
      .drive()
      .disposed(by: disposeBag)

    output.logout
      .drive()
      .disposed(by: disposeBag)
  }

  private func setAlert() {
    let message = (AppData.email ?? "") + (AppData.nickname ?? "게스트") + "\n환영합니다."
    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    alert.addAction(.init(title: "확인", style: .default))
    self.present(alert, animated: true)
  }
}
