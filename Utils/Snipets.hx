//
//  Snipets
//
//  Created by Cristi Baluta on 2010-04-19.
//  Copyright (c) 2010 ralcr.com. All rights reserved.
//
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.Error;


class Snipets {
	
	// http://haxe.org/doc/snip/commaformat
	public static inline function commaFormat( num:Float ): String
	    var str:String = Std.string(num);
	        var str_ar:Array<String> = new Array<String>();
	        var pos:Int = 1;
	        var i:Int;
	        var out:String = "";
			
	        if (str.indexOf(".") == -1 ){
	            str_ar = str.split("");
	        }else{
	            out = str.substr(str.indexOf("."));
	            str_ar = str.substr(0, str.indexOf(".")).split("");
	        }
			
	        str_ar.reverse();
	        for (i in 0...str_ar.length){
	            out = str_ar[i]+out;
	            if (pos++ == 3) {
	                pos = 1;
	                out = ((Math.isNaN(Std.parseFloat(str_ar[0])) && i > 1) || (!Math.isNaN(Std.parseFloat(str_ar[0])) && i >= 1) && i < str_ar.length-1) ? ","+out : out;
	            }
	        }
	        return out;
	}
	
	
	// http://haxe.org/doc/snip/deeptrace
	// deepTrace(myObject,["x","y"]);
	// will trace something like
	public static function deepTrace( obj:DisplayObject, ?fields:Array<String>, level:Int = 0 ):Void
	{
	    var tabs:String = "";
	    var i:Int = 0;
	    var l:Int = level;
	    for ( i in 0...l){
	        tabs += "\t";
	    }

	    var printData = function(newField, fieldString)
	    {
	        return fieldString + (fieldString != "" ? "; " : "") +newField+ " : " +Reflect.field(obj, newField);
	    }
	    if(fields != null && fields.length > 0){
	        try{
	            trace(tabs + obj + " -> ( " + Lambda.fold(fields, printData, "") + " )");
	        }catch(e:Error){
	            trace(tabs + obj + " -> ( has no fields ["+fields+"] )");
	        }
	    }

	    if(Std.is(obj,DisplayObjectContainer)){
	        for ( i in 0...Reflect.field(obj, "numChildren") ){
	            deepTrace( Reflect.field(obj, "getChildAt")(i), fields, level + 1 );
	        }
	    }
	}
	
	
	public function isValidEmail( email : String ) : Bool
	{
	    var emailExpression : EReg = ~/^[\w-\.]{2,}@[ÅÄÖåäö\w-\.]{2,}\.[a-z]{2,6}$/i;
	    return emailExpression.match( email );
	}
}