import flash.external.ExternalInterface;

class FacebookJSBridge {
		
	public static var NS = "FBAS";
		
	public function new() {
		try {
			if (ExternalInterface.available ) {
				ExternalInterface.call ( script_js );
				ExternalInterface.call( "FBAS.setSWFObjectID", ExternalInterface.objectID );
			}
		} catch( error:Dynamic ) { trace(error); }
	}
	
	private static var script_js =
	"function() {
		FBAS = {
			setSWFObjectID: function( swfObjectID ) {
				console.log(swfObjectID);															
				FBAS.swfObjectID = swfObjectID;
			},
			init: function( opts ) {
				console.log(opts);
				FB.init( opts );
				FB.Event.subscribe( 'auth.authResponseChange', function( response ) {
					FBAS.updateSwfAuthResponse( response.authResponse );
				} );
			},
			login: function( opts ) {
				console.log('login: '+opts);
				FB.login (FBAS.handleUserLogin, opts);
			},
			handleUserLogin: function( response ) {
				console.log(response);
				FBAS.updateSwfAuthResponse( response.authResponse );
			},
			logout: function() {
				FB.logout( FBAS.handleUserLogout );
			},
			handleUserLogout: function( response ) {
				swf = FBAS.getSwf();
				swf.logout();
			},
			ui: function( params ) {
				obj = FB.JSON.parse( params );								
				method = obj.method;
				cb = function( response ) { FBAS.getSwf().uiResponse( JSON.stringify( response ), method ); }
				FB.ui( obj, cb );
			},
			getAuthResponse: function() {
				authResponse = FB.getAuthResponse();
				return JSON.stringify( authResponse );
			},
			getLoginStatus: function() {
				console.log('getloginstatus');
				FB.getLoginStatus( function( response ) {
					if( response.authResponse ) {
						FBAS.updateSwfAuthResponse( response.authResponse );
					} else {
						FBAS.updateSwfAuthResponse( null );
					}
				} );
			},
			getSwf: function getSwf() {								
				return document.getElementById( FBAS.swfObjectID );								
			},
			updateSwfAuthResponse: function( response ) {	
				//console.log(JSON.stringify(response));							
				swf = FBAS.getSwf();
				
				if( response == null ) {
					swf.authResponseChange( null );
				} else {
					swf.authResponseChange( JSON.stringify( response ) );
				}
			}
		};
	}";
}