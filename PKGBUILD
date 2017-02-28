# Maintainer: Jakub Janeczko <jjaneczk@gmail.com>
if [[ -n "${_lts}" ]]; then
	pkgbase=asus-switcheroo-git-lts
	pkgname=(byo-switcheroo-git-lts)
	_kernver="$(pacman -Qi linux-lts | grep Version | tr -d ' ' | cut -d : -f 2)-lts"
else
	pkgbase=asus-switcheroo-git
	pkgname=(byo-switcheroo-git byo-switcheroo-git-dkms)
	_kernver="$(pacman -Qi linux | grep Version | tr -d ' ' | cut -d : -f 2)-ARCH"
fi
pkgver=r40.0076981
pkgrel=1
#[[ -z "${_kernver}" ]] && _kernver="$(uname -r)"
_kernmin="$(echo ${_kernver} | cut -d '.' -f -2)"
_kernmax="$(echo ${_kernver} | cut -d '.' -f 1).$(($(echo "${_kernver}" | cut -d '.' -f 2)+1))"
_extramodules=$(readlink -f /usr/lib/modules/${_kernver}/extramodules)
pkgdesc="Drivers for Asus laptops with integrated Intel graphics and discrete Nvidia graphics."
arch=('i686' 'x86_64')
url="https://github.com/yay6/asus-switcheroo"
license=('GPLv2')
groups=()
depends=()
makedepends=('git')
provides=("${pkgname%-git}")
conflicts=("${pkgname%-git}")
replaces=()
backup=()
options=()
install=byo-switcheroo.install
source=('asus-switcheroo::git+https://github.com/yay6/asus-switcheroo.git#branch=master')
noextract=()
md5sums=('SKIP')

pkgver() {
	cd "$srcdir/${pkgbase%-git*}"
	printf "r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}

build() {
	cd "$srcdir/${pkgbase%-git*}"
	make KDIR=/lib/modules/${_kernver}/build
}

package_byo-switcheroo-git() {
	depends=("linux>=${_kernmin}" "linux<${_kernmax}")
	install=byo-switcheroo.install

	cd "$srcdir/${pkgbase%-git*}"

	install -Dm 644 byo-switcheroo.ko "${pkgdir}/${_extramodules}/byo-switcheroo.ko"
	gzip "${pkgdir}/${_extramodules}/byo-switcheroo.ko"
}

package_byo-switcheroo-git-lts() {
	package_byo-switcheroo-git

	install -dm 755 "${pkgdir}/usr/lib/systemd/system-sleep"
	install -Dm 755 asus-switcheroo.sh "${pkgdir}/usr/lib/systemd/system-sleep/asus-switcheroo.sh"
}

package_byo-switcheroo-git-dkms() {
	depends=('dkms')

	cd "$srcdir/${pkgbase%-git}"

	#install -dm 755 "${pkgdir}/usr/lib/systemd/system-sleep"
	#install -Dm 755 asus-switcheroo.sh "${pkgdir}/usr/lib/systemd/system-sleep/asus-switcheroo.sh"

	install -dm 755 "${pkgdir}/usr/src/${pkgbase}-${pkgver}/"
	install -Dm 644 Makefile byo-switcheroo.c "${pkgdir}/usr/src/${pkgbase}-${pkgver}/"
}

cat > byo-switcheroo.install << EOF
post_install() {
    EXTRAMODULES='${_extramodules##*/}'
    depmod \$(cat /usr/lib/modules/\${EXTRAMODULES}/version)
}

post_upgrade() {
    post_install
}

post_remove() {
    post_install
}
EOF
