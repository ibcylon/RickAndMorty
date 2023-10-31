//
//  EmailInputViewController.swift
//  RickAndMortyDB
//
//  Created by Kanghos on 2023/10/31.
//

import UIKit

import SnapKit

protocol EmailInputViewControllerDelegate: AnyObject {
  func emailInputViewNextButtonTap(email: String)
}
final class EmailInputViewController: UIViewController {

  var delegate: EmailInputViewControllerDelegate?

  private lazy var emailTextField: UITextField = {
    let field = UITextField()
    field.placeholder = "이메일을 입력하세요"
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
    print(#function)
    makeUI()
  }

  func makeUI() {
    self.view.backgroundColor = .white
    self.view.addSubViews(emailTextField, nextButton)

    emailTextField.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(10)
      $0.height.equalTo(60)
      $0.centerY.equalToSuperview().offset(-50)
    }
    nextButton.snp.makeConstraints {
      $0.width.equalTo(200)
      $0.height.equalTo(60)
      $0.centerX.equalToSuperview()
      $0.top.equalTo(emailTextField.snp.bottom).offset(20)
    }
  }

  // MARK: Private

  @objc
  private func nextButtonTap(_ sender: UIButton) {
    guard let email = emailTextField.text else { return }
    self.delegate?.emailInputViewNextButtonTap(email: email)
  }
}

extension EmailInputViewController {
  @objc
  private func textFieldDidChange(_ textField: UITextField) {
    self.nextButton.status = emailValidation(text: textField.text)
  }

  private func emailValidation(text: String?) -> Bool {
    guard let text = text,
          text.count > 6,
          text.contains("@")
    else {
      return false
    }
    return true
  }
}

#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct EmailInputViewController_Preview: PreviewProvider {
    static var previews: some View {
      EmailInputViewController().toPreView()
        .previewLayout(.sizeThatFits)
        .padding(10)
    }
}
#endif
