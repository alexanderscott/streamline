  
def secondsToTime (seconds)
  Time.at(seconds).utc.strftime("%M:%S")
end
