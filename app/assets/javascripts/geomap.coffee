$ ->

  $.ajax({
    url:"/hitchhikers/#{username}/geomap.json"
    dataType:"json"
    async: true
    success: (data) ->

      console.log( data )
      $('#world-map').vectorMap({
        map: 'world_mill_en'
        backgroundColor: '#FFFFFF'
        regionStyle:
          initial: {
            fill: '#CCCCCC',
            "fill-opacity": 1,
            stroke: 'none',
            "stroke-width": 0,
            "stroke-opacity": 1
          },
          hover: {
            "fill-opacity": 0.8
          }

        series:
          regions: [{
            values: data,
            scale: ['#C8EEFF', '#0071A4'],
            normalizeFunction: 'polynomial'
          }]

        onRegionLabelShow: (event, label, code) ->
          if data[code] != undefined
            label.html("#{label.html()} - #{data[code]} kms")
      })

  })

