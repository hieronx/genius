app = angular.module("geniusApp")

app.factory "importCSV", ($compile, $rootScope, $http, CSVToArray) ->
  storeGenes = ->
    $url = "public/files/biobricks/cds.csv"
    $http.get($url).then((response) ->
      $arr = CSVToArray.execute response.data
      for cd in $arr
        $gene = {}
        if cd[0] isnt 'Gene' && cd[0] isnt ''
          $gene['name'] = cd[0]
          $gene['k_2'] = cd[1]
          $gene['d_1'] = cd[2]
          $gene['d_2'] = cd[3]
          Gene.create($gene)
    )

  storeAndPromoters = ->
    $url = 'public/files/biobricks/and.csv'
    $http.get($url).then((response) ->
      $arr = CSVToArray.execute response.data
      for prom in $arr
        $andProm = {}
        if prom[0] isnt 'TF_1' && prom[0] isnt ''
          $andProm['tf_1'] = prom[0]
          $andProm['tf_2'] = prom[1]
          $andProm['k_1'] = prom[2]
          $andProm['t_m'] = prom[3]
          $andProm['n'] = prom[4]
          AndPromoter.create($andProm)
    )

  storeNotPromoters = ->
    $url = 'public/files/biobricks/not.csv'
    $http.get($url).then((response) ->
      $arr = CSVToArray.execute response.data
      for prom in $arr
        $notProm = {}
        if prom[0] isnt 'TF' && prom[0] isnt ''
          $notProm['tf'] = prom[0]
          $notProm['k_1'] = prom[1]
          $notProm['k_m'] = prom[2]
          $notProm['n'] = prom[3]
          NotPromoter.create($notProm)
    )

  # Handle the importing of biobricks from the csv files
  storeBiobricks: ->
    Gene.all (data) ->
      if data.length is 0
        storeGenes()

    AndPromoter.all (data) ->
      if data.length is 0
        storeAndPromoters()

    NotPromoter.all (data) ->
      if data.length is 0
        storeNotPromoters()


