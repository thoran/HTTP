# Net/HTTP/set_options.rb
# Net::HTTP#set_options

# 20171007
# 0.0.0

module Net
  class HTTP

    def set_options(options = {})
      options.each{|k,v| self.send("#{k}=", v)}
    end
    alias_method :options=, :set_options

  end
end
