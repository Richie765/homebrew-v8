require 'formula'

class V831916 < Formula
  homepage 'http://code.google.com/p/v8/'
  url 'https://github.com/v8/v8/archive/3.19.16.tar.gz'
  sha1 'fa9862f805ce07d1dbaf5a9229ebbbbe616298f2'

  keg_only 'Conflicts with V8 in main repository.'

  # gyp currently depends on a full xcode install
  # https://code.google.com/p/gyp/issues/detail?id=292
  depends_on :xcode

  def install
    system 'make dependencies'
    system 'make', 'native',
                   "-j#{ENV.make_jobs}",
                   "library=shared",
                   "snapshot=on",
                   "console=readline"

    prefix.install 'include'
    cd 'out/native' do
      lib.install Dir['lib*']
      bin.install 'd8', 'lineprocessor', 'preparser', 'process', 'shell' => 'v8'
      bin.install Dir['mksnapshot.*']
    end
  end
end
