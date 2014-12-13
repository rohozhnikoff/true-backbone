class @Head
  #====Public =============
  constructor: (pose) ->
    @[key] = val for key, val of pose

  toClose: (pose) ->
    diff = @headPosition.headCenter.z - pose.headPosition.headCenter.z
    return diff > maxClose

  toFar: (pose) ->
    diff = @headPosition.headCenter.z - pose.headPosition.headCenter.z
    return diff < maxBack

  chechIncline: (pose) ->
    {pitch, roll, yaw} = pose.poseAngles
    #pitch - up/down
    #yaw - left/right
    #roll - around Oz axis
    console.log(@.poseAngles.pitch - pitch)

  checkDistance: (pose) ->
    status = if @toFar(pose) then 'far'
    else if @toClose(pose) then 'close'
    else 'ok'

    message = measureTime(status) or "You started seating #{status}"
    return message

  #====Private ============
  maxClose = 100
  maxBack = -100
  maxTimeForBadPosition = 2000

  currentPositionStatus = 'ok'
  startTime = Date.now()

  measureTime = (status) ->
    if currentPositionStatus isnt status
      startTime = Date.now()
      currentPositionStatus = status

    seatingTime = Date.now() - startTime
    message = ''
    if status isnt 'ok' and seatingTime > maxTimeForBadPosition
      message = "Ups, you to #{status} for #{Math.floor(seatingTime/1000)} seconds"

    return message




