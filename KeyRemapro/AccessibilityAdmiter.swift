import SwiftUI

/// OSのアクセシビリティでアプリが許可されているかを調べる関数
/// - Returns: 許可->True, 不許可->False
public func CheckAccessivilityAdmit() -> Bool
{
    let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as NSString: true]
    let accessEnabled = AXIsProcessTrustedWithOptions(options)

    // アクセシビリティの許可が取れていなかったとき
    if !accessEnabled
    {
        let alert = NSAlert()
        alert.messageText = "アクセシビリティの許可が必要です"
        alert.informativeText = "環境設定 -> アクセシビリティからこのアプリを許可してください。もし許可しているのにこのダイアログが表示されている場合、一度アクセシビリティから削除して、再度許可してください。"
        alert.addButton(withTitle: "OK")
        alert.runModal()
       
        return false
    }
    
    return true
}
