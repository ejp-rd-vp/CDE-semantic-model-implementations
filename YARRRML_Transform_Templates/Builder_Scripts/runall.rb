filenames = Dir.open(".").to_a

filenames.each  do |f|
  next unless f.match(/^build/)
  match = f.match(/^build_D?CDE_([^\.]+)\.rb/)
  next unless match
  filename = match[1].downcase
  puts filename
  filename += "_yarrrml_template.yaml"
  puts filename
  res = `ruby #{f} > ../templates/#{filename}`
  puts res
end