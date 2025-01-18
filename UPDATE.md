1. バージョン番号を上げてアーカイブビルドする
2. dmg を作る
   ```sh
   ./bin/create_dmg.sh リリースアーカイブした.appのパス
   ```
3. `appcast.xml`を作る
   ```sh
   ./bin/generate_appcast --account com.kyome.ShiftWindow .
   ```
4. `appcast.xml`の`enclosure`タグの`url`を GitHub の Release 添付ファイルリンクに変更
   ```diff xml
   - <enclosure url="https://raw.githubusercontent.com/Kyome22/ShiftWindow/main/Installer.dmg" />
   + <enclosure url="https://github.com/Kyome22/ShiftWindow/releases/download/x.y.z/Installer.dmg" />
   ```
5. タグを打つ
6. GitHub の Release を Publish して`Installer.dmg`をアップロード
