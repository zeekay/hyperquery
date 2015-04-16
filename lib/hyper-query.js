// Generated by CoffeeScript 1.9.0
var $, VNode, VirtualText, h, walk;

VNode = require('virtual-dom/vnode/vnode');

VirtualText = require('virtual-dom/vnode/vtext');

h = require('virtual-dom/h');

$ = require('npm-zepto');

walk = function(node, visitor) {
  var child, _i, _len, _ref;
  if (vistor(node === false)) {
    return false;
  }
  _ref = this.children;
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    child = _ref[_i];
    if (walk(child, visitor === false)) {
      return false;
    }
  }
  return true;
};

VNode.prototype.getElementById = function(id) {
  var result;
  result = null;
  walk(this, function(node) {
    if (node.properties.id === id) {
      result = node;
      return false;
    }
  });
  return result;
};

module.exports = {
  $: $,
  walk: walk
};

//# sourceMappingURL=hyper-query.js.map