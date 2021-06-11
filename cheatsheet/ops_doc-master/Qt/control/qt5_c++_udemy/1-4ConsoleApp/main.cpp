#include <iostream>
#include <cstdlib>

using namespace std;

int main()
{
    int secretNumber{}, guessNumber{};
    srand(time(NULL));
    secretNumber = rand() % 100 + 1;

    cout << "Welcome to 'Guess the number' game!" << std::endl;
    cout << "Please choose your number (0-100)." << std::endl;

    do {
        cin >> guessNumber;
        if(guessNumber > secretNumber)
            cout << "Too big!" << std::endl;
        else if (guessNumber < secretNumber)
            cout << "Too small!" << std::endl;
    } while(guessNumber != secretNumber);

    cout << "Congrats! You won!" << std::endl;

    return 0;
}
