//
//  AmbiguousViewRule.swift
//  IBLinterKit
//
//  Created by Yuta Saito on 2018/09/26.
//

import IBDecodable

extension Rules {

    struct AmbiguousViewRule: Rule {

        static let identifier = "ambiguous"
        static let description = "Display error when views are ambiguous."
        static let isDefault = true

        init(context: Context) {}

        func validate(xib: XibFile) -> [Violation] {
            guard let views = xib.document.views else { return [] }
            return views.flatMap { validate(for: $0.view, file: xib) }
        }

        func validate(storyboard: StoryboardFile) -> [Violation] {
            guard let scenes = storyboard.document.scenes else { return [] }
            let views = scenes.compactMap { $0.viewController?.viewController.rootView }
            return views.flatMap { validate(for: $0, file: storyboard) }
        }

        private func validate<T: InterfaceBuilderFile>(for view: ViewProtocol, file: T) -> [Violation] {
            let violation: [Violation] = {
                if let isAmbiguous = view.isAmbiguous, isAmbiguous, view.verifyAmbiguity == nil {
                    let message = "\(viewName(of: view)) has ambiguous constraints"
                    return [Violation(pathString: file.pathString, message: message, level: .error)]
                } else {
                    return []
                }
            }()
            return violation + (view.subviews?.flatMap { validate(for: $0.view, file: file) } ?? [])
        }
    }
}
