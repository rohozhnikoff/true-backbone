$( ->
  #-----------Init------------
  PXCMSenseManager_CreateInstance().then((result) ->
    window.sense = result
    sense.EnableFace(onFaceData)
  ).then((result) ->
    result.CreateActiveConfiguration();
  ).then((result) ->
    window.faceConf = result
    faceConf.configs.pose.isEnabled = true
    faceConf.SetTrackingMode(1);
  ).then((result) ->
    faceConf.ApplyChanges()
  ).then((result) ->
    do prepare
    sense.Init(null,onStatus)
  ).then((result) ->
    sense.QueryCaptureManager()
  ).then((capture) ->
    console.log('image size', pxcmConst.PXCMCapture.STREAM_TYPE_COLOR)
    capture.QueryImageSize(pxcmConst.PXCMCapture.STREAM_TYPE_COLOR);
  ).then((result) ->
    imageSize = result.size;
    sense.StreamFrames();
  ).then((result) ->
    console.log('Streaming ' + imageSize.width + 'x' + imageSize.height);
  ).catch((error) ->
    console.log('error: ', error)
  )
  #-------------------Logic------
  readyBtn = $('.js-btnReady')
  stopBtn = $('.js-btnStop')
  header = $('h1')
  status = $('h2')
  capturing = false
  basePosition = {}

  onFaceData = (a,b, data)->
    face = data.faces[0]?.pose
    return unless face?
    if not _.isEmpty(basePosition)
      dZ = basePosition.headPosition.headCenter.z - face.headPosition.headCenter.z
      if dZ > 20
        status.text('Надто нахилились, випрямтесь!')
      else if dZ < -20
        status.text('Сильно відхилились, сядьте рівно')
      else
        status.text('Чудово, Ви сидите рівно')


    if capturing
      basePosition = face
      capturing = false
      console.log(basePosition)
      status.text('Базова позиція зафіксована')


  onStatus = ->
    console.log('on Status: ', arguments)

  prepare = ->
    header.text('Сядьте рівно, розслабтесь, дивіться на екран та натсніть кнопку')
    readyBtn.css({display: 'block'})

  stopBtn.click( ->
    sense.Close().then((result) ->
      status('Stopped');
      clear();
    )
  )

  readyBtn.click( ->
    console.log('yep')
    capturing = true
  )



)