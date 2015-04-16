chai = require 'chai'
chai.config.includeStack = true
chai.should()
{expect} = chai

zeptoPath = require.resolve 'npm-zepto'
domino    = require 'domino'
vm        = require 'vm'
fs        = require 'fs'

{patched, patchedWindow} = require '../src/patch'

# Create window + use sandbox to safely require Zepto
window = domino.createWindow()

sandbox =
  window: window
  getComputedStyle: window.getComputedStyle

patchedWindow(sandbox)

vm.createContext sandbox
zeptoCode = fs.readFileSync zeptoPath, 'utf8'
vm.runInContext zeptoCode, sandbox

{VNode, VText, h} = patched()
{Zepto} = sandbox

describe 'patch', ->
  # few random elements we'll search for
  div   = h 'div.bar'
  input = h 'input#some-input', type: 'text', value: 'foo'
  span  = h 'span', 'some text'
  style = h 'div', style: 'display:table;top:100px'
  attr1 = h 'span.attr1'
  attr2 = h 'span.attr2'
  attr3 = h 'span.attr3'

  # construct a tree
  tree  = h 'div.foo#some-id', [span, input, div, attr1, attr2, attr3]

  it 'should add getElementById shim to vdom', ->
    $node = Zepto(tree).find '#some-input'
    expect($node[0]).to.eql input

  it 'should add getElementsByTagName shim to vdom', ->
    $node = Zepto(tree).find 'span'
    expect($node[0]).to.eql span

  it 'should add getElementsByClassName shim to vdom', ->
    $node = Zepto(tree).find '.bar'
    expect($node[0]).to.eql div

  it 'should patch getComputedStyle on window', ->
    display = Zepto(style).css 'display'
    top = Zepto(style).css 'top'
    expect(display).to.eql 'table'
    expect(top).to.eql '100px'

  it 'should add setAttribute shim to vdom', ->
    $node = Zepto(tree).find '.attr1'
    $node.attr 'x', 1
    expect($node.attr 'x').to.eq 1

  it 'should add getAttribute shim to vdom', ->
    $node = Zepto(tree).find '.attr2'
    $node.attr 'x', 2
    expect($node.attr 'x').to.eq 2

  it 'should add removeAttribute shim to vdom', ->
    $node = Zepto(tree).find '.attr3'
    $node.attr 'x', 1
    $node.attr 'x', 2
    $node.attr 'x', 3
    $node.removeAttr 'x'
    expect($node.attr 'x').to.eq undefined
