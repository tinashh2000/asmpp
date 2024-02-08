class myclass {
	public: int a,b;
	int sub() {
		return 1235;
	}
};
int subr(int,int,int);

int mm() {
	__asm("nop\nnop");
	int z=5;
	myclass cls;
	cls.a=0;
	cls.sub();
}

int main() {
	mm();
	subr(10,20,30);
}