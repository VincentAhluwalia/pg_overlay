# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GNOME2_LA_PUNT="yes"

inherit autotools gnome2

DESCRIPTION="Simple document viewer for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Evince"
SRC_URI="https://github.com/linuxmint/${PN}/archive/${PV}.tar.gz"

LICENSE="GPL-2+ CC-BY-SA-3.0"
SLOT="0"
IUSE="djvu dvi gstreamer gnome gnome-keyring +introspection nemo nsplugin +postscript t1lib tiff xps"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~x64-solaris"

# atk used in libview
# gdk-pixbuf used all over the place
COMMON_DEPEND="
	dev-libs/atk
	>=dev-libs/glib-2.36:2[dbus]
	>=dev-libs/libxml2-2.5:2
	sys-libs/zlib:=
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.16.0:3[introspection?]
	gnome-base/gsettings-desktop-schemas
	>=x11-libs/cairo-1.10:=
	>=app-text/poppler-0.33:=[cairo]
	djvu? ( >=app-text/djvu-3.5.22:= )
	dvi? (
		virtual/tex-base
		dev-libs/kpathsea:=
		t1lib? ( >=media-libs/t1lib-5:= ) )
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
		media-libs/gst-plugins-good:1.0 )
	gnome-keyring? ( >=app-crypt/libsecret-0.5 )
	introspection? ( >=dev-libs/gobject-introspection-1:= )
	nemo? ( >=gnome-extra/nemo-3.0.0 )
	postscript? ( >=app-text/libspectre-0.2:= )
	tiff? ( >=media-libs/tiff-3.6:0= )
	xps? ( >=app-text/libgxps-0.2.1:= )
"
RDEPEND="${COMMON_DEPEND}
	gnome-base/gvfs
	gnome-base/librsvg
	|| (
		>=x11-themes/adwaita-icon-theme-2.17.1
		>=x11-themes/hicolor-icon-theme-0.10 )
"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-xml-dtd:4.3
	app-text/yelp-tools
	dev-util/gdbus-codegen
	>=dev-util/gtk-doc-am-1.13
	>=dev-util/intltool-0.35
	dev-util/itstool
	sys-devel/gettext
	virtual/pkgconfig
"
# eautoreconf needs:
#  app-text/yelp-tools

src_prepare() {
	eautoreconf
	gnome2_src_prepare

	sed -e "s:GTK\;Graphics\;VectorGraphics\;Viewer\;:GTK\;Office\;Viewer\;Graphics\;VectorGraphics;:g" \
		-i data/atril.desktop.in.in || e
}

src_configure() {
	gnome2_src_configure \
		--disable-static \
		--enable-pdf \
		--enable-comics \
		--enable-thumbnailer \
		--enable-dbus \
		--with-gtk=3.0 \
		--disable-caja \
		$(use_enable djvu) \
		$(use_enable dvi) \
		$(use_enable gstreamer multimedia) \
		$(use_enable gnome libgnome-desktop) \
		$(use_with gnome-keyring keyring) \
		$(use_enable introspection) \
		$(use_enable nemo) \
		$(use_enable nsplugin browser-plugin) \
		$(use_enable postscript ps) \
		$(use_enable t1lib) \
		$(use_enable tiff) \
		$(use_enable xps) \
		BROWSER_PLUGIN_DIR="${EPREFIX}"/usr/$(get_libdir)/nsbrowser/plugins
}
