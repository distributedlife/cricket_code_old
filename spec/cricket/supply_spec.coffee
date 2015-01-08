requirejs = require('../spec_helper').requirejs

module_mock = require('../stubs/module_mock')
module_mock.reset(requirejs)

supply = {}

become_supply = requirejs('cricket/supply')

describe 'the supply', ->
  beforeEach ->
    supply = {}
    become_supply(supply)

  it 'should define each deck', ->
    expect(supply.full_deck).not.toBe(undefined)
    expect(supply.good_deck).not.toBe(undefined)
    expect(supply.short_deck).not.toBe(undefined)
    expect(supply.bouncer_yorker_deck).not.toBe(undefined)
    expect(supply.chance_your_arm_deck).not.toBe(undefined)
