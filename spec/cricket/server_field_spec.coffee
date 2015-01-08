requirejs = require('../spec_helper').requirejs
io = require('../stubs/socket.io').io

module_mock = require('../stubs/module_mock')
module_mock.reset(requirejs)

field = {}
data =
  distance: null
  slot: null

become_server_field = requirejs('cricket/server_field')
Terms = requirejs('cricket/terms')

describe "a server field", ->
  beforeEach ->
    field = {}
    become_server_field(field)
    field.update_slips_count = jasmine.createSpy('update_slips_count')

  describe "toggle outfielder", ->
    it "should toggle the outfield position specified", ->
      expect(field.has_fielder_in_spot(Terms.Distance.outfield, Terms.Shots.leg_glance)).toBeFalsy()
      field.toggle_outfielder(Terms.Shots.leg_glance)
      expect(field.has_fielder_in_spot(Terms.Distance.outfield, Terms.Shots.leg_glance)).toBeTruthy()
      field.toggle_outfielder(Terms.Shots.leg_glance)
      expect(field.has_fielder_in_spot(Terms.Distance.outfield, Terms.Shots.leg_glance)).toBeFalsy()

    it "should update the slips count", ->
      field.toggle_outfielder(Terms.Shots.leg_glance)
      expect(field.update_slips_count).toHaveBeenCalled()

  describe "toggle infielder", ->
    it "should toggle the infield position specified", ->
      expect(field.has_fielder_in_spot(Terms.Distance.infield, Terms.Shots.leg_glance)).toBeFalsy()
      field.toggle_infielder(Terms.Shots.leg_glance)
      expect(field.has_fielder_in_spot(Terms.Distance.infield, Terms.Shots.leg_glance)).toBeTruthy()
      field.toggle_infielder(Terms.Shots.leg_glance)
      expect(field.has_fielder_in_spot(Terms.Distance.infield, Terms.Shots.leg_glance)).toBeFalsy()

    it "should update the slips count", ->
      field.toggle_infielder(Terms.Shots.leg_glance)
      expect(field.update_slips_count).toHaveBeenCalled()

  describe "set infielder", ->
    beforeEach ->
      field.set_infielder(Terms.Shots.leg_glance)

    it "should set the infield position specified", ->
      expect(field.has_fielder_in_spot(Terms.Distance.infield, Terms.Shots.leg_glance)).toBeTruthy()

    it "should update the slips count", ->
      expect(field.update_slips_count).toHaveBeenCalled()

  describe "set outfielder", ->
    beforeEach ->
      field.set_outfielder(Terms.Shots.leg_glance)

    it "should set the outfield position specified", ->
      expect(field.has_fielder_in_spot(Terms.Distance.outfield, Terms.Shots.leg_glance)).toBeTruthy()

    it "should update the slips count", ->
      expect(field.update_slips_count).toHaveBeenCalled()

  describe "clear infielder", ->
    beforeEach ->
      field.set_infielder(Terms.Shots.leg_glance)
      field.clear_infielder(Terms.Shots.leg_glance)

    it "should clear the infield position specified", ->
      expect(field.has_fielder_in_spot(Terms.Distance.infield, Terms.Shots.leg_glance)).toBeFalsy()

    it "should update the slips count", ->
      field.clear_infielder(Terms.Shots.leg_glance)
      expect(field.update_slips_count).toHaveBeenCalled()

  describe "clear outfielder", ->
    beforeEach ->
      field.set_outfielder(Terms.Shots.leg_glance)
      field.clear_outfielder(Terms.Shots.leg_glance)

    it "should clearn the outfield position specified", ->
      expect(field.has_fielder_in_spot(Terms.Distance.outfield, Terms.Shots.leg_glance)).toBeFalsy()

    it "should update the slips count", ->
      expect(field.update_slips_count).toHaveBeenCalled()

  describe "reset", ->
    beforeEach ->
      field.set_infielder(shot) for own shot of Terms.Shots when shot isnt Terms.Shots.block
      field.set_outfielder(shot) for own shot of Terms.Shots when shot isnt Terms.Shots.block

      for position in field.infield
        expect(position.has_fielder).toBeTruthy()

      for position in field.outfield
        expect(position.has_fielder).toBeTruthy()

      field.reset()

    it "should reset the field", ->
      for position in field.infield
        expect(position.has_fielder).toBeFalsy()

      for position in field.outfield
        expect(position.has_fielder).toBeFalsy()

    it "should update the slips count", ->
      expect(field.update_slips_count).toHaveBeenCalled()

  describe "set fielder", ->
    beforeEach ->
      expect(field.has_fielder_in_spot(Terms.Distance.infield, Terms.Shots.leg_glance)).toBeFalsy()
      field.set_fielder(field.infield, Terms.Shots.leg_glance)

    it "should set the fielding position", ->
      expect(field.has_fielder_in_spot(Terms.Distance.infield, Terms.Shots.leg_glance)).toBeTruthy()

    it "should update the slips count", ->
      expect(field.update_slips_count).toHaveBeenCalled()

  describe "clear fielder", ->
    beforeEach ->
      field.set_infielder(Terms.Shots.leg_glance)
      field.set_outfielder(Terms.Shots.leg_glance)
      field.clear_fielder(field.infield, Terms.Shots.leg_glance)
      field.clear_fielder(field.outfield, Terms.Shots.leg_glance)

    it "should remove any fielder in a position", ->
      expect(field.has_fielder_in_spot(Terms.Distance.infield, Terms.Shots.leg_glance)).toBeFalsy()
      expect(field.has_fielder_in_spot(Terms.Distance.outfield, Terms.Shots.leg_glance)).toBeFalsy()

    it "should update the slips count", ->
      expect(field.update_slips_count).toHaveBeenCalled()