#set -x
rm -rf flecsale
git clone --recursive git@github.com:scothalverson/flecsale.git

installdir=`pwd`/install

#probably not the best way to do this, but this means we don't have to depend on submodules being syncronized correctly
cd flecsale
rm -rf flecsi
rm -rf specializations
rm -rf ristra

git clone git@github.com:scothalverson/flecsi.git
git clone git@github.com:scothalverson/flecsi-sp.git
git clone git@github.com:scothalverson/libristra.git

mv flecsi-sp specializations
mv libristra ristra

rm -rf build
mkdir build
cd build

#again, spack on rzansel wasn't properly handling spack load -r...
#`spack module tcl loads | grep "load parmetis"`
#`spack module tcl loads | grep "load metis"`
#`spack module tcl loads | grep "load hdf5"`
#`spack module tcl loads | grep "load netcdf-c-"`
#`spack module tcl loads | grep "load netcdf-cxx"`
#`spack module tcl loads | grep "load openmpi-4.0.2-gcc"`

mpistring=mpich

spack load -r gasnet@1.32.0%gcc@8.3.1 ^$mpistring 
spack load -r hdf5@1.10.6%gcc@8.3.1 hl=True ^$mpistring
spack load -r netcdf-cxx%gcc@8.3.1 ^$mpistring
spack load -r parmetis%gcc@8.3.1 ^$mpistring
spack load -r seacas cgns=False ^$mpistring 

seacasdir=`python -c "print [x for x in '$CMAKE_PREFIX_PATH'.split(':') if 'seacas' in x][0]"`
hdf5dir=`python -c "print [x for x in '$CMAKE_PREFIX_PATH'.split(':') if 'hdf5' in x][0]"`
echo $seacasdir
cmake .. \
	-DCMAKE_CXX_COMPILER=clang++ \
	-DCMAKE_C_COMPILER=clang \
	-DCMAKE_CXX_FLAGS:STRING="-frelaxed-template-template-args --cuda-path=/usr/tce/packages/cuda/cuda-10.1.243/ --cuda-gpu-arch=sm_70" \
	-DCMAKE_EXE_LINKER_FLAGS:STRING="-L$hdf5dir/lib/ -lhdf5 -lpnetcdf -lnetcdf -lboost_program_options -lz --cuda-path=/usr/tce/packages/cuda/cuda-10.1.243/ --cuda-gpu-arch=sm_70  -L$installdir/lib64 -lkokkoscore" \
	-DCXX_CONFORMANCE_STANDARD:STRING=c++17 \
	-DLegion_INCLUDE_DIR=$installdir/include/ \
	-DLegion_LIBRARY=$installdir/lib64/liblegion.so \
	-DREALM_LIBRARY=$installdir/lib64/librealm.so \
	-DFLECSI_ENABLE_KOKKOS=ON \
	-DEXODUSII_INCLUDE_DIR=$seacasdir/include \
	-DEXODUSII_LIBRARY=$seacasdir/lib/libexodus.a \
	-DENABLE_FLECSI_TUTORIAL=OFF \
	-DENABLE_HDF5=ON

make -j

