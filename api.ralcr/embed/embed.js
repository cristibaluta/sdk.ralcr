// SWFObject embed by Geoff Stearns geoff@deconcept.com http://blog.deconcept.com/
//var scripts_path = scripts_path==null ? "scripts_path/" : scripts_path;

alert (scripts_path);
document.write('<script src="'+scripts_path+'js/swfobject.js"><\/script>');
document.write('<script src="scripts_ralcr/js/flash_resize.js"><\/script>');
document.write('<script src="scripts_ralcr/js/swfmacmousewheel2.js"><\/script>');
document.write('<script src="scripts_ralcr/js/swfaddress.js"><\/script>');
document.write('<script src="scripts_ralcr/js/swfaddress-optimizer.js?flash=9"><\/script>');

function embed (swf, instance, w, h, color) {
	
	var flashvars = { id:instance, scripts_path:scripts_path, photos_path:photos_path };
	var params = { allowFullScreen:'true', allowNetworking:'all', allowScriptAccess:'always', bgcolor:color };
	var attributes = { id:instance, name:instance };
	
	swfobject.embedSWF (swf+"?"+Math.random()*1, instance, w, h, "9.0.0", "scripts_ralcr/embed/expressInstall.swf",
						flashvars, params, attributes);
	swfmacmousewheel.registerObject (instance);
}
