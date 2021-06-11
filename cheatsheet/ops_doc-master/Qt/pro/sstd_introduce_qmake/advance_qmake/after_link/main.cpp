
#include <advance_qmake.hpp>

int main(int, char ** argv) {
    fs::path varOutPath{ argv[1] };
    std::ofstream varOutStream{ streamFileName(varOutPath/"after_link.txt"sv) };
    varOutStream << getNow() << std::endl;
}
