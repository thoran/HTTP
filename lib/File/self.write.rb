# File.write

# 2011.03.10
# 0.1.0

class File
  
  def self.write(filename, s)
    file = new(filename, 'w')
    file.write(s)
    file.close
  end
  
end
