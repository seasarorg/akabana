package examples.chura.web {
	
	[Bindable]
	public class AppMode {
		
		public static var NEUTRAL: int = 0;
		public static var NEW: int = 1;
		public static var COR: int = 2;
		
		public static function toString(type: int): String {
			
			var result: String = "";
			
			switch(type) {
				case NEUTRAL:
					result = "NEUTRAL";
					break;
				case NEW:
					result = "NEW";
					break;
				case COR:
					result = "COR";
					break;
				default:
					break;
			}
			return result;
		}
	}
}