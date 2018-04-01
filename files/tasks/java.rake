desc 'Setup JEnv Java versions'
task :java do
  Dir['/Library/Java/JavaVirtualMachines/*'].each do |jdk_path|
    `jenv add #{jdk_path}/Contents/Home`
  end
end
