

#ifndef ISR_H_
#define ISR_H_


#define RESET_TIMEOUT_COUNTER	10000

void s2mm_isr(void* CallbackRef);
void mm2s_isr(void* CallbackRef);

#endif
