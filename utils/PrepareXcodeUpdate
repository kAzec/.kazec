#!/usr/bin/env swift

import AppKit

let isBeta = CommandLine.arguments.contains("-b")
let isForce = CommandLine.arguments.contains("-f")
var xcodePath = "/Applications/\(isBeta ? "Xcode-beta" : "Xcode").app"

if let customPathOptIdx = CommandLine.arguments.firstIndex(of: "-p"), customPathOptIdx + 1 < CommandLine.arguments.count {
    xcodePath = CommandLine.arguments[customPathOptIdx + 1]
}


do {
    try injectKeyBindingSet()
} catch {
    print("Operation failed: \(error)")
}

func injectKeyBindingSet() throws {
    let plistURL = URL(fileURLWithPath: "\(xcodePath)/Contents/Frameworks/IDEKit.framework/Resources/IDETextKeyBindingSet.plist")
    print("Injecting <Custom> section to \(plistURL)")

    if
        var plistDict = try PropertyListSerialization.propertyList(
            from: Data(contentsOf: plistURL), options: [], format: nil
        ) as? [String : Any]
    {
        let customDict = try PropertyListSerialization.propertyList(from: Constants.customPlistData, options: [], format: nil) as! [String: Any]

        if let oldValue = plistDict.updateValue(customDict, forKey: "Custom") {
            if (!isForce) {
                print("<Custom> section already defined.\n\(oldValue)\nSkipping...")
                return
            }

            print("<Custom> section already defined.\n\(oldValue)\nForce overwriting...")
        }

        print("Injecting <Custom> section:\n\(customDict)...")
        try PropertyListSerialization.data(fromPropertyList: plistDict, format: .xml, options: 0).write(to: plistURL)
    }

    print("Done")
}

enum Constants {
    static let customPlistData = """
    <dict>
        <key>Insert New Line Below</key>
        <string>moveToEndOfParagraph:, insertNewline:</string>
        <key>Insert New Line Above</key>
        <string>moveToBeginningOfParagraph:, insertNewline:, moveUp:</string>
        <key>Duplicate Line</key>
        <string>moveToBeginningOfParagraphAndModifySelection:, moveToEndOfParagraphAndModifySelection:, moveForwardAndModifySelection:, copy:, moveRight:, pasteAsPlainText:, moveUp:, moveToEndOfParagraph:</string>
        <key>Cut Line</key>
        <string>moveToBeginningOfParagraphAndModifySelection:, moveToEndOfParagraphAndModifySelection:, moveForwardAndModifySelection:, cut:</string>
        <key>Copy Line</key>
        <string>moveToBeginningOfParagraphAndModifySelection:, moveToEndOfParagraphAndModifySelection:, moveForwardAndModifySelection:, copy:</string>
        <key>Move Up By 10 Lines</key>
        <string>moveUp:, moveUp:, moveUp:, moveUp:, moveUp:, moveUp:, moveUp:, moveUp:, moveUp:, moveUp:</string>
        <key>Move Down By 10 Lines</key>
        <string>moveDown:, moveDown:, moveDown:, moveDown:, moveDown:, moveDown:, moveDown:, moveDown:, moveDown:, moveDown:</string>
        <key>Move Up By 10 Lines Extending Selection</key>
        <string>moveUpAndModifySelection:, moveUpAndModifySelection:, moveUpAndModifySelection:, moveUpAndModifySelection:, moveUpAndModifySelection:, moveUpAndModifySelection:, moveUpAndModifySelection:, moveUpAndModifySelection:, moveUpAndModifySelection:, moveUpAndModifySelection:</string>
        <key>Move Down By 10 Lines Extending Selection</key>
        <string>moveDownAndModifySelection:, moveDownAndModifySelection:, moveDownAndModifySelection:, moveDownAndModifySelection:, moveDownAndModifySelection:, moveDownAndModifySelection:, moveDownAndModifySelection:, moveDownAndModifySelection:, moveDownAndModifySelection:, moveDownAndModifySelection:</string>
        <key>Move Up By 5 Lines</key>
        <string>moveUp:, moveUp:, moveUp:, moveUp:, moveUp:</string>
        <key>Move Down By 5 Lines</key>
        <string>moveDown:, moveDown:, moveDown:, moveDown:, moveDown:</string>
        <key>Move Up By 5 Lines Extending Selection</key>
        <string>moveUpAndModifySelection:, moveUpAndModifySelection:, moveUpAndModifySelection:, moveUpAndModifySelection:, moveUpAndModifySelection:</string>
        <key>Move Down By 5 Lines Extending Selection</key>
        <string>moveDownAndModifySelection:, moveDownAndModifySelection:, moveDownAndModifySelection:, moveDownAndModifySelection:, moveDownAndModifySelection:</string>
    </dict>
    """.data(using: .utf8)!
}
