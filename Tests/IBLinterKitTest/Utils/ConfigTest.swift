import IBLinterKit
import XCTest

class ConfigTest: XCTestCase {

    let fixture = Fixture()

    func testConfigFile() throws {
        let url = fixture.path("Resources/Config/.iblinter.yml")
        let workingDirectory = url.deletingLastPathComponent()
        let config = try Config(directoryURL: workingDirectory)
        XCTAssertEqual(config.disabledRules, ["custom_class_name"])
        XCTAssertEqual(config.enabledRules, ["relative_to_margin"])
        XCTAssertEqual(config.excluded, ["Carthage"])
        XCTAssertEqual(config.reporter, "json")
    }

    func testNullableConfigFile() throws {
        let url = fixture.path("Resources/Config/.iblinter_nullable.yml")
        let workingDirectory = url.deletingLastPathComponent()
        let config = try Config(directoryURL: workingDirectory, fileName: url.lastPathComponent)
        XCTAssertEqual(config.disabledRules, ["custom_class_name"])
        XCTAssertEqual(config.enabledRules, [])
        XCTAssertEqual(config.excluded, ["Carthage"])
    }

    func testViewAsDeviceConfigFile() throws {
        let url = fixture.path("Resources/Config/.iblinter_view_as_device.yml")
        let workingDirectory = url.deletingLastPathComponent()
        let config = try Config(directoryURL: workingDirectory, fileName: url.lastPathComponent)
        XCTAssertNotNil(config.viewAsDeviceRule)
        XCTAssertEqual(config.viewAsDeviceRule?.deviceId, "retina3_5")
    }

    func testCustomClassNameConfigFile() throws {
        let url = fixture.path("Resources/Config/.iblinter_custom_class.yml")
        let workingDirectory = url.deletingLastPathComponent()
        let config = try Config(directoryURL: workingDirectory, fileName: url.lastPathComponent)
        XCTAssertEqual(config.customClassRule.count, 1)
        XCTAssertEqual(config.customClassRule.first?.elementClass, "UIViewController")
        XCTAssertEqual(config.customClassRule.first?.suffix, "ViewController")
    }
}
