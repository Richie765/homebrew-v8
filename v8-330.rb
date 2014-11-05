require 'formula'

class V8330 < Formula
  homepage 'http://code.google.com/p/v8/'
  url 'https://github.com/v8/v8-git-mirror/archive/3.30.34.tar.gz'
  sha1 '930a294cf4bf01d34f1a5aebb742dc0e67234539'

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

  resource 'gtest' do
    url 'http://googletest.googlecode.com/svn/trunk', :revision => 692
    version '692'
  end

  resource 'gmock' do
    url 'http://googlemock.googlecode.com/svn/trunk', :revision => 485
    version '485'
  end


  def install
    # system "make", "builddeps"

    (buildpath/'build/gyp').install resource('gyp')
    (buildpath/'testing/gtest').install resource('gtest')
    (buildpath/'testing/gmock').install resource('gmock')

    system "make", "native",
                   "library=shared",
                   "snapshot=on",
                   "console=readline",
                   "i18nsupport=off"

    prefix.install 'include'
    cd 'out/native' do
      lib.install Dir['lib*']
      bin.install 'd8', 'lineprocessor', 'mksnapshot', 'process', 'shell' => 'v8'
    end
  end
end
