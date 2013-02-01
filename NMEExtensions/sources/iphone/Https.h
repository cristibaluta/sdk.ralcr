#ifndef Https
#define Https

namespace ralcr {
	
	void https_get (const char *url, const char *variables);
	void https_post (const char *url, const char *variables);
	// void https_delete (const char *url, const char *variables);
	void https_cancel();
}

#endif
