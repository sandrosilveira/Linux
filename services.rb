#!/usr/bin/env ruby
puts 
system('service CtreeSQLServer status')
puts 
system('service RechApplicationServer status')

if File.exist?('/etc/init.d/RechThinServer')
  puts 
  system('service RechThinServer status')
end

for arg in ARGV
  if arg == '-r' || arg == '-restart' 
    system('systemctl restart CtreeSQLServer')
    system('systemctl restart RechApplicationServer')
  end
end
