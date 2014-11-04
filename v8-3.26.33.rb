require 'formula'

class V832633 < Formula
  homepage 'http://code.google.com/p/v8/'
  url 'https://github.com/v8/v8/archive/3.26.33.tar.gz'
  sha1 '5057db5b82daada54e61257591af119a085f3e81'

  keg_only 'Conflicts with V8 in main repository.'

  option 'with-readline', 'Use readline instead of libedit'

  # not building on Snow Leopard:
  # https://github.com/Homebrew/homebrew/issues/21426
  depends_on :macos => :lion

  depends_on :python => :build # gyp doesn't run under 2.6 or lower
  depends_on 'readline' => :optional

  resource 'gyp' do
    url 'http://gyp.googlecode.com/svn/trunk', :revision => 1831
    version '1831'
  end

  def install
    (buildpath/'build/gyp').install resource('gyp')

    system "make", "native",
                   "library=shared",
                   "snapshot=on",
                   "console=readline",
                   "i18nsupport=off"

    prefix.install 'include'
    cd 'out/native' do
      lib.install Dir['lib*']
      bin.install 'd8', 'lineprocessor', 'process', 'shell' => 'v8'
      bin.install Dir['mksnapshot.*']
    end
  end
end
