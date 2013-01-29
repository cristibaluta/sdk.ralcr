#include <hx/Macros.h>
#include <hx/CFFI.h>
#include <hxcpp.h>

#include "AlertView.h"
#include "WebView.h"
#include "AudioEngine.h"


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
#endif

