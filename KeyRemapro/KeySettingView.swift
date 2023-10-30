import SwiftUI

// 設定画面のView
struct KeySettingView: View
{
    // 各Pickerが選択している対象を示すSelector
    @State private var _selections_spectialKey: [String] = []
    @State private var _selections_inputKey: [String] = []
    @State private var _selections_outputKey: [String] = []


    var body: some View
    {
        ScrollView(.vertical)
        {
            // 設定を並べる
            VStack
            {
                ForEach(0 ..< _selections_spectialKey.count, id: \.self) { i in
                    HStack
                    {
                        // 修飾キーの選択リスト
                        Picker("", selection: $_selections_spectialKey[i]){
                            ForEach(KeyCodes_Function.keys, id:\.self) {
                                Text($0)
                            }
                        }
                        .frame(width: 250)
                        
                        Image(systemName: "plus")
                        
                                                
                        // 変換元キーの選択リスト
                        Picker("", selection: $_selections_inputKey[i]){
                            ForEach(KeyCodes_Normal.keys, id:\.self){
                                Text($0)
                            }
                        }
                        .frame(width: 150)
                        
                        Image(systemName: "arrow.right")
                        
                        // 変換先キーの選択リスト
                        Picker("", selection: $_selections_outputKey[i]){
                            ForEach(KeyCodes_Normal.keys, id:\.self){
                                Text($0)
                            }
                        }
                        .frame(width: 150)
                        
                        // 設定の削除ボタン
                        Button(action: {
                            _selections_spectialKey.remove(at: i)
                            _selections_inputKey.remove(at: i)
                            _selections_outputKey.remove(at: i)
                        }, label: {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        })
                        .padding(10)
                    }
                    
                }
                
                // 設定の追加ボタン
                Button(action: {
                    _selections_spectialKey.append(KeyCodes_Function.keys[0])
                    _selections_inputKey.append(KeyCodes_Normal.keys[0])
                    _selections_outputKey.append(KeyCodes_Normal.keys[0])
                }, label: {
                    Image(systemName: "plus.circle")
                        .foregroundColor(.blue)
                })
                
//                Spacer()
                
                
            }
            .onAppear
            {
                NSApplication.shared.activate(ignoringOtherApps: true)

                LoadSettings()
            }
        }
        .padding(10)
        
        // Ok, 適用, キャンセルボタン
        HStack
        {
            Button(action: {
                NSApplication.shared.keyWindow?.close()
                LoadSettings()
            }, label: {
                Text("Cancel")
                    .foregroundColor(.red)
            })
            
            Spacer()
            
            Button("Apply")
            {
                ApplySettings()
            }
            
            // macOS 12.0以降しか使用不可のため、切り分ける（.borderdProminent）
            if #available(macOS 12.0, *)
            {
                Button("OK")
                {
                    ApplySettings()
                    NSApplication.shared.keyWindow?.close()
                }
                .buttonStyle(.borderedProminent)
            }
            else
            {
                Button(action: {
                    ApplySettings()
                    NSApplication.shared.keyWindow?.close()
                }, label: {
                    Text("OK")
                        .foregroundColor(.blue)
                })
            }
        }
    }
    
    
    private func LoadSettings()
    {
        _selections_spectialKey = []
       _selections_inputKey = []
        _selections_outputKey = []
        
        
        var savedSettings: [[Int]] = []
        
        if UserDefaults.standard.array(forKey: "KeyBindSettings") != nil
        {
            savedSettings = UserDefaults.standard.array(forKey: "KeyBindSettings") as! [[Int]]
        }
        
        print(savedSettings)
        
        for i in 0..<savedSettings.count
        {
            _selections_spectialKey.append(KeyCodes_Function.first(where: {$1 == savedSettings[i][0]})!.key)
            _selections_inputKey.append(KeyCodes_Normal.first(where: {$1 == savedSettings[i][1]})!.key)
            _selections_outputKey.append(KeyCodes_Normal.first(where: {$1 == savedSettings[i][2]})!.key)
        }
    }
    
    
    private func ApplySettings()
    {
        var settings_toReplace: [[Int]] = []
        
        for i in 0 ..< _selections_spectialKey.count
        {
            var oneSet: [Int] = []
            oneSet.append(KeyCodes_Function[_selections_spectialKey[i]]!)
            oneSet.append(KeyCodes_Normal[_selections_inputKey[i]]!)
            oneSet.append(KeyCodes_Normal[_selections_outputKey[i]]!)
            settings_toReplace.append(oneSet)
        }
                
        KeyboardHooker.shared.keybindSettings = settings_toReplace
        
        UserDefaults.standard.set(settings_toReplace, forKey: "KeyBindSettings")
    }
}
