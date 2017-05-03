# distutils: language = c++
# distutils: extra_compile_args = -std=c++11
# distutils: include_dirs = ../FM-Index ../openbwt-v1.5
# distutils: sources = ../FM-Index/FMIndex.cpp ../FM-Index/WaveletTree.cpp ../FM-Index/BitVector.cpp ../openbwt-v1.5/BWT.c

from libcpp cimport bool
from libcpp.vector cimport vector
from libcpp.string cimport string


cdef extern from "FMIndex.h":

    cdef cppclass FMIndex:
        FMIndex(string, bool) except +
        int findn(string)
        vector[string] find_lines(string, char, size_t)
        void serialize_to_file(string)
        size_t size()
        @staticmethod
        FMIndex * new_from_serialized_file(string)


cdef class PyFMIndex:
    cdef FMIndex * thisptr
    def __cinit__(self, s, bool build_reverse=True):
        self.thisptr = new FMIndex(s, build_reverse)
    def __dealloc__(self):
        del self.thisptr
    def findn(self, pattern):
        return self.thisptr.findn(pattern)
    def find_lines(self, pattern, newline=ord('\n'), max_context=100):
        return self.thisptr.find_lines(pattern, newline, max_context)
    def new_from_serialized_file(self, filename):
        del self.thisptr
        self.thisptr = FMIndex.new_from_serialized_file(filename)
    def serialize_to_file(self, filename):
        self.thisptr.serialize_to_file(filename)
    def size(self):
        return self.thisptr.size()
