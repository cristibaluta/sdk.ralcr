#ifndef IN_APP_PURCHASE
#define IN_APP_PURCHASE


extern "C"{
	void initInAppPurchase();
	bool canPurchase();
	void purchaseProduct(const char *inProductID);
	void releaseInAppPurchase();
}


#endif


