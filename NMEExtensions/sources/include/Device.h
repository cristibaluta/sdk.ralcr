#ifndef Device
#define Device

namespace ralcr{
	
    extern bool retina;
	extern bool retinaInit;

	void initDevice();
	const char *uniqueId();
	const char *os();
	const char *vervion();
	const char *deviceName();
	const char *model();
	bool isRetina();
	bool networkAvailable();
	void Vibrate(float milliseconds);
	
	const char * getDocPath();
	const char * getRecPath();
}

#endif
