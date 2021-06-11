#include <iostream>
#include <valarray>

class Matrix {
    std::valarray<int> data;
    int dim;
 public:
    Matrix(int r, int c) : data(r * c), dim(c) {}
    int& operator()(int r, int c) { 
		std::cout << "col * row: " << r * dim + c << std::endl;
		return data[r*dim + c];
	}
    int trace() const {
        return data[std::slice(0, dim, dim+1)].sum(); // data[0, 4, 8]
    }
};

int 
main(int argc, char** argv)
{
    Matrix m(3,3);
    int n = 0;
    for(int r=0; r<3; ++r)
		for(int c=0; c<3; ++c) {
			m(r, c) = ++n;
			std::cout << "m: " << m(r, c) << std::endl;
		}

    std::cout << "Trace of the matrix (1,2,3) (4,5,6) (7,8,9) is " << m.trace() << '\n';
}
