require 'rake'
require './lib/installer'
require './lib/translation'

MAC_FILES =
  { '.vimrc'           => '~/.vimrc',
    '.vim'             => '~/.vim' }

WITH_ASSETS = {
  "assets/fonts/Inconsolata/*.otf" => "~/Library/Fonts",
  "assets/custom_configs/inconsolata.vim" => "~/.vim/custom_configs/vim_looks.vim"
}

WITHOUT_ASSETS = {
  "assets/custom_configs/monaco.vim" => "~/.vim/custom_configs/vim_looks.vim"
}

desc "Install vim configuration and plugin files"
task :default do
  installer = Installer.new(platform_files)
  installer.files.each do |f|
    case
      when f.identical?    then skip_file(f)
      when replace_all?    then auto_link_files(f)
      when f.safe_to_link? then auto_link_files(f)
      else                      prompt_to_link_files(f)
    end
  end
  Rake::Task['vundle'].execute
  Rake::Task['assets'].execute
end

desc "Install vundle for vim plugins"
task :vundle do
  target = "#{platform_files['.vim']}/vundle.git"
  Installer.git_clone('http://github.com/gmarik/vundle.git', target)
  puts "Running BundleInstall to install plugins...this will take a couple minutes."
  `vim +BundleInstall +qall`
  puts "vim plugins installed."
end

desc "Copy fonts"
task :assets do
  if prompt_to_copy_assets
    assets = Installer.new WITH_ASSETS
    puts "Set Inconsolata font as default and set colorscheme to Tomorrow-Night-Eighties"
  else
    assets = Installer.new WITHOUT_ASSETS
    puts "Set Monaco font as default and set colorscheme to Tomorrow-Night-Eighties"
  end

  assets.files.each do |f|
    case
      when f.identical? then skip_file f
      else copy_files f
    end
  end

end

def platform_files
  MAC_FILES
end

def prompt_to_copy_assets
  print "Do you wish to copy the fonts to ~/Library/Fonts? [Y/n]"
  case $stdin.gets.chomp
    when 'Y','y' then
      true
    else
      false
  end
end

def prompt_to_link_files(file)
  print "overwrite? #{file.target} [ynaq]  "
  case $stdin.gets.chomp
    when 'y' then replace(file)
    when 'a' then replace_all(file)
    when 'q' then exit
    else          skip_file(file)
  end
end

def link_files(file)
  puts " => symlinking #{file.source} to #{file.target}"
  file.link
end

def replace(file)
  puts " => replacing #{file.source} with #{file.target}"
  file.force_link
end

def replace_all(file)
  @replace_all = true
  replace(file)
end

def replace_all?
  @replace_all == true
end

def skip_file(file)
  puts " => skipping #{file.target}"
end

def copy_files file
  file.copy
end

def auto_link_files(file)
  file.safe_to_link? ? link_files(file) : replace(file)
end
