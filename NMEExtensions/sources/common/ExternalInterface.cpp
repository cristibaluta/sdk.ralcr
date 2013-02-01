#include <hx/Macros.h>
#include <hx/CFFI.h>
#include <hxcpp.h>

#include "AlertView.h"
#include "WebView.h"
#include "AudioEngine.h"
#include "Https.h"


using namespace ralcr;

#ifdef HX_WINDOWS
typedef wchar_t OSChar;
#define val_os_string val_wstring
#else
typedef char OSChar;
#define val_os_string val_string
#endif

// AutoGCRoot *eventHandle = 0;


extern "C" void nme_extensions_main(){
	printf("nme_extensions_main()\n");
}
DEFINE_ENTRY_POINT(nme_extensions_main);

extern "C" int ralcr_register_prims(){
	printf("ralcr: register_prims()\n");
	nme_extensions_main();
	return 0;
}


// AlertView

#ifdef IPHONE
value ralcr_show_alert_view (value title, value description){
	show_alert_view (val_string(title), val_string(description));
	return alloc_null();
}
DEFINE_PRIM (ralcr_show_alert_view, 2);
#endif



// WebView

#ifdef IPHONE
value ralcr_show_web_view (value x, value y, value w, value h, value url) {
	show_web_view ( val_int(x), val_int(y), val_int(w), val_int(h), val_string(url) );
	return alloc_null();
}
DEFINE_PRIM (ralcr_show_web_view, 5);

value ralcr_hide_web_view(){
	hide_web_view();
	return alloc_null();
}
DEFINE_PRIM (ralcr_hide_web_view, 0);
#endif



// CocosDenshion

#ifdef IPHONE
value ralcr_preload_background_music (value filePath) {
	preload_background_music ( val_string(filePath) );
	return alloc_null();
}
DEFINE_PRIM (ralcr_preload_background_music, 1);
value ralcr_play_background_music (value filePath, value loop) {
	play_background_music ( val_string(filePath), val_bool(loop) );
	return alloc_null();
}
DEFINE_PRIM (ralcr_play_background_music, 2);
value ralcr_stop_background_music () { stop_background_music(); return alloc_null(); }
DEFINE_PRIM (ralcr_stop_background_music, 0);
value ralcr_pause_background_music () { pause_background_music(); return alloc_null(); }
DEFINE_PRIM (ralcr_pause_background_music, 0);
value ralcr_resume_background_music () { resume_background_music(); return alloc_null(); }
DEFINE_PRIM (ralcr_resume_background_music, 0);
value ralcr_rewind_background_music () { rewind_background_music(); return alloc_null(); }
DEFINE_PRIM (ralcr_rewind_background_music, 0);
value ralcr_is_background_music_playing () { return alloc_bool ( is_background_music_playing() ); }
DEFINE_PRIM (ralcr_is_background_music_playing, 0);
value ralcr_play_effect (value filePath, value loop) {
	return alloc_int ( play_effect ( val_string(filePath), val_bool(loop) ));
}
DEFINE_PRIM (ralcr_play_effect, 2);
value ralcr_stop_effect (value soundId) {
	stop_effect ( val_int(soundId) );
	return alloc_null();
}
DEFINE_PRIM (ralcr_stop_effect, 1);
value ralcr_preload_effect (value filePath) {
	preload_effect ( val_string(filePath) );
	return alloc_null();
}
DEFINE_PRIM (ralcr_preload_effect, 1);
value ralcr_unload_effect (value filePath) {
	unload_effect ( val_string(filePath) );
	return alloc_null();
}
DEFINE_PRIM (ralcr_unload_effect, 1);
#endif



// Https

#ifdef IPHONE
value ralcr_https_post (value url, value vars) { https_post ( val_string(url), val_string(vars) ); return alloc_null(); }
DEFINE_PRIM (ralcr_https_post, 2);
value ralcr_https_get (value url, value vars) { https_get ( val_string(url), val_string(vars) ); return alloc_null(); }
DEFINE_PRIM (ralcr_https_get, 2);
value ralcr_https_cancel () { https_cancel(); }
DEFINE_PRIM (ralcr_https_cancel, 0);
#endif
