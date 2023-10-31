//
//  NickNameInputViewController.swift
//  RickAndMortyDB
//
//  Created by Kanghos on 2023/10/31.
//

import UIKit

import SnapKit

protocol NicknameInputViewControllerDelegate: AnyObject {
  func nicknameInputViewNextButtonTap(nickname: String)
}
final class NicknameInputViewController: UIViewController {

  var delegate: NicknameInputViewControllerDelegate?

  private lazy var nicknameTextField: UITextField = {
    let field = UITextField()
    field.placeholder = "닉네임을 입력하세요"
    field.layer.borderWidth = 0.5
    field.layer.borderColor = UIColor.black.cgColor
    field.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    return field
  }()

  private lazy var nextButton: RMButton = {
    let button = RMButton(title: "다음")
    button.addTarget(self, action: #selector(nextButtonTap), for: .touchUpInside)
    return button
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    makeUI()
  }

  func makeUI() {
    self.view.backgroundColor = .white
    self.view.addSubViews(nicknameTextField, nextButton)

    nicknameTextField.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(10)
      $0.height.equalTo(60)
      $0.centerY.equalToSuperview().offset(-50)
    }
    nextButton.snp.makeConstraints {
      $0.width.equalTo(200)
      $0.height.equalTo(60)
      $0.centerX.equalToSuperview()
      $0.top.equalTo(nicknameTextField.snp.bottom).offset(20)
    }
  }

  // MARK: Private

  @objc
  private func nextButtonTap(_ sender: UIButton) {
    guard let nickname = self.nicknameTextField.text else {
      return
    }
    self.delegate?.nicknameInputViewNextButtonTap(nickname: nickname)
  }
}

extension NicknameInputViewController {
  @objc
  private func textFieldDidChange(_ textField: UITextField) {
    self.nextButton.status = nicknameValidation(text: textField.text)
  }

  private func nicknameValidation(text: String?) -> Bool {
    guard let text = text,
          text.count > 6
    else {
      return false
    }
    return true
  }
}

#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct NicknameInputViewController_Preview: PreviewProvider {
  static var previews: some View {
    NicknameInputViewController().toPreView()
      .previewLayout(.sizeThatFits)
      .padding(10)
  }
}
#endif
