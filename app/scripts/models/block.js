'use strict'

angular.module('geniusApp').factory('Block', function(_) {
  var Block = {};
  var type = 'block';

  var defer = hoodie.defer();
  
  // promise.then(function(data){ defer.resolve(data.doneData); });
  // promise.fail(function(data){ defer.reject(); });

  Block.all = function() {
    hoodie.store.findAll(type)
      .done(function (blocks) {
        defer.resolve(blocks);
      });
    return defer.promise();
  }
  
  Block.find = function(index) {
    hoodie.store.find(type, index)
      .done(function (block) {
        defer.resolve(block);
      });
    return defer.promise();
  }

  Block.where = function(properties) {
    hoodie.store.findAll(type)
      .done(function (blocks) {
        defer.resolve(_.where(blocks, properties));
      });
    return defer.promise();
  }

  Block.add = function(attributes) {
    hoodie.store.add(type, attributes)
      .done(function (newBlock) {
        defer.resolve(newBlock);
      });
    return defer.promise();
  }

  Block.destroy = function(index) {
    hoodie.store.remove(type, index)
      .done(function (removedObject) {
        defer.resolve(removedObject);
      });
    return defer.promise();
  }

  Block.size = function() {
    hoodie.store.findAll(type)
      .done(function (blocks) {
        defer.resolve(blocks.length);
      });
    return defer.promise();
  }

  _.forEach(_, function(func, name) {
    Block[name] = function() {
      var args = Array.prototype.slice.call(arguments, 0);
      hoodie.store.findAll(type).done(function (blocks) {
        args.unshift(blocks);
        defer.resolve(func(args));
      });
    }
    return defer.promise();
  })

  return Block;
});