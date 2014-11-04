require 'formula'

class V8323 < Formula
  homepage 'http://code.google.com/p/v8/'
  url 'https://github.com/v8/v8/archive/3.23.18.tar.gz'
  sha1 '6f2e8fa799ebefa0494f76fece7e27b03807bdc3'

  keg_only 'Conflicts with V8 in main repository.'

  option 'with-readline', 'Use readline instead of libedit'

  # not building on Snow Leopard:
  # https://github.com/Homebrew/homebrew/issues/21426
  depends_on :macos => :lion

  depends_on :xcode
  depends_on :python # gyp doesn't run under 2.6 or lower
  depends_on 'readline' => :optional

  resource 'gyp' do
    url 'http://gyp.googlecode.com/svn/trunk', :revision => 1685
    version '1685'
  end

  def install
    (buildpath/'build/gyp').install resource('gyp')

    system "make", "native",
                   "-j#{ENV.make_jobs}",
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
