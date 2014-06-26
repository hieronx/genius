app = angular.module("geniusApp")

app.factory "exportService", ($compile, $rootScope) ->

  run: (position) ->
    formatXml = (xml) ->
      formatted = ""
      reg = /(>)(<)(\/*)/g
      xml = xml.replace(reg, "$1\r\n$2$3")
      pad = 0
      jQuery.each xml.split("\r\n"), (index, node) ->
        indent = 0
        if node.match(/.+<\/\w[^>]*>$/)
          indent = 0
        else if node.match(/^<\/\w/)
          pad -= 1  unless pad is 0
        else if node.match(/^<\w[^>]*[^\/]>.*$/)
          indent = 1
        else
          indent = 0
        padding = ""
        i = 0

        while i < pad
          padding += "  "
          i++
        formatted += padding + node + "\r\n"
        pad += indent
        return

      formatted

    if position.get('gate') is 'output'
      # creating the document
      xmlDeclaration = '<?xml version="1.0" encoding="UTF-8"?>'
      doc = document.implementation.createDocument('http://www.sbml.org/sbml/level1', 'sbml', null)
      model = doc.createElement('model')

      # adding list of compartments
      listOfCompartments = doc.createElement('listOfCompartments')

      compartment = doc.createElement('compartment')
      compartment.setAttribute('name', 'Cyt')
      compartment.setAttribute('volume', 1.5)
      listOfCompartments.appendChild(compartment)

      # adding list of parameters
      listOfParameters = doc.createElement('listOfParameters')

      addParameter = (index, key, value) =>
        parameter = doc.createElement('parameter')

        if typeof value is 'undefined'
          value = 'NaN'

        # parameter.setAttribute('name', key)
        parameter.setAttribute('name', 'p' + index + '_' + key)
        parameter.setAttribute('value', value)

        listOfParameters.appendChild(parameter)

      # adding list of parameters
      listOfSpecies = doc.createElement('listOfSpecies')

      addSpecies = (index, name, compartment) =>
        species = doc.createElement('species')

        species.setAttribute('name', 's' + index + '_' + name)
        species.setAttribute('compartment', 'Cyt')
        species.setAttribute('initialAmount', 0)

        listOfSpecies.appendChild(species)

      # adding list of reactions
      listOfReactions = doc.createElement('listOfReactions')

      addReaction = (index, type, gate, reactant, product, formula) =>
        reaction = doc.createElement('reaction')

        # reaction.setAttribute('name', gate + ' gate')
        reaction.setAttribute('name', 'r' + index + '_' + type + '_' + gate)
        reaction.setAttribute('reversible', false)

        listOfReactants = doc.createElement('listOfReactants')
        speciesReference = doc.createElement('speciesReference')
        speciesReference.setAttribute('species', 's' + index + '_' + reactant)
        listOfReactants.appendChild(speciesReference)
        reaction.appendChild(listOfReactants)

        listOfProducts = doc.createElement('listOfProducts')
        speciesReference = doc.createElement('speciesReference')
        speciesReference.setAttribute('species', 's' + index + '_' + product)
        listOfProducts.appendChild(speciesReference)
        reaction.appendChild(listOfProducts)

        kineticLaw = doc.createElement('kineticLaw')
        kineticLaw.setAttribute('formula', formula)
        reaction.appendChild(kineticLaw)

        listOfReactions.appendChild(reaction)
      
      for index in [0..$rootScope.currentBrick.positions.size() * 2] by 2
        addSpecies(index, 'nMRA')
        addSpecies(index, 'Protein')

      i = 0
      structureQueue = []
      x = []

      queue = new PriorityQueue(comparator: (a, b) -> b.comp - a.comp)
      list = Array.apply(null, new Array(101)).map(Number.prototype.valueOf,0)

      # Define structure of simulations 
      structureQueue.push({ position: position.incoming_connections.first().position_from, output: -1  }) # placeholder

      while structureQueue.length > 0
        tempPosition = structureQueue.pop()
        list[i] = tempPosition.output

        if tempPosition.position.get('gate') is 'and'
          # For every input of brick-and
          queue.queue { position: tempPosition.position, comp: i, output: tempPosition.output }

          tempPosition.position.incoming_connections.each (connection) =>
            structureQueue.push( { position: connection.position_from, comp: i, output: tempPosition.output } )

        # Current brick is of type not
        else if tempPosition.position.get('gate') is 'not'
          queue.queue( { position: tempPosition.position, comp: i, output: tempPosition.output } )
          structureQueue.push( { position: tempPosition.position.incoming_connections.first().position_from, comp: i, output: tempPosition.output } )

        else 
          queue.queue( { position: tempPosition.position, comp: i, output: tempPosition.output } )

        # If brick is not of type not or and, it is an input and this is where the loop should end
        i += 2

      equations = []
      startIndex = queue.peek().comp # array index

      while queue.length > 0
        equationPosition = queue.dequeue()
        currentPosition = equationPosition.position

        # Check whether array element is defined
        index = startIndex - equationPosition.comp
        x[index] ||= 0
        x[index+1] ||= 0

        # All k variables have to come from predefined gene k variables
        if currentPosition.get('gate') is 'and'
          input1 = startIndex - list.indexOf(equationPosition.comp)
          input2 = startIndex - list.lastIndexOf(equationPosition.comp)

          currentGene1 = _.filter(Gene.all().collection, (gene) ->
            return currentPosition.incoming_connections.first().attributes.selected is gene.attributes.name)[0]

          currentGene2 = _.filter(Gene.all().collection, (gene) ->
            return currentPosition.incoming_connections.last().attributes.selected is gene.attributes.name)[0]

          currentGate = _.filter(AndPromoter.all().collection, (gate) ->
            return ( (currentPosition.incoming_connections.first().attributes.selected is gate.attributes.tf_1 and currentPosition.incoming_connections.last().attributes.selected is gate.attributes.tf_2) or (currentPosition.incoming_connections.first().attributes.selected is gate.attributes.tf_2 and currentPosition.incoming_connections.last().attributes.selected is gate.attributes.tf_1))  )[0]

          ### parameters ###
          k1 = currentGate.attributes.k_1
          km = currentGate.attributes.k_m
          n = currentGate.attributes.n

          addParameter(index, 'k1', k1)
          addParameter(index, 'km', km)
          addParameter(index, 'n', n)

          gene1_d1 = currentGene1.attributes.d_1
          gene1_d2 = currentGene1.attributes.d_2
          gene1_k2 = currentGene1.attributes.k_2
          gene2_d1 = currentGene2.attributes.d_1
          gene2_d2 = currentGene2.attributes.d_2
          gene2_k2 = currentGene2.attributes.k_2

          addParameter(index, 'gene1_d1', gene1_d1)
          addParameter(index, 'gene1_d2', gene1_d2)
          addParameter(index, 'gene1_k2', gene1_k2)
          addParameter(index, 'gene2_d1', gene2_d1)
          addParameter(index, 'gene2_d2', gene2_d2)
          addParameter(index, 'gene2_k2', gene2_k2)

          ### reactions ###
          equations.push( ( k1 * (x[input1 + 1] * x[input2 + 1])^n ) / ( km^n + (x[input1 + 1] * x[input2 + 1])^n ) - gene1_d1 * x[index] )
          equations.push( gene2_k2 * x[index] - gene2_d2 * x[index+1] )

          addReaction(index, 'transcription', 'and', 'nMRA', 'nMRA', '( p' + index + '_k1 * (s' + ( input1 + 1 ) + '_Protein * s' + ( input2 + 1 ) + '_Protein)^p' + index + '_n ) / ( p' + index + '_km^p' + index + '_n + (s' + ( input1 + 1 ) + '_Protein * s' + ( input2 + 1 ) + '_Protein)^p' + index + '_n ) - p' + index + '_gene1_d1 * s' + ( index - 2 ) + '_nMRA')

          addReaction(index, 'translation', 'and', 'nMRA', 'Protein', 'p' + index + '_gene2_k2 * s' + index + '_nMRA - p' + index + '_gene2_d2 * s' + index + '_Protein')

        else if currentPosition.get('gate') is 'not'
          currentGene = _.filter(Gene.all().collection, (gene) ->
            return currentPosition.incoming_connections.first().attributes.selected is gene.attributes.name)[0]

          currentGate = _.filter(NotPromoter.all().collection, (gate) ->
            return currentPosition.incoming_connections.first().attributes.selected is gate.attributes.tf)[0]

          ### parameters ###
          k1 = currentGate.attributes.k_1
          km = currentGate.attributes.k_m
          n = currentGate.attributes.n

          addParameter(index, 'k1', k1)
          addParameter(index, 'km', km)
          addParameter(index, 'n', n)

          gene1_d1 = currentGene.attributes.d_1
          gene1_d2 = currentGene.attributes.d_2
          gene1_k2 = currentGene.attributes.k_2

          addParameter(index, 'gene1_d1', gene1_d1)
          addParameter(index, 'gene1_d2', gene1_d2)
          addParameter(index, 'gene1_k2', gene1_k2)

          input1 = startIndex - list.indexOf(equationPosition.comp)

          ### reactions ###
          equations.push( ( k1 * km^n ) / ( km^n + x[input1 + 1]^n ) - gene1_d1 * x[index] )
          equations.push( gene1_k2 * x[index] - gene1_d2 * x[index+1] )

          addReaction(index, 'transcription', 'not', 'nMRA', 'nMRA', '( p' + index + '_k1 * p' + index + '_km^p' + index + '_n ) / ( p' + index + '_km^p' + index + '_n + s' + ( input1 + 1 ) + '_Protein^p' + index + '_n ) - p' + index + '_gene1_d1 * s' + index + '_nMRA')

          addReaction(index, 'translation', 'not', 'nMRA', 'Protein', 'p' + index + '_gene1_k2 * s' + index + '_nMRA - p' + index + '_gene1_d2 * s' + index + '_Protein')

        else if currentPosition.get('gate') is 'input'
          currentGene = _.filter(Gene.all().collection, (gene) ->
            return currentPosition.outgoing_connections.first().attributes.selected is gene.attributes.name)[0]

          ### parameters ###
          gene1_d1 = currentGene.attributes.d_1
          gene1_d2 = currentGene.attributes.d_2
          gene1_k2 = currentGene.attributes.k_2

          addParameter(index, 'gene1_d1', gene1_d1)
          addParameter(index, 'gene1_d2', gene1_d2)
          addParameter(index, 'gene1_k2', gene1_k2)

          ### reactions ###
          equations.push( 1 - gene1_d1 * x[index] )
          equations.push( gene1_k2 * x[index] - gene1_d2 * x[index+1] )

          addReaction(index, 'transcription', 'input', 'nMRA', 'nMRA', '1 - p' + index + '_gene1_d1 * s' + index + '_nMRA')
          addReaction(index, 'translation', 'input', 'nMRA', 'Protein', 'p' + index + '_gene1_k2 * s' + index + '_nMRA - p' + index + '_gene1_d2 * s' + index + '_Protein')

      model.appendChild(listOfCompartments)
      model.appendChild(listOfSpecies)
      model.appendChild(listOfParameters)
      model.appendChild(listOfReactions)

      model.setAttribute('name', 'gene_network_model')

      # save and export document
      doc.documentElement.appendChild(model)

      xml = xmlDeclaration + new XMLSerializer().serializeToString(doc)
      xml = xml.replace('<sbml xmlns="http://www.sbml.org/sbml/level1">', '<sbml xmlns="http://www.sbml.org/sbml/level1" level="1" version="2">')

      console.log formatXml(xml)

      blob = new Blob [formatXml(xml)], { type: 'attachment/xml;charset=utf-8;' }

      if typeof $rootScope.currentBrick.attributes.title is 'undefined'
        saveAs(blob, 'unnamed.sbml')

      else
        saveAs(blob, $rootScope.currentBrick.attributes.title + '.sbml')


