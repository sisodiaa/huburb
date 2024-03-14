module RandomString
  def self.generate_pin length
    charset = [('a'..'z'), ('0'..'9')].map(&:to_a).flatten
    Array.new(length) { charset.sample }.join
  end
end
