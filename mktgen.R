mktgen <- function(timevec,tempvec,ea=83.144)
{
  # ea = scalar, equal to the heat of activation for the degradation reaction.  Specify in kJ.
  # tempvec = vector of temperature readings.  Specify in degrees Celsius.
  # timevec = vector of time points, of same length as tempvec.  It is a chron object
  # Function returns mean kinetic temperature (mkt) in degrees Celsius, calculated 2 different ways.
  # mkt1 is calculated based on Tong & Lock 2015 paper.
  # mkt2 is calculated based on a formula found on the wikipedia page for mean kinetic temperature.
  
  # Gas constant, in kJ/mole/deg K:  (source:  http://physics.nist.gov/cuu/Constants/index.html)
  r <- 8.3144621 *10^(-3)
  
  if (length(timevec) != length(tempvec)) print("Incorrect input data!")
  
  tempvec <- tempvec + 273.15 # convert Celsius to degrees kelvin
  
  
  # Remove duplicates
  unq.times <- unique(timevec)
  if (length(timevec) != length(unq.times))
  {
    dup.times <- which(table(timevec)>1)
    for (i in 1:length(dup.times))
    {
      loc.dup <- which(as.character(timevec) == names(dup.times[i]))
      loc.avg <- mean(tempvec[loc.dup])
      tempvec[loc.dup[1]] <- loc.avg # replace duplicate temperatures with their arithmetic average
      timevec <- timevec[-loc.dup[-1]]
      tempvec <- tempvec[-loc.dup[-1]]
    }
  }
  
  #avg.boltzmann <- mean(timevec*exp(-ea/(r*tempvec)))/(timevec[length(timevec)]-timevec[1])
  
  
  n <- length(tempvec) - 1
  time.int <- timevec[length(timevec)] - timevec[1]
  
  avg.boltzmann1vec <- numeric(n)
  avg.boltzmann2vec <- numeric(n)
  for (i in 1:n)
  {
    # Trapezoidal rule for AUC.  Tong & Lock (2015)
    avg.boltzmann1vec[i] <- (timevec[i+1] - timevec[i])*(exp(-ea/(r*tempvec[i+1])) + exp(-ea/(r*tempvec[i])))
    
    # Wikipedia rule, approximating by using the forthcoming time interval for each time point.
    avg.boltzmann2vec[i] <- (timevec[i+1] - timevec[i])*exp(-ea/(r*tempvec[i]))
  }
  # avg.boltzmann2vec[n+1] <- timevec[n+1]*exp(-ea/(r*tempvec[n+1]))
  
  avg.boltzmann1 <- sum(avg.boltzmann1vec)/(2*time.int)
  avg.boltzmann2 <- sum(avg.boltzmann2vec)/time.int
  
  mkt1 <- -1*ea/(r*log(avg.boltzmann1))
  mkt2 <- -1*ea/(r*log(avg.boltzmann2))
  mkt1 <- mkt1 - 273.15 # convert to degrees Celsius
  mkt2 <- mkt2 - 273.15 # convert to degrees Celsius
  
  return(list(mkt1=round(mkt1,2),mkt2=round(mkt2,2)))
}


