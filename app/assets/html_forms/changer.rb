Dir.glob("./*.html").each do |file|
 # File.rename(file,File.basename(file))
  f = File.open(file)			 
  contents = f.read
  f.close

  n = contents.gsub("1111111111-11", "<%= @doc.var_1 %>")
n = n.gsub("2!", "<%= @doc.var_2 %>")
n = n.gsub("3!", "<%= @doc.var_3 %>")
n = n.gsub("4!", "<%= @doc.var_4 %>")
n = n.gsub("5!", "<%= @doc.var_5 %>")
n = n.gsub("6!", "<%= @doc.var_6 %>")

if n != contents
  File.open(File.basename(file)+".erb", "w") do |f|
    f.puts n
  end
end
  #puts contents

end