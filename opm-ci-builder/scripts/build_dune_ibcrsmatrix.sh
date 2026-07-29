#!/bin/bash

set -e

declare -A dune_repo
dune_repo[dune-alugrid]=https://gitlab.dune-project.org/extensions/dune-alugrid.git
dune_repo[dune-common]=https://gitlab.dune-project.org/core/dune-common.git
dune_repo[dune-fem]=https://gitlab.dune-project.org/dune-fem/dune-fem.git
dune_repo[dune-geometry]=https://gitlab.dune-project.org/core/dune-geometry.git
dune_repo[dune-grid]=https://gitlab.dune-project.org/core/dune-grid.git
dune_repo[dune-istl]=https://gitlab.dune-project.org/core/dune-istl.git
dune_repo[dune-localfunctions]=https://gitlab.dune-project.org/core/dune-localfunctions.git
dune_repo[dune-uggrid]=https://gitlab.dune-project.org/staging/dune-uggrid.git

# Install dune with experimental IBCRSMatrix extension (26-06-2026)
declare -A dune_version
dune_version[dune-alugrid]=b9377f8431a4d51f74b9681d9a59f83abdeb42b1         # master
dune_version[dune-common]=80a70ffc6bd5abfdc60201b0e0a0aba73377c0a6          # master
dune_version[dune-fem]=d5761f373be7bab2a4029dac18361cbb50ae006d             # master
dune_version[dune-geometry]=6620bcb61efa762df56bd730190e025ea2d36876        # master
dune_version[dune-grid]=e461feb92742622a762cf3ba4b2aa2eaf72ba6b7            # master
dune_version[dune-istl]=6d15664115debcbdbaa07c96ae37c3b50a564bfa            # feature/new-bcrsmatrix
dune_version[dune-localfunctions]=65ecdc21348ba998fa3c17f6f503d9071345fc7f  # master
dune_version[dune-uggrid]=9b6365fb5f3830cc6d03704934f8ad08c7ed44cc          # master

DESTDIR=/dune/ibcrsmatrix

for repo in dune-common \
            dune-geometry \
            dune-istl \
            dune-uggrid \
            dune-grid \
            dune-localfunctions \
            dune-alugrid \
            dune-fem
do
  echo "Building $repo ${dune_version[$repo]} ${dune_repo[$repo]}"
  git clone ${dune_repo[$repo]} dune_ibcrsmatrix/$repo
  git -C dune_ibcrsmatrix/$repo checkout ${dune_version[$repo]}
  cmake    -S dune_ibcrsmatrix/$repo \
           -B dune_ibcrsmatrix/$repo/build \
           -GNinja \
           -DCMAKE_BUILD_TYPE=Release \
           -DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=ON \
           -DCMAKE_C_COMPILER=/usr/lib/ccache/gcc \
           -DCMAKE_CXX_COMPILER=/usr/lib/ccache/g++ \
           -DBUILD_SHARED_LIBS=OFF \
           -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
           -DDUNE_ENABLE_PYTHONBINDINGS=OFF \
           -DCMAKE_INSTALL_PREFIX=$DESTDIR \
           -DCMAKE_PREFIX_PATH=$DESTDIR
  cmake --build dune_ibcrsmatrix/$repo
  cmake --install dune_ibcrsmatrix/$repo
done
