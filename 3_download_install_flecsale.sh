#set -x
rm -rf flecsale
git clone --recursive git@github.com:scothalverson/flecsale.git


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

../4_cmake_flecsale.sh

#cmake .. \
#	-DCMAKE_CXX_COMPILER=clang++ \
#	-DCMAKE_C_COMPILER=clang \
#	-DCMAKE_CXX_FLAGS:STRING="-frelaxed-template-template-args --cuda-path=/usr/tce/packages/cuda/cuda-10.1.243/ --cuda-gpu-arch=sm_70 -L/usr/tce/packages/cuda/cuda-10.1.243/lib64/ -lcudart" \
#	-DCMAKE_EXE_LINKER_FLAGS:STRING="-lboost_program_options -lz --cuda-path=/usr/tce/packages/cuda/cuda-10.1.243/ --cuda-gpu-arch=sm_70 -lmpi_cxx -L$installdir/lib64 -lkokkoscore" \
#	-DCXX_CONFORMANCE_STANDARD:STRING=c++17 \
#	-DEXODUSII_INCLUDE_DIR:PATH=$installdir/include \
#	-DEXODUSII_LIBRARY:FILEPATH=$installdir/lib/libexodus.a \
#	-DLegion_INCLUDE_DIR=$installdir/include/ \
#	-DLegion_LIBRARY=$installdir/lib64/liblegion.so \
#	-DREALM_LIBRARY=$installdir/lib64/librealm.so \
#	-DFLECSI_ENABLE_KOKKOS=ON \
#	-DENABLE_FLECSI_TUTORIAL=OFF
#
#make -j

