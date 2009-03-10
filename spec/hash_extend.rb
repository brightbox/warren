class Hash
  def except(*blacklist)
    self.reject {|key, value| blacklist.include?(key) }
  end

  def only(*whitelist)
    self.reject {|key, value| !whitelist.include?(key) }
  end
end
