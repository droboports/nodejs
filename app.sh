### NODEJS ###
_build_nodejs() {
local VERSION="0.12.7"
local FOLDER="node-v${VERSION}"
local FILE="${FOLDER}.tar.gz"
local URL="https://nodejs.org/dist/v${VERSION}/${FILE}"
export QEMU_LD_PREFIX="${TOOLCHAIN}/${HOST}/libc"

_download_tgz "${FILE}" "${URL}" "${FOLDER}"
pushd "target/${FOLDER}"
PKG_CONFIG_PATH="${DEST}/lib/pkgconfig" \
  ./configure --dest-cpu=arm --dest-os=linux --prefix="${DEST}" \
  --with-arm-float-abi=softfp
make
make install
mv -vf "${DEST}/share/man" "${DEST}/"
popd
}

### CERTIFICATES ###
_build_certificates() {
# update CA certificates on a Debian/Ubuntu machine:
#sudo update-ca-certificates
cp -vf /etc/ssl/certs/ca-certificates.crt "${DEST}/etc/ssl/certs/"
ln -vfs certs/ca-certificates.crt "${DEST}/etc/ssl/cert.pem"
}

### BUILD ###
_build() {
  _build_nodejs
  _build_certificates
  _package
}
