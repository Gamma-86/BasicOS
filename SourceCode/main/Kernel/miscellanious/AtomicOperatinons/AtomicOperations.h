void Mutex_Lock(unsigned char* LockingBool);
unsigned char Mutex_Lock_Watchdog(unsigned char* LockingBool, unsigned int WatchdogTime);
void Mutex_Unlock(unsigned char* LockingBool);

//Mutex_Unlock