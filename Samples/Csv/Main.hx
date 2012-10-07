import flash.display.MovieClip;


class Main extends MovieClip {
	
	inline static var SOURCE = 
"psmith01,CLASS2B,Peter Smith 1,YEAR2,1,N,ADVANCED,STAFF,1,Y,Y
smehta,CLASS3G,Smeeta Mehta,LOCAL,1,Y,STANDARD,PUPIL,2.1,N,Y
mrsjohns,SNHOJ,Mrs R Johns,UNRESTRICTED,-1,Y,ADVANCED,STAFF,2,Y,N
psmith02,CLASS4D,Peter Smith 2, UKSCHOOLS,0,N,ADVANCED,STAFF,10,Y,Y
scohen,CLASS3G,Saul Cohen,LOCAL,2,Y,STANDARD,PUPIL,1,N,N
swright,CLASS1J,Shaun Wright,YEAR1,1,N,STANDARD,PUPIL,1,N,Y
amarkov,CLASS4E,Anya Markov,UKSCHOOLS,3,Y,STANDARD,PUPIL,1,N,N";
	
	public static function main () {
		haxe.Firebug.redirectTraces();
		RCWindow.init();
		RCWindow.addChild ( new Main() );
	}
	
	
	public function new () {
		super();
		
		var csv = new Csv();
			csv.initWithCsv ( SOURCE );
		trace (csv.getArray());
		trace(csv[0]);
	}
}
