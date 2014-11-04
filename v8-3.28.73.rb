require 'formula'

class V832873 < Formula
  homepage 'http://code.google.com/p/v8/'
  url 'https://github.com/v8/v8/archive/3.28.73.tar.gz'
  sha1 '502fa467b0b2d29828985074f32b5fa04873e698'

  keg_only 'Conflicts with V8 in main repository.'

  option 'with-readline', 'Use readline instead of libedit'

  # not building on Snow Leopard:
  # https://github.com/Homebrew/homebrew/issues/21426
  depends_on :macos => :lion

  depends_on :python => :build # gyp doesn't run under 2.6 or lower
  depends_on 'readline' => :optional

  # resource 'gyp' do
  #   url 'http://gyp.googlecode.com/svn/trunk', :revision => 1831
  #   version '1831'
  # end

  def install
    # (buildpath/'build/gyp').install resource('gyp')

    system "make", "builddeps"

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
