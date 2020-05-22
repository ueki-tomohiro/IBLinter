//
//  CustomClassNameRule.swift
//  IBLinterKit
//
//  Created by SaitoYuta on 2017/12/11.
//

import Foundation
import IBDecodable

private extension XibFile {
  var fileExtension: String {
    return URL.init(fileURLWithPath: pathString).pathExtension
  }
  var fileNameWithoutExtension: String {
    return fileName.replacingOccurrences(of: ".\(fileExtension)", with: "")
  }
}

private extension StoryboardFile {
    var fileExtension: String {
        return URL.init(fileURLWithPath: pathString).pathExtension
    }
    var fileNameWithoutExtension: String {
        return fileName.replacingOccurrences(of: ".\(fileExtension)", with: "")
    }
}

extension Rules {

    struct CustomClassNameRule: Rule {

        static let identifier = "custom_class_name"
        static let description = "Custom class name of ViewController or View should be same as file name."

        private var classes: [String: (suffix: String, strict: Bool)] = [:]

        init(context: Context) {
            for customClassConfig in context.config.customClassRule {
                self.classes[customClassConfig.elementClass] = (suffix: customClassConfig.suffix, strict: customClassConfig.strict)
            }
        }

        func validate(storyboard: StoryboardFile) -> [Violation] {
            guard let viewController = storyboard.document.scenes?.first?.viewController,
                let customClass = viewController.viewController.customClass,
                storyboard.document.scenes?.count == 1,
                storyboard.fileNameWithoutExtension != "Main" else {
                // Skip when storyboard has multiple view controllers or Main.storyboard.
                return []
            }
            return validate(elementClass: viewController.viewController.elementClass, 
             customClass: customClass, 
             file: storyboard, 
             fileNameWithoutExtension: storyboard.fileNameWithoutExtension)
        }

        func validate(xib: XibFile) -> [Violation] {
            guard let view = xib.document.views?.first?.view,
                let customClass = view.customClass,
                xib.document.views?.count == 1 else { return [] }

            return validate(elementClass: view.elementClass, 
             customClass: customClass, 
             file: xib, 
             fileNameWithoutExtension: xib.fileNameWithoutExtension)
        }

        private func validate<T: InterfaceBuilderFile>(
            elementClass: String, 
            customClass: String, 
            file: T, 
            fileNameWithoutExtension: String
        ) -> [Violation] {
            if let customViewRule = classes[elementClass] {
                let hasSuffix = fileNameWithoutExtension.hasSuffix(customViewRule.suffix)
                if customViewRule.strict && !hasSuffix {
                    let message = "storyboard '\(fileNameWithoutExtension)' should has suffix '\(customViewRule.suffix)' "
                    return [Violation.init(pathString: file.pathString, message: message, level: .error)]
                }

                let viewClass: String
                if hasSuffix {
                    viewClass = fileNameWithoutExtension
                } else {
                    viewClass = fileNameWithoutExtension + customViewRule.suffix
                }
                if customClass == viewClass {
                    return []
                }
                if customViewRule.strict {
                    let message = "custom class name '\(customClass)' should be '\(viewClass)' "
                    return [Violation.init(pathString: file.pathString, message: message, level: .error)]
                }

                if customClass == fileNameWithoutExtension { return [] }

                let message = "custom class name '\(customClass)' should be '\(fileNameWithoutExtension)' or '\(viewClass)' "
                return [Violation.init(pathString: file.pathString, message: message, level: .error)]
            } else if customClass == fileNameWithoutExtension { 
                return [] 
            }

            let message = "custom class name '\(customClass)' should be '\(fileNameWithoutExtension)' "
            return [Violation.init(pathString: file.pathString, message: message, level: .error)]
        }
    }
}
