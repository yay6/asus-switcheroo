# Maintainer: Jakub Janeczko <jjaneczk@gmail.com>
pkgbase=asus-switcheroo-git
pkgname=(byo-switcheroo-git byo-switcheroo-dkms-git)
pkgver=r36.f066d4b
pkgrel=1
_kernver="$(uname -r)"
_kernmin="$(uname -r | cut -d '.' -f -2)"
_kernmax="$(uname -r | cut -d '.' -f 1).$(($(uname -r | cut -d '.' -f 2)+1))"
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
	cd "$srcdir/${pkgbase%-git}"
	printf "r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}

build() {
	cd "$srcdir/${pkgbase%-git}"
	make KDIR=/lib/modules/${_kernver}/build
}

package_byo-switcheroo-git() {
	depends=("linux>=${_kernmin}" "linux<${_kernmax}")
	install=byo-switcheroo.install

	cd "$srcdir/${pkgbase%-git}"

	install -dm 755 "${pkgdir}/usr/lib/systemd/system-sleep"
	install -Dm 755 asus-switcheroo.sh /usr/lib/systemd/system-sleep/asus-switcheroo.sh

	install -Dm 644 byo-switcheroo.ko "${pkgdir}"/usr/lib/modules/${_extramodules}/byo-switcheroo.ko
	install -dm 755 asus-switcheroo-pm /etc/pm/sleep.d/75-asus-switcheroo-pm

	gzip "${pkgdir}/usr/lib/modules/${_extramodules}/byo-switcheroo.ko"
}

package_byo-switcheroo-dkms-git() {
	depends=('dkms')

	cd "$srcdir/${pkgbase%-git}"

	install -dm 755 "${pkgdir}/usr/lib/systemd/system-sleep"
	install -Dm 755 asus-switcheroo.sh /usr/lib/systemd/system-sleep/asus-switcheroo.sh

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
