import AppKit
import SwiftUI
import Cocoa

// SwiftUIで足りない機能を使うためのAppDelegate
class AppDelegate: NSObject, NSApplicationDelegate
{
    public let _keyboardHooker: KeyboardHooker = KeyboardHooker.shared
    
    var statusItem: NSStatusItem!
    
    // アプリ起動時に呼ばれる関数
    public func applicationDidFinishLaunching(_ aNotification: Notification)
    {
        CreateStatusBarMenu()
        
        if CONSTANTS.IS_SETTING_TEST
        {
            OpenSettingWindow()
            return
        }
        
        // アクセシビリティの許可を取る
        if CheckAccessivilityAdmit() == false
        {
            NSApplication.shared.terminate(self)
        }
        
        // キーボードフックを始める。
        _keyboardHooker.HookStart()
    }
    
    
    private func CreateStatusBarMenu()
    {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.button?.image = NSImage(systemSymbolName: "arrow.uturn.down.square", accessibilityDescription: "Some Apps Status menu")
        
        let menu = NSMenu()
        
        menu.addItem(NSMenuItem.init(title: "About KeyRemapro", action:nil, keyEquivalent: ""))
        menu.addItem(NSMenuItem.init(title: "Settings", action: #selector(OpenSettingWindow), keyEquivalent: ""))
        menu.addItem(NSMenuItem.init(title: "Quit", action: #selector(quit), keyEquivalent: ""))
        
        statusItem.menu = menu
    }
    
    
    @objc private func OpenSettingWindow()
    {
        NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
    }
    
    
    @objc private func quit()
    {
        NSApp.terminate(nil)
    }
}
