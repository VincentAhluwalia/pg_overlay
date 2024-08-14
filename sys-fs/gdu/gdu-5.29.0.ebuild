# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

EGO_SUM=(
"cloud.google.com/go v0.26.0/go.mod"
"github.com/BurntSushi/toml v0.3.1/go.mod"
"github.com/OneOfOne/xxhash v1.2.2"
"github.com/OneOfOne/xxhash v1.2.2/go.mod"
"github.com/armon/consul-api v0.0.0-20180202201655-eb2c6b5be1b6/go.mod"
"github.com/cespare/xxhash v1.1.0"
"github.com/cespare/xxhash v1.1.0/go.mod"
"github.com/cespare/xxhash/v2 v2.1.1"
"github.com/cespare/xxhash/v2 v2.1.1/go.mod"
"github.com/client9/misspell v0.3.4/go.mod"
"github.com/coreos/etcd v3.3.10+incompatible/go.mod"
"github.com/coreos/go-etcd v2.0.0+incompatible/go.mod"
"github.com/coreos/go-semver v0.2.0/go.mod"
"github.com/cpuguy83/go-md2man v1.0.10/go.mod"
"github.com/cpuguy83/go-md2man/v2 v2.0.3/go.mod"
"github.com/creack/pty v1.1.9/go.mod"
"github.com/davecgh/go-spew v1.1.0/go.mod"
"github.com/davecgh/go-spew v1.1.1"
"github.com/davecgh/go-spew v1.1.1/go.mod"
"github.com/dgraph-io/badger/v3 v3.2103.2"
"github.com/dgraph-io/badger/v3 v3.2103.2/go.mod"
"github.com/dgraph-io/ristretto v0.1.0"
"github.com/dgraph-io/ristretto v0.1.0/go.mod"
"github.com/dgryski/go-farm v0.0.0-20190423205320-6a90982ecee2"
"github.com/dgryski/go-farm v0.0.0-20190423205320-6a90982ecee2/go.mod"
"github.com/dustin/go-humanize v1.0.0"
"github.com/dustin/go-humanize v1.0.0/go.mod"
"github.com/fatih/color v1.16.0"
"github.com/fatih/color v1.16.0/go.mod"
"github.com/fsnotify/fsnotify v1.4.7/go.mod"
"github.com/gdamore/encoding v1.0.0"
"github.com/gdamore/encoding v1.0.0/go.mod"
"github.com/gdamore/tcell/v2 v2.7.1"
"github.com/gdamore/tcell/v2 v2.7.1/go.mod"
"github.com/gogo/protobuf v1.3.2"
"github.com/gogo/protobuf v1.3.2/go.mod"
"github.com/golang/glog v0.0.0-20160126235308-23def4e6c14b"
"github.com/golang/glog v0.0.0-20160126235308-23def4e6c14b/go.mod"
"github.com/golang/groupcache v0.0.0-20190702054246-869f871628b6"
"github.com/golang/groupcache v0.0.0-20190702054246-869f871628b6/go.mod"
"github.com/golang/mock v1.1.1/go.mod"
"github.com/golang/protobuf v1.2.0/go.mod"
"github.com/golang/protobuf v1.3.1"
"github.com/golang/protobuf v1.3.1/go.mod"
"github.com/golang/snappy v0.0.3"
"github.com/golang/snappy v0.0.3/go.mod"
"github.com/google/flatbuffers v1.12.1"
"github.com/google/flatbuffers v1.12.1/go.mod"
"github.com/google/go-cmp v0.3.0/go.mod"
"github.com/google/go-cmp v0.5.4/go.mod"
"github.com/h2non/filetype v1.1.3"
"github.com/h2non/filetype v1.1.3/go.mod"
"github.com/hashicorp/hcl v1.0.0/go.mod"
"github.com/inconshreveable/mousetrap v1.0.0/go.mod"
"github.com/inconshreveable/mousetrap v1.1.0"
"github.com/inconshreveable/mousetrap v1.1.0/go.mod"
"github.com/kisielk/errcheck v1.5.0/go.mod"
"github.com/kisielk/gotool v1.0.0/go.mod"
"github.com/klauspost/compress v1.12.3"
"github.com/klauspost/compress v1.12.3/go.mod"
"github.com/kr/pretty v0.1.0/go.mod"
"github.com/kr/pretty v0.3.0"
"github.com/kr/pretty v0.3.0/go.mod"
"github.com/kr/pty v1.1.1/go.mod"
"github.com/kr/text v0.1.0/go.mod"
"github.com/kr/text v0.2.0"
"github.com/kr/text v0.2.0/go.mod"
"github.com/lucasb-eyer/go-colorful v1.2.0"
"github.com/lucasb-eyer/go-colorful v1.2.0/go.mod"
"github.com/magiconair/properties v1.8.0/go.mod"
"github.com/maruel/natural v1.1.0"
"github.com/maruel/natural v1.1.0/go.mod"
"github.com/mattn/go-colorable v0.1.13"
"github.com/mattn/go-colorable v0.1.13/go.mod"
"github.com/mattn/go-isatty v0.0.16/go.mod"
"github.com/mattn/go-isatty v0.0.20"
"github.com/mattn/go-isatty v0.0.20/go.mod"
"github.com/mattn/go-runewidth v0.0.15"
"github.com/mattn/go-runewidth v0.0.15/go.mod"
"github.com/mitchellh/go-homedir v1.1.0/go.mod"
"github.com/mitchellh/mapstructure v1.1.2/go.mod"
"github.com/pbnjay/memory v0.0.0-20210728143218-7b4eea64cf58"
"github.com/pbnjay/memory v0.0.0-20210728143218-7b4eea64cf58/go.mod"
"github.com/pelletier/go-toml v1.2.0/go.mod"
"github.com/pkg/errors v0.9.1"
"github.com/pkg/errors v0.9.1/go.mod"
"github.com/pmezard/go-difflib v1.0.0"
"github.com/pmezard/go-difflib v1.0.0/go.mod"
"github.com/rivo/tview v0.0.0-20240204151237-861aa94d61c8"
"github.com/rivo/tview v0.0.0-20240204151237-861aa94d61c8/go.mod"
"github.com/rivo/uniseg v0.2.0/go.mod"
"github.com/rivo/uniseg v0.4.3/go.mod"
"github.com/rivo/uniseg v0.4.7"
"github.com/rivo/uniseg v0.4.7/go.mod"
"github.com/rogpeppe/go-internal v1.6.1"
"github.com/rogpeppe/go-internal v1.6.1/go.mod"
"github.com/russross/blackfriday v1.5.2/go.mod"
"github.com/russross/blackfriday/v2 v2.1.0/go.mod"
"github.com/sirupsen/logrus v1.9.3"
"github.com/sirupsen/logrus v1.9.3/go.mod"
"github.com/spaolacci/murmur3 v0.0.0-20180118202830-f09979ecbc72/go.mod"
"github.com/spaolacci/murmur3 v1.1.0"
"github.com/spaolacci/murmur3 v1.1.0/go.mod"
"github.com/spf13/afero v1.1.2/go.mod"
"github.com/spf13/cast v1.3.0/go.mod"
"github.com/spf13/cobra v0.0.5/go.mod"
"github.com/spf13/cobra v1.8.0"
"github.com/spf13/cobra v1.8.0/go.mod"
"github.com/spf13/jwalterweatherman v1.0.0/go.mod"
"github.com/spf13/pflag v1.0.3/go.mod"
"github.com/spf13/pflag v1.0.5"
"github.com/spf13/pflag v1.0.5/go.mod"
"github.com/spf13/viper v1.3.2/go.mod"
"github.com/stretchr/objx v0.1.0/go.mod"
"github.com/stretchr/testify v1.2.2/go.mod"
"github.com/stretchr/testify v1.4.0/go.mod"
"github.com/stretchr/testify v1.7.0/go.mod"
"github.com/stretchr/testify v1.9.0"
"github.com/stretchr/testify v1.9.0/go.mod"
"github.com/ugorji/go/codec v0.0.0-20181204163529-d75b2dcb6bc8/go.mod"
"github.com/ulikunitz/xz v0.5.12"
"github.com/ulikunitz/xz v0.5.12/go.mod"
"github.com/xordataexchange/crypt v0.0.3-0.20170626215501-b2862e3d0a77/go.mod"
"github.com/yuin/goldmark v1.1.27/go.mod"
"github.com/yuin/goldmark v1.2.1/go.mod"
"github.com/yuin/goldmark v1.4.13/go.mod"
"go.opencensus.io v0.22.5"
"go.opencensus.io v0.22.5/go.mod"
"golang.org/x/crypto v0.0.0-20181203042331-505ab145d0a9/go.mod"
"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
"golang.org/x/crypto v0.0.0-20191011191535-87dc89f01550/go.mod"
"golang.org/x/crypto v0.0.0-20200622213623-75b288015ac9/go.mod"
"golang.org/x/crypto v0.0.0-20210921155107-089bfa567519/go.mod"
"golang.org/x/exp v0.0.0-20190121172915-509febef88a4/go.mod"
"golang.org/x/exp v0.0.0-20240205201215-2c58cdc269a3"
"golang.org/x/exp v0.0.0-20240205201215-2c58cdc269a3/go.mod"
"golang.org/x/lint v0.0.0-20181026193005-c67002cb31c3/go.mod"
"golang.org/x/lint v0.0.0-20190227174305-5b3e6a55c961/go.mod"
"golang.org/x/lint v0.0.0-20190313153728-d0100b6bd8b3/go.mod"
"golang.org/x/mod v0.2.0/go.mod"
"golang.org/x/mod v0.3.0/go.mod"
"golang.org/x/mod v0.6.0-dev.0.20220419223038-86c51ed26bb4/go.mod"
"golang.org/x/mod v0.8.0/go.mod"
"golang.org/x/net v0.0.0-20180724234803-3673e40ba225/go.mod"
"golang.org/x/net v0.0.0-20180826012351-8a410e7b638d/go.mod"
"golang.org/x/net v0.0.0-20190213061140-3a22650c66bd/go.mod"
"golang.org/x/net v0.0.0-20190311183353-d8887717615a/go.mod"
"golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3/go.mod"
"golang.org/x/net v0.0.0-20190620200207-3b0461eec859/go.mod"
"golang.org/x/net v0.0.0-20200226121028-0de0cce0169b/go.mod"
"golang.org/x/net v0.0.0-20201021035429-f5854403a974/go.mod"
"golang.org/x/net v0.0.0-20210226172049-e18ecbb05110/go.mod"
"golang.org/x/net v0.0.0-20220722155237-a158d28d115b/go.mod"
"golang.org/x/net v0.6.0/go.mod"
"golang.org/x/net v0.23.0"
"golang.org/x/net v0.23.0/go.mod"
"golang.org/x/oauth2 v0.0.0-20180821212333-d2e6202438be/go.mod"
"golang.org/x/sync v0.0.0-20180314180146-1d60e4601c6f/go.mod"
"golang.org/x/sync v0.0.0-20181108010431-42b317875d0f/go.mod"
"golang.org/x/sync v0.0.0-20190227155943-e225da77a7e6/go.mod"
"golang.org/x/sync v0.0.0-20190423024810-112230192c58/go.mod"
"golang.org/x/sync v0.0.0-20190911185100-cd5d95a43a6e/go.mod"
"golang.org/x/sync v0.0.0-20201020160332-67f06af15bc9/go.mod"
"golang.org/x/sync v0.0.0-20220722155255-886fb9371eb4/go.mod"
"golang.org/x/sync v0.1.0/go.mod"
"golang.org/x/sys v0.0.0-20180830151530-49385e6e1522/go.mod"
"golang.org/x/sys v0.0.0-20181205085412-a5c9d58dba9a/go.mod"
"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
"golang.org/x/sys v0.0.0-20190412213103-97732733099d/go.mod"
"golang.org/x/sys v0.0.0-20190502145724-3ef323f4f1fd/go.mod"
"golang.org/x/sys v0.0.0-20200930185726-fdedc70b468f/go.mod"
"golang.org/x/sys v0.0.0-20201119102817-f84b799fce68/go.mod"
"golang.org/x/sys v0.0.0-20210124154548-22da62e12c0c/go.mod"
"golang.org/x/sys v0.0.0-20210615035016-665e8c7367d1/go.mod"
"golang.org/x/sys v0.0.0-20220520151302-bc2c85ada10a/go.mod"
"golang.org/x/sys v0.0.0-20220715151400-c0bba94af5f8/go.mod"
"golang.org/x/sys v0.0.0-20220722155257-8c9f86f7a55f/go.mod"
"golang.org/x/sys v0.0.0-20220811171246-fbc7d0a398ab/go.mod"
"golang.org/x/sys v0.5.0/go.mod"
"golang.org/x/sys v0.6.0/go.mod"
"golang.org/x/sys v0.17.0/go.mod"
"golang.org/x/sys v0.20.0"
"golang.org/x/sys v0.20.0/go.mod"
"golang.org/x/term v0.0.0-20201126162022-7de9c90e9dd1/go.mod"
"golang.org/x/term v0.0.0-20210927222741-03fcf44c2211/go.mod"
"golang.org/x/term v0.5.0/go.mod"
"golang.org/x/term v0.17.0/go.mod"
"golang.org/x/term v0.18.0"
"golang.org/x/term v0.18.0/go.mod"
"golang.org/x/text v0.3.0/go.mod"
"golang.org/x/text v0.3.3/go.mod"
"golang.org/x/text v0.3.7/go.mod"
"golang.org/x/text v0.7.0/go.mod"
"golang.org/x/text v0.14.0"
"golang.org/x/text v0.14.0/go.mod"
"golang.org/x/tools v0.0.0-20180917221912-90fa682c2a6e/go.mod"
"golang.org/x/tools v0.0.0-20190114222345-bf090417da8b/go.mod"
"golang.org/x/tools v0.0.0-20190226205152-f727befe758c/go.mod"
"golang.org/x/tools v0.0.0-20190311212946-11955173bddd/go.mod"
"golang.org/x/tools v0.0.0-20191119224855-298f0cb1881e/go.mod"
"golang.org/x/tools v0.0.0-20200619180055-7c47624df98f/go.mod"
"golang.org/x/tools v0.0.0-20210106214847-113979e3529a/go.mod"
"golang.org/x/tools v0.1.12/go.mod"
"golang.org/x/tools v0.6.0/go.mod"
"golang.org/x/xerrors v0.0.0-20190717185122-a985d3407aa7/go.mod"
"golang.org/x/xerrors v0.0.0-20191011141410-1b5146add898/go.mod"
"golang.org/x/xerrors v0.0.0-20191204190536-9bdfabe68543/go.mod"
"golang.org/x/xerrors v0.0.0-20200804184101-5ec99f83aff1/go.mod"
"google.golang.org/appengine v1.1.0/go.mod"
"google.golang.org/appengine v1.4.0/go.mod"
"google.golang.org/genproto v0.0.0-20180817151627-c66870c02cf8/go.mod"
"google.golang.org/genproto v0.0.0-20190425155659-357c62f0e4bb/go.mod"
"google.golang.org/grpc v1.19.0/go.mod"
"google.golang.org/grpc v1.20.1/go.mod"
"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
"gopkg.in/check.v1 v1.0.0-20180628173108-788fd7840127/go.mod"
"gopkg.in/check.v1 v1.0.0-20190902080502-41f04d3bba15"
"gopkg.in/check.v1 v1.0.0-20190902080502-41f04d3bba15/go.mod"
"gopkg.in/errgo.v2 v2.1.0/go.mod"
"gopkg.in/yaml.v2 v2.2.2/go.mod"
"gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c/go.mod"
"gopkg.in/yaml.v3 v3.0.1"
"gopkg.in/yaml.v3 v3.0.1/go.mod"
"honnef.co/go/tools v0.0.0-20190102054323-c2f93a96b099/go.mod"
)

DESCRIPTION="Disk usage analyzer with console interface written in Go"
HOMEPAGE="https://github.com/dundee/gdu"
SRC_URI="https://github.com/dundee/gdu/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 BSD MIT"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	ego build -ldflags "-s -w -X 'github.com/dundee/gdu/build.Version=${PV}'" -v -x -work -o "${PN}" "./cmd/${PN}"
}

src_install() {
	einstalldocs
	dodoc -r README.md gdu.1.md
	dobin gdu
	doman gdu.1
}

src_test() {
	ego test ./...
}
