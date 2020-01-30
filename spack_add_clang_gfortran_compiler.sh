clang=`which clang`
clangpp=`which clang++`
fc=`which gfortran`

outputfile=~/.spack/linux/compilers.yaml

 echo '- compiler:' >> "$outputfile"
 echo '    spec: clang@11.0.0' >> "$outputfile"
 echo '    paths:' >> "$outputfile"
 echo '      cc: '$clang >> "$outputfile"
 echo '      cxx: '$clangpp  >> "$outputfile"
 echo '      f77: '$fc  >> "$outputfile"
 echo '      fc: '$fc  >> "$outputfile"
 echo '    flags: {}' >> "$outputfile"
 echo '    operating_system: rhel7' >> "$outputfile"
 echo '    target: ppc64le' >> "$outputfile"
 echo '    modules: []' >> "$outputfile"
 echo '    environment: {}' >> "$outputfile"
 echo '    extra_rpaths: []' >> "$outputfile"
