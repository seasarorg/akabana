package org.seasar.akabana.yui.framework.convention
{
	public class CatalystNamingConvention extends NamingConvention
	{       
		
		protected override function checkClassFullName( className:String, packageName:String, suffix:String ):Boolean{
			if( className.indexOf("components") == 0 ){
				return super.checkClassFullName(className.replace(/components/,_conventions[0]+"."+VIEW),packageName,suffix);
			} else {
				return super.checkClassFullName(className,packageName,suffix);
			}
		}
		
		protected override function checkVarName( varName:String, suffix:String ):Boolean{
			if( varName.indexOf("components") == 0 ){
				return super.checkVarName(varName,suffix);
			} else {
				return super.checkVarName(varName,suffix);
			}
		}
		
		protected override function changeViewPackageTo( className:String, packageName:String, suffix:String ):String{
			if( className.indexOf("components") == 0 ){
				return super.changeViewPackageTo(className.replace(/components/,_conventions[0]+"."+VIEW),packageName,suffix);
			} else {
				return super.changeViewPackageTo(className,packageName,suffix);
			}
		}
	}
}