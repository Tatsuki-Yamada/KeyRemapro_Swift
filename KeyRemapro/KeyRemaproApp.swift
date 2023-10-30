import SwiftUI

// アプリのエントリー
@main
struct KeyRemaproApp: App
{
    @NSApplicationDelegateAdaptor(AppDelegate.self) public var appDelegate
    
    var body: some Scene
    {
        // macOS 13.0以降しか対応していない。
        /*
        MenuBarExtra("Sample", systemImage: "arrow.uturn.down.square")
        {
            MenuView()
        }
         */
                
        Settings
        {
            KeySettingView()
            .padding(20)
            .onAppear()
            {
                NSApplication.shared.windows.first?.makeKeyAndOrderFront(nil)
            }
        }
    }
}
