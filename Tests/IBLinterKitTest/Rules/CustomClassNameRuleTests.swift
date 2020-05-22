//
//  CustomClassNameRuleTests.swift
//  IBLinterKitTest
//
//  Created by Yuta Saito on 2019/03/30.
//

@testable import IBLinterKit
import XCTest
import IBDecodable

class CustomClassNameRuleTests: XCTestCase {

    let fixture = Fixture()

    func testCustomClassNameWithNoConfig() {
        let rule = Rules.CustomClassNameRule(context: .mock(from: .default))

        let storyboardUrl = fixture.path("Resources/Rules/CustomClassNameRule/ViewControllerTest.storyboard")
        let ngViolations = try! rule.validate(storyboard: StoryboardFile(url: storyboardUrl))

        XCTAssertEqual(ngViolations.count, 1)

        let okCellUrl = fixture.path("Resources/Rules/CustomClassNameRule/TestTableViewCell.xib")
        let okViolations = try! rule.validate(xib: XibFile(url: okCellUrl))

        XCTAssertEqual(okViolations.count, 0)
    }

    func testCustomClassNameWithConfig() {
        let customClassRule: [CustomClassConfig] = [
            .init(elementClass: "UITableViewCell", suffix: "TableViewCell", strict: false)
        ]

        let config = Config(customClassRule: customClassRule)
        let rule = Rules.CustomClassNameRule(context: .mock(from: config))

        let okCellUrl = fixture.path("Resources/Rules/CustomClassNameRule/TestTableViewCell.xib")
        let okViolations = try! rule.validate(xib: XibFile(url: okCellUrl))

        XCTAssertEqual(okViolations.count, 0)

        let matchCellUrl = fixture.path("Resources/Rules/CustomClassNameRule/TestCell.xib")
        let matchViolations = try! rule.validate(xib: XibFile(url: matchCellUrl))

        XCTAssertEqual(matchViolations.count, 0)
    }

    func testCustomClassNameStrictWithConfig() {
        let customClassRule: [CustomClassConfig] = [
            .init(elementClass: "UIViewController", suffix: "ViewController", strict: true)
        ]

        let config = Config(customClassRule: customClassRule)
        let rule = Rules.CustomClassNameRule(context: .mock(from: config))

        let ngStoryboardUrl = fixture.path("Resources/Rules/CustomClassNameRule/ViewControllerTest.storyboard")
        let ngViolations = try! rule.validate(storyboard: StoryboardFile(url: ngStoryboardUrl))

        XCTAssertEqual(ngViolations.count, 1)

        let strictStoryboardUrl = fixture.path("Resources/Rules/CustomClassNameRule/TestBase.storyboard")
        let strictViolations = try! rule.validate(storyboard: StoryboardFile(url: strictStoryboardUrl))

        XCTAssertEqual(strictViolations.count, 1)

        let okStoryboardUrl = fixture.path("Resources/Rules/CustomClassNameRule/TestBaseViewController.storyboard")
        let okViolations = try! rule.validate(storyboard: StoryboardFile(url: okStoryboardUrl))

        XCTAssertEqual(okViolations.count, 0)
    }
}
