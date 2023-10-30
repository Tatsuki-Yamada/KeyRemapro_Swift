import SwiftUI

// キー入力を見て変換するSingletonクラス
final public class KeyboardHooker: NSObject
{
    // Singletonインスタンス
    public static let shared = KeyboardHooker()
    
    private var runLoopSource: CFRunLoopSource?
    
    // 設定したショートカットが入る配列
    public var keybindSettings: [[Int]] = []
    
    
    // Singleton化のためにイニシャライザをprivate化する
    override private init()
    {
        super.init()
        
        // 設定が既にあればロードする。
        if (UserDefaults.standard.array(forKey: "KeyBindSettings") != nil)
        {
            keybindSettings = UserDefaults.standard.array(forKey: "KeyBindSettings") as! [[Int]]
        }
    }
    
    
    // OSのイベント？にキーボードフックを登録する。
    public func HookStart()
    {
        let eventTap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: CGEventMask((1 << CGEventType.keyDown.rawValue) | (1 << CGEventType.flagsChanged.rawValue)),
            callback: { (proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? in
                if [.keyDown, .flagsChanged].contains(type)
                {
                    let inputKeyCode = event.getIntegerValueField(.keyboardEventKeycode)
                    let inputFlags = event.flags.rawValue
                    var outputKeyCode: Int64 = inputKeyCode
                    
                    let keyboardhookInstance = KeyboardHooker.shared
                                        
                    // 設定リストから一致するものがあるかチェック
                    for i in 0 ..< keyboardhookInstance.keybindSettings.count
                    {
                        if (inputFlags == keyboardhookInstance.keybindSettings[i][0] && inputKeyCode == keyboardhookInstance.keybindSettings[i][1])
                        {
                            outputKeyCode = Int64(keyboardhookInstance.keybindSettings[i][2])
                            
                            // 各フラグの除去 TODO.フラグの除去をきれいに書く
                            switch (inputFlags)
                            {
                                // Command
                            case 1048840:
                                event.flags.remove(.maskCommand)
                                break
                                // Command + Option
                            case 1573160:
                                event.flags.remove(.maskCommand)
                                event.flags.remove(.maskAlternate)
                                break
                                // Command + Control
                            case 1310985:
                                event.flags.remove(.maskCommand)
                                event.flags.remove(.maskControl)
                                break
                                // Command + Option + Control
                            case 1835305:
                                event.flags.remove(.maskCommand)
                                event.flags.remove(.maskAlternate)
                                event.flags.remove(.maskControl)
                                break
                                // Option
                            case 524576:
                                event.flags.remove(.maskAlternate)
                                break
                                // Option + Control
                            case 786721:
                                event.flags.remove(.maskAlternate)
                                event.flags.remove(.maskControl)
                                break
                                // Control
                            case 262401:
                                event.flags.remove(.maskControl)
                                break
                                /*
                                // 修飾キーを押していない状態それぞれ
                            case 256:
                                fallthrough
                            case 8388864:
                                break
                                */
                            default:
                                break
                            }
                        }
                    }
                    
                    //print("keyCode: \(inputKeyCode), flags: \(inputFlags)")
                                        
                    event.setIntegerValueField(.keyboardEventKeycode, value: outputKeyCode)
                }
                return Unmanaged.passRetained(event)
            },
            userInfo: nil
        )
        
        runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: eventTap!, enable: true)
    }
    
    // 動いていない
    public func HookStop()
    {
        guard let runLoopSource = runLoopSource else { return }
        CFRunLoopSourceInvalidate(runLoopSource)
        CFRunLoopRemoveSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        self.runLoopSource = nil
    }
}

