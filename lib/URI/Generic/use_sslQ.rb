# URI/Generic/use_sslQ.rb
# URI::Generic#use_ssl?

# 20141113
# 0.0.0

# Notes:
# 1. Using the date from when first created in HTTP.get/post as the creation date.

module URI
  class Generic

    def use_ssl?
      scheme == 'https' ? true : false
    end

  end
end
