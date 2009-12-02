/**
 * 
 */
package {
	import jp.progression.casts.*;
	import jp.progression.commands.*;
	import jp.progression.core.commands.Command;
	import jp.progression.events.*;
	import jp.progression.loader.*;
	import jp.progression.*;
	import jp.progression.scenes.*;
	
	/**
	 * MyCommand クラス
	 */
	public class MyCommand extends Command {
		
		/**
		 * コンストラクタ
		 */
		public function MyCommand( initObject:Object = null ) {
			super( _execute, _interrupt, initObject );
		}
		
		
		
		
		
		/**
		 * 実行されるコマンドの実装です。
		 */
		private function _execute():void {
			// 通常処理を終了します。
			executeComplete();
		}
		
		/**
		 * 中断実行されるコマンドの実装です。
		 */
		private function _interrupt():void {
			// 中断処理を終了します。
			interruptComplete();
		}
		
		/**
		 * MyCommand インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。
		 */
		public override function clone():Command {
			return new MyCommand( this );
		}
	}
}









