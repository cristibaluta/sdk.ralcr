//
//  TestCases
//
//  Created by Baluta Cristian on 2011-12-12.
//  Copyright (c) 2011 ralcr.com. All rights reserved.
//

class Tests {
	
	static function main(){
		var r = new haxe.unit.TestRunner();
		
		// Animation
			r.add( new Test_Transitions() );
			
		// Foundation
			r.add( new Test_OrderedMap() );
			r.add( new Test_Assets() );
			r.add( new Test_DateTools() );
			r.add( new Test_StringTools() );
			r.add( new Test_Math() );
			r.add( new Test_Rect() );
			r.add( new Test_UserDefaults() );
			r.add( new Test_Zeta() );
			
		// Utils
			r.add( new Test_Tea() );
			r.add( new Test_ReversedIntIter() );
			r.add( new Test_Evaluate() );
			r.add( new Test_Csv() );
			r.run();
	}
}
