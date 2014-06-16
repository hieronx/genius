app = angular.module("geniusApp")

app.factory "popoverTypesService", ($compile, $rootScope) ->
  type: (gate) ->
    gate = gate.toUpperCase()
    if gate == 'AND'
      return angular.element '<dl class="dl-horizontal">
                                <dt>K1 Tfactor</dt>
                                  <dd>Example k1</dd>
                                <dt>Gene 1 K2</dt>
                                  <dd>Example k2</dd>
                                <dt>Gene 1 D1</dt>
                                  <dd>Example d1</dd>
                                <dt>Gene 1 D2</dt>
                                  <dd>Example d2</dd>
                                <dt>Gene 2 K2</dt>
                                  <dd>Example k2</dd>
                                <dt>Gene 2 D1</dt>
                                  <dd>Example d1</dd>
                                <dt>Gene 2 D2</dt>
                                  <dd>Example d2</dd>
                                <dt>Km</dt>
                                  <dd>Example km</dd>
                                <dt>N</dt>
                                  <dd>Example n</dd>
                              </dl>'
    else if gate == 'NOT'
      return angular.element '<dl class="dl-horizontal">
                                <dt>K1 Tfactor</dt>
                                  <dd>Example k1</dd>
                                <dt>Gene 1 K2</dt>
                                  <dd>Example k2</dd>
                                <dt>Gene 1 D1</dt>
                                  <dd>Example d1</dd>
                                <dt>Gene 1 D2</dt>
                                  <dd>Example d2</dd>
                                <dt>Km</dt>
                                  <dd>Example km</dd>
                                <dt>N</dt>
                                  <dd>Example n</dd>
                              </dl>'
    else if gate == 'INPUT'
      return angular.element '<select class="form-control">
                                <option selected disabled></option>
                                <option value="Gene A">Gene A</option>
                                <option value="Gene B">Gene B</option>
                                <option value="Gene C">Gene C</option>
                                <option value="Gene D">Gene D</option>
                                <option value="Gene E">Gene E</option>
                                <option value="Gene F">Gene F</option>
                                <option value="Gene G">Gene G</option>
                                <option value="Gene H">Gene H</option>
                                <option value="Gene I">Gene I</option>
                                <option value="Gene J">Gene J</option>
                              </select>'
    else if gate == 'OUTPUT'
      return angular.element '<dl class="dl-horizontal">
                                <dt>Protein</dt>
                                  <dd>Ex. protein</dd>
                              </dl>'
