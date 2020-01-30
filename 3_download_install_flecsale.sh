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
`spack module tcl loads | grep "load parmetis"`
`spack module tcl loads | grep "load metis"`
`spack module tcl loads | grep "load hdf5"`
`spack module tcl loads | grep "load netcdf-c-"`
`spack module tcl loads | grep "load netcdf-cxx"`
`spack module tcl loads | grep "load openmpi-4.0.2-gcc"`

cmake .. \
	-DCMAKE_CXX_COMPILER=clang++ \
	-DCMAKE_C_COMPILER=clang \
	-DCMAKE_CXX_FLAGS:STRING="-frelaxed-template-template-args --cuda-path=/usr/tce/packages/cuda/cuda-10.1.243/ --cuda-gpu-arch=sm_70" \
	-DCMAKE_EXE_LINKER_FLAGS:STRING="-lboost_program_options -lz --cuda-path=/usr/tce/packages/cuda/cuda-10.1.243/ --cuda-gpu-arch=sm_70 -lmpi_cxx -L$installdir/lib64 -lkokkoscore -L/usr/tce/packages/cuda/cuda-10.1.243/lib64 -lcudart" \
	-DCXX_CONFORMANCE_STANDARD:STRING=c++17 \
	-DEXODUSII_INCLUDE_DIR:PATH=$installdir/include \
	-DEXODUSII_LIBRARY:FILEPATH=$installdir/lib/libexodus.a \
	-DLegion_INCLUDE_DIR=$installdir/include/ \
	-DLegion_LIBRARY=$installdir/lib64/liblegion.so \
	-DREALM_LIBRARY=$installdir/lib64/librealm.so \
	-DFLECSI_ENABLE_KOKKOS=ON \
	-DENABLE_FLECSI_TUTORIAL=OFF

make -j

