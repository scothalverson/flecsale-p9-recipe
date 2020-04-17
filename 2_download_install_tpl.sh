module load cuda/10.1.243
module load gcc/8.3.1

mpistring=mpich
#mpistring=openmpi@4.0.2 thread_multiple=True
#gasnet 
#wget https://gasnet.lbl.gov/download/GASNet-1.32.0.tar.gz
spack install gasnet@1.32.0%gcc@8.3.1 ^$mpistring 
#legion 
#git clone git@gitlab.com:StanfordLegion/legion.git

#hdf5
spack install hdf5@1.10.6%gcc@8.3.1 hl=True ^$mpistring
#netcdf
spack install netcdf-cxx%gcc@8.3.1 ^$mpistring

#parmetis, metis
spack install parmetis%gcc@8.3.1 ^$mpistring

#exodus via seacas
spack install seacas cgns=False ^$mpistring 
#spack load -r parmetis - not working as expected on rzansel?

#`spack module tcl loads | grep "load parmetis"`
#`spack module tcl loads | grep "load metis"`
#`spack module tcl loads | grep "load hdf5"`
#`spack module tcl loads | grep "load netcdf-c-"`
#`spack module tcl loads | grep "load netcdf-cxx"`
#`spack module tcl loads | grep "load openmpi-4.0.2-gcc"
#`spack module tcl loads | grep "load mpich"`
#`spack module tcl loads | grep "load gasnet-1.32.0-gcc"`
#`spack module tcl loads | grep "seacas"`


spack load -r gasnet@1.32.0%gcc@8.3.1 ^$mpistring 
spack load -r hdf5@1.10.6%gcc@8.3.1 hl=True ^$mpistring
spack load -r netcdf-cxx%gcc@8.3.1 ^$mpistring
spack load -r parmetis%gcc@8.3.1 ^$mpistring
spack load -r seacas cgns=False ^$mpistring 


#if we're rerunning this script, we don't want to depend on anything that might already be in the install dir
rm -rf install

curdir=`pwd`
#exodus
#rm -rf exodus-6.09*
#wget https://github.com/laristra/flecsi-third-party/raw/master/files/exodus-6.09.tar.gz
#tar -xvf exodus-6.09.tar.gz
#cd exodus-6.09/exodus/
#mkdir build
#cd build
#cmake .. \
#	-DCMAKE_INSTALL_PREFIX:PATH=$curdir/install \
#	-DPYTHON_INSTALL=$curdir/install \
#	-DCMAKE_CXX_COMPILER=clang++ \
#	-DCMAKE_C_COMPILER=clang 
#make 
#make install

#cd ../../../

#kokkos
rm -rf kokkos
git clone git@github.com:kokkos/kokkos.git
cd kokkos
git fetch origin
git checkout develop
mkdir build
cd build
cmake .. \
	-DCMAKE_CXX_COMPILER=clang++ \
	-DCMAKE_CXX_FLAGS="$CMAKE_CXX_FLAGS -fPIC" \
	-DCMAKE_C_COMPILER=clang \
	-DCMAKE_INSTALL_PREFIX=$curdir/install/ \
	-DKokkos_ARCH_POWER9:BOOL=ON \
	-DKokkos_ARCH_VOLTA70:BOOL=ON \
	-DKokkos_ENABLE_CUDA:BOOL=ON \
	-DKokkos_ENABLE_CUDA_CONSTEXPR=ON \
	-DKokkos_ENABLE_CUDA_LAMBDA=ON 

make -j
make install

cd ../../


#legion
export CMAKE_PREFIX_PATH=$CMAKE_PREFIX_PATH:$curdir/install/
echo $CMAKE_PREFIX_PATH
rm -rf legion
git clone git@gitlab.com:StanfordLegion/legion.git
cd legion
#git fetch origin
#git checkout kokkos
git checkout control_replication
sed -i 's/-march/-mcpu/g' CMakeLists.txt
mkdir build
cd build

cmake .. \
	-DCMAKE_CXX_COMPILER=clang++ \
	-DCMAKE_C_COMPILER=clang \
	-DCMAKE_INSTALL_PREFIX=$curdir/install/ \
	-DBUILD_SHARED_LIBS=ON \
	-DCUDA_HOST_COMPILER=`which g++` \
	-DLegion_USE_CUDA=ON \
	-DLegion_USE_Kokkos=ON \
	-DLegion_USE_GASNet=ON

make -j
make install

