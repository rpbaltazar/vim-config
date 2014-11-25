require 'fileutils'
require 'rake/win32'

class Installer
  attr_accessor :translations, :files

  MAC_OS=1
  LINUX_OS=2
  UNKNOWN=3

  def initialize(translations)
    @translations = translations
    @files = translations.map { |k,v| Translation.new(k, v) }
  end

  def self.windows?
    Rake::Win32.windows?
  end

  def self.git_clone(repo, target)
    path = translate_path(target)
    FileUtils.rm_rf(path) if File.exists?(path)
    `git clone ""#{repo}"" "#{target}"`
  end

  def self.home_join(*files)
    normalize(File.join(ENV['HOME'], files))
  end

  def self.translate_path(path)
    if path[0].chr === '~'
      path[0] = ENV['HOME']
    end
    normalize(path)
  end

  def self.normalize(path)
    Rake::Win32.normalize(path)
  end

  def self.which_os?

    if (/darwin/ =~ RUBY_PLATFORM) > 0
      MAC_OS
    elsif (/linux/ =~ RUBY_PLATFORM) > 0
      LINUX_OS
    else
      UNKNOWN
    end
  end
end
