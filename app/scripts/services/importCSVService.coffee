app = angular.module("geniusApp")

app.factory "importCSV", ($compile, $rootScope, $http, CSVToArray, Gene) ->
	getCDs: () ->
    $url = "public/files/biobricks/cds.csv"
    $items = $http.get($url).then((response) ->
      $arr = CSVToArray.execute response.data
      for cd in $arr
      	$gene = {}
      	if cd[0] isnt 'Gene' && cd[0] isnt ''
      		$gene['name'] = cd[0]
      		$gene['k_2'] = cd[1]
      		$gene['d_1'] = cd[2]
      		$gene['d_2'] = cd[3]
      		Gene.add($gene).done (newGene) ->
      			console.log newGene
    )

	getAND: () ->


	getOR: () ->