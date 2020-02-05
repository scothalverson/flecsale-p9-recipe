module purge 
module load gcc/8.3.1
module load cmake/3.14.5
#module load spectrum-mpi/rolling-release
module load boost/1.70.0

#find spack
command -v spack >/dev/null 2>&1 || { 
	#if not found, try sourcing the setup file in the expected place and try again
	source ./spack/share/spack/setup-env.sh >/dev/null 2>&1
	command -v spack >/dev/null 2>&1 || { 
		echo >&2 "installing spack..."
		git clone git@github.com:spack/spack.git
		source ./spack/share/spack/setup-env.sh
	}
}
#find llvm
#spack load llvm@develop%gcc@8.3.1

#detect clang, and install it if not found
clang++ --version | grep -q "10.0.0" >/dev/null 2>&1 || { 
	#put the expected path in your PATH variable
	export PATH=$PWD/llvm/install/ppc64le/bin:$PATH
	#then try again, and if still not there, install it
	clang++ --version | grep -q "10.0.0" 2>&1 || { 
		./clangInstall.sh
	}
}

spack compiler find
