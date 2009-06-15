require File.join(File.dirname(__FILE__) + "/../lib/warren")

# Hacky and I hate it, but needed to 
# change constants in tests
# from http://is.gd/12JVp
def silently(&block)
  warn_level = $VERBOSE
  $VERBOSE = nil
  result = block.call
  $VERBOSE = warn_level
  result
end
