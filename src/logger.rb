class Logger
  attr_reader :filename
  def initialize(filename)
    @filename = filename
  end
  def log(message)
    File.open(File.join(__dir__, "../log/#{filename}"), 'a+') do |file|
      file.write(message)
      file.close
    end
  end
end