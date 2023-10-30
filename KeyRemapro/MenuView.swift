import SwiftUI

// メニューバーのアイコンをクリックしたときに出るメニューのView
struct MenuView: View
{
    var body: some View
    {
        VStack
        {
            Button("About KeyRemapro")
            {
                
            }
            
            Divider()
            
            Button("Setting")
            {
                NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
            }
            
            Button("Exit")
            {
                NSApp.terminate(nil)
            }
        }
    }
}

