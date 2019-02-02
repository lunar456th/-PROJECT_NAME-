int main(void)
{
	register unsigned int a;
	*(volatile unsigned int *)0x0 = 0x1;
	*(volatile unsigned int *)0x1 = 0x2;
	*(volatile unsigned int *)0x2 = 0x3;
	*(volatile unsigned int *)0x3 = 0x4;
	*(volatile unsigned int *)0x4 = 0x5;
	*(volatile unsigned int *)0x5 = 0x6;
	*(volatile unsigned int *)0x6 = 0x7;
	*(volatile unsigned int *)0x7 = 0x8;
	a = *(volatile unsigned int *)0x0;
	a = *(volatile unsigned int *)0x1;
	a = *(volatile unsigned int *)0x2;
	a = *(volatile unsigned int *)0x3;
	a = *(volatile unsigned int *)0x4;
	a = *(volatile unsigned int *)0x5;
	a = *(volatile unsigned int *)0x6;
	a = *(volatile unsigned int *)0x7;
	return 0;
}
