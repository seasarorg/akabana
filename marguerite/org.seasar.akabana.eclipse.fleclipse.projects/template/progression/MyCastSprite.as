﻿/**
 * 
 */
package {
	import jp.progression.casts.*;
	import jp.progression.commands.*;
	import jp.progression.events.*;
	import jp.progression.loader.*;
	import jp.progression.*;
	import jp.progression.scenes.*;
	
	/**
	 * MyCastSprite クラス
	 */
	public class MyCastSprite extends CastSprite {
		
		/**
		 * コンストラクタ
		 */
		public function MyCastSprite( initObject:Object = null ) {
			super( initObject );
		}
		
		
		
		
		
		/**
		 * ICastObject オブジェクトが AddChild コマンド、または AddChildAt コマンド経由でディスプレイリストに追加された場合に送出されます。
		 * このイベント処理の実行中には、addCommand() メソッド、及び insertCommand() メソッドによるコマンドの同期処理が行えます。
		 */
		protected override function _onCastAdded():void {
			// 実行したいコマンドを登録します。
			addCommand(
				// 任意のコマンドを記述してください。
			);
		}
		
		/**
		 * ICastObject オブジェクトが RemoveChild コマンド、または RemoveAllChild コマンド経由でディスプレイリストから削除された場合に送出されます。
		 * このイベント処理の実行中には、addCommand() メソッド、及び insertCommand() メソッドによるコマンドの同期処理が行えます。
		 */
		protected override function _onCastRemoved():void {
			// 実行したいコマンドを登録します。
			addCommand(
				// 任意のコマンドを記述してください。
			);
		}
	}
}









