// Matthew Rutigliano
// ECEGR 2220 Microprocessor Design
// Lab 3 C++ Prototype

#include <iostream>
using namespace std;

int main()
{
	int start, end, sum;
	cout << "Start value?" << endl;
	cin >> start;
	cout << endl << "End value?" << endl;
	cin >> end;
	
	for (int i=start; i < end+1; i++)
	{
		sum = sum + i;
	}
	cout << "Sum value: " << sum << endl;
	cout << "Press return to end program" << endl;
	cin >> end;
	
	return 0;
}