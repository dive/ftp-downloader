#!/usr/bin/ruby

require 'net/ftp'
require 'fileutils'

ftp_adr = 'ftp.example.com'
login = 'your_login'
password = 'your_password'
dir_adr = 'directory_at_ftp'

ftp = Net::FTP.new(ftp_adr, login, password)
ftp.binary = true
ftp.passive = true
ftp.chdir(dir_adr)

def download_files(dir, ftp, home_dir)
    ftp.chdir(dir)
    dir_files = ftp.list
    dir_files.each do |name|
        if name =~ /^d/
            download_files(name.split.last, ftp, home_dir)
        else 
            FileUtils.mkdir_p(home_dir + "/" + ftp.getdir.to_s[1..-1])
            FileUtils.cd(home_dir + "/" + ftp.getdir.to_s[1..-1], :verbose => false)
            puts "\t DOWNLOAD : " + ftp.getdir.to_s + name.split.last.to_s
            ftp.getbinaryfile(name.split.last)
        end
    end
    ftp.chdir('../')
    FileUtils.cd('../')
end

download_files(ftp.getdir, ftp, FileUtils.pwd)

ftp.close