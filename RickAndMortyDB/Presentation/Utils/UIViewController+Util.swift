//
//  UIViewController+Util.swift
//  RickAndMortyDB
//
//  Created by Kanghos on 2023/10/31.
//

import Foundation

#if DEBUG
import SwiftUI
extension UIViewController {
  private struct Preview: UIViewControllerRepresentable {
    let viewController: UIViewController

    func makeUIViewController(context: Context) -> UIViewController {
      return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
  }

  func toPreView() -> some View {
    Preview(viewController: self)
  }
}
#endif
