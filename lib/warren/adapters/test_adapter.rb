class TestAdapter < Warren::Queue
  ConnectionFailed = Class.new(Exception)
  # 
  def self.publish queue_name, payload, &blk
    raise TestAdapter::ConnectionFailed if fail?
    true
  end

  # 
  # def self.subscribe queue_name, &block
  #   puts "subscribing to #{queue_name}"
  # end
  # 
  
  private
  
  def self.fail?
    File.exists?(file_name) && (File.read(file_name, 4) == "FAIL")
  end
  
  def self.file_name
    "#{WARREN_ROOT}/tmp/warren.txt"
  end
end

