  
def secondsToTime (seconds)
  Time.at(seconds).utc.strftime("%M:%S")
end

def deepInspect (obj)
  obj.instance_variables.map do |var|
      puts [var, obj.instance_variable_get(var)].join(":")
  end
end
