app = angular.module("geniusApp")

app.factory "popoverTypesService", ($compile, $rootScope, Brick) ->
  type: (brickType) ->
    if brickType == 'AND'
      return angular.element '<form class="brick-form form-horizontal" role="form">
                                  <div class="form-group">
                                    <label for="K1" class="col-sm-2 control-label">K1</label>
                                    <div class="col-sm-10"><input type="number" class="form-control" id="K1" name="K1 (Complex binding)" placeholder="Complex binding"></div>
                                  </div>
                                  <div class="form-group">
                                    <label for="K2" class="col-sm-2 control-label">K2</label>
                                    <div class="col-sm-10"><input type="number" class="form-control" id="K2" name="K2 (Catalytic rate)" placeholder="Catalytic rate"></div>
                                  </div>
                                  <div class="form-group">
                                    <label for="K3" class="col-sm-2 control-label">K3</label>
                                    <div class="col-sm-10"><input type="number" class="form-control" id="K3" name="K3 (Complex decomposition)" placeholder="Complex decomposition"></div>
                                  </div>
                                  <div class="form-group">
                                    <label for="K4" class="col-sm-2 control-label">K4</label>
                                    <div class="col-sm-10"><input type="number" class="form-control" id="K4" name="K4 (Reverse catalytic rate)" placeholder="Reverse catalytic rate"></div>
                                  </div>
                                  <div class="form-group">
                                    <label for="Enzym" class="col-sm-2 control-label">E</label>
                                    <div class="col-sm-10"><input type="text" class="form-control" id="Enzym" name="Enzym" placeholder="Enzym"></div>
                                  </div>
                                  <div class="form-group">
                                    <label for="Substrate" class="col-sm-2 control-label">S</label>
                                    <div class="col-sm-10"><input type="text" class="form-control" id="Substrate" name="Substrate" placeholder="Substrate"></div>
                                  </div>
                                  <button type="submit" class="submit-button btn btn-block btn-primary">Save</button>
                                </form>'
    else if brickType == 'NOT'
      return angular.element '<form class="brick-form form-horizontal" role="form">
                                  <div class="form-group">
                                    <label for="K1" class="col-sm-2 control-label">K1</label>
                                    <div class="col-sm-10"><input type="number" class="form-control" id="K1" name="K1 (Complex binding)" placeholder="Complex binding"></div>
                                  </div>
                                  <div class="form-group">
                                    <label for="K2" class="col-sm-2 control-label">K2</label>
                                    <div class="col-sm-10"><input type="number" class="form-control" id="K2" name="K2 (Catalytic rate)" placeholder="Catalytic rate"></div>
                                  </div>
                                  <div class="form-group">
                                    <label for="K3" class="col-sm-2 control-label">K3</label>
                                    <div class="col-sm-10"><input type="number" class="form-control" id="K3" name="K3 (Complex decomposition)" placeholder="Complex decomposition"></div>
                                  </div>
                                  <div class="form-group">
                                    <label for="K4" class="col-sm-2 control-label">K4</label>
                                    <div class="col-sm-10"><input type="number" class="form-control" id="K4" name="K4 (Reverse catalytic rate)" placeholder="Reverse catalytic rate"></div>
                                  </div>
                                  <div class="form-group">
                                    <label for="Enzym" class="col-sm-2 control-label">E</label>
                                    <div class="col-sm-10"><input type="text" class="form-control" id="Enzym" name="Enzym" placeholder="Enzym"></div>
                                  </div>
                                  <div class="form-group">
                                    <label for="Substrate" class="col-sm-2 control-label">S</label>
                                    <div class="col-sm-10"><input type="text" class="form-control" id="Substrate" name="Substrate" placeholder="Substrate"></div>
                                  </div>
                                  <button type="submit" class="submit-button btn btn-block btn-primary">Save</button>
                                </form>'  
    else if brickType == 'OR' 
      return angular.element '<form class="brick-form form-horizontal" role="form">
                                  <div class="form-group">
                                    <label for="K1" class="col-sm-2 control-label">K1</label>
                                    <div class="col-sm-10"><input type="number" class="form-control" id="K1" name="K1 (Complex binding)" placeholder="Complex binding"></div>
                                  </div>
                                  <div class="form-group">
                                    <label for="K2" class="col-sm-2 control-label">K2</label>
                                    <div class="col-sm-10"><input type="number" class="form-control" id="K2" name="K2 (Catalytic rate)" placeholder="Catalytic rate"></div>
                                  </div>
                                  <div class="form-group">
                                    <label for="K3" class="col-sm-2 control-label">K3</label>
                                    <div class="col-sm-10"><input type="number" class="form-control" id="K3" name="K3 (Complex decomposition)" placeholder="Complex decomposition"></div>
                                  </div>
                                  <div class="form-group">
                                    <label for="K4" class="col-sm-2 control-label">K4</label>
                                    <div class="col-sm-10"><input type="number" class="form-control" id="K4" name="K4 (Reverse catalytic rate)" placeholder="Reverse catalytic rate"></div>
                                  </div>
                                  <div class="form-group">
                                    <label for="Enzym" class="col-sm-2 control-label">E</label>
                                    <div class="col-sm-10"><input type="text" class="form-control" id="Enzym" name="Enzym" placeholder="Enzym"></div>
                                  </div>
                                  <div class="form-group">
                                    <label for="Substrate" class="col-sm-2 control-label">S</label>
                                    <div class="col-sm-10"><input type="text" class="form-control" id="Substrate" name="Substrate" placeholder="Substrate"></div>
                                  </div>
                                  <button type="submit" class="submit-button btn btn-block btn-primary">Save</button>
                                </form>'
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