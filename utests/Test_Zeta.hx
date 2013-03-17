//
//  Test_Zeta
//
//  Copyright (c) 2013 ralcr.com. All rights reserved.
//

class Test_Zeta extends haxe.unit.TestCase {
    
    public function testConcatObjects(){
		
		var obj1 = { a1 : "1", a2 : "2" };
		var obj2 = { a3 : "3", a4 : "4" };
		var obj = Zeta.contactObjects ( [obj1, obj2] );
		
		assertTrue (obj.a1 == "1" && obj.a2 == "2" && obj.a3 == "3" && obj.a4 == "4");
    }
}
