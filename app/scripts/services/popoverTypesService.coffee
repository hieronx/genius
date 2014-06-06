app = angular.module("geniusApp")

app.factory "popoverTypesService", ($compile, $rootScope, Brick) ->
  type: (brickType) ->
    if brickType == 'AND'
      return angular.element '<dl class="dl-horizontal">
                                <dt>Gene 1 K1</dt>
                                  <dd>Example k1</dd>
                                <dt>Gene 1 K2</dt>
                                  <dd>Example k2</dd>
                                <dt>Gene 2 K1</dt>
                                  <dd>Example k1</dd>
                                <dt>Gene 1 D1</dt>
                                  <dd>Example d1</dd>
                                <dt>Gene 1 D2</dt>
                                  <dd>Example d2</dd>
                                <dt>Gene 2 D1</dt>
                                  <dd>Example d1</dd>
                                <dt>Gene 2 D2</dt>
                                  <dd>Example d2</dd>
                                <dt>Km</dt>
                                  <dd>Example km</dd>
                                <dt>N</dt>
                                  <dd>Example n</dd>
                              </dl>'
    else if brickType == 'NOT'
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
    else if brickType == 'INPUT'
      return angular.element '<form class="brick-form form-horizontal" role="form">
                                  <div class="form-group">
                                    <label for="Input" class="col-sm-2 control-label">I</label>
                                    <div class="col-sm-6"><input type="text" class="form-control" id="Input" name="Input" placeholder="Input"></div>
                                    <div class="col-sm-4"><input type="number" class="form-control" id="Input-value" name="Input-value" placeholder="0"></div>
                                  </div>
                                  <button type="submit" class="submit-button btn btn-block btn-primary">Save</button>
                                </form>'            
    else if brickType == 'OUTPUT' 
      return angular.element '<form class="brick-form form-horizontal" role="form">
                                  <div class="form-group">
                                    <label for="Ouput" class="col-sm-2 control-label">O</label>
                                    <div class="col-sm-10"><input type="text" class="form-control" id="Ouput" name="Ouput" placeholder="Ouput"></div>
                                  </div>
                                  <button type="submit" class="submit-button btn btn-block btn-primary">Save</button>
                                </form>'