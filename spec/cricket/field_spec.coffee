requirejs = require('../spec_helper').requirejs

module_mock = require('../stubs/module_mock')
module_mock.reset(requirejs)

field = {}

become_field = requirejs('cricket/field')
Terms = requirejs('cricket/terms')

describe "a field", ->
  beforeEach ->
    field = {}
    become_field(field)

  describe "setting up the field", ->
    it "should set each field position to false", ->
      for position in field.infield
        expect(position.has_fielder).toBeFalsy()

      for position in field.outfield
        expect(position.has_fielder).toBeFalsy()

    it "should set the slips to zero", ->
      expect(field.slips).toBe(0)

  describe "infielders", ->
    it "should return the fielders in the infield", ->
      expect(field.infielders()).toEqual([])
      field.filter_by_position_name(field.infield, Terms.Shots.leg_glance)[0].has_fielder = true
      expect(field.infielders()).toEqual([{name: 'leg_glance', has_fielder: true}])
      field.filter_by_position_name(field.outfield, Terms.Shots.leg_glance)[0].has_fielder = true
      expect(field.infielders()).toEqual([{name: 'leg_glance', has_fielder: true}])

  describe "outfielders", ->
    it "should return the fielders in the outfield", ->
      expect(field.outfielders()).toEqual({})
      field.filter_by_position_name(field.outfield, Terms.Shots.leg_glance)[0].has_fielder = true
      expect(field.outfielders()).toEqual([{name: 'leg_glance', has_fielder: true}])
      field.filter_by_position_name(field.infield, Terms.Shots.leg_glance)[0].has_fielder = true
      expect(field.outfielders()).toEqual([{name: 'leg_glance', has_fielder: true}])

  describe "has fielder in spot", ->
    it "should return true if fielder is in the spot", ->
      expect(field.has_fielder_in_spot(Terms.Distance.infield, Terms.Shots.leg_glance)).toBeFalsy()

      field.filter_by_position_name(field.outfield, Terms.Shots.leg_glance)[0].has_fielder = true
      expect(field.has_fielder_in_spot(Terms.Distance.infield, Terms.Shots.leg_glance)).toBeFalsy()

      field.filter_by_position_name(field.infield, Terms.Shots.leg_glance)[0].has_fielder = true
      expect(field.has_fielder_in_spot(Terms.Distance.infield, Terms.Shots.leg_glance)).toBeTruthy()

  describe "has fielder in slice", ->
    it "should return true if fielder is anywhere in the slice", ->
      expect(field.has_fielder_in_slice(Terms.Shots.leg_glance)).toBeFalsy()

      field.filter_by_position_name(field.outfield, Terms.Shots.leg_glance)[0].has_fielder = true
      expect(field.has_fielder_in_slice(Terms.Shots.leg_glance)).toBeTruthy()

      field.filter_by_position_name(field.infield, Terms.Shots.leg_glance)[0].has_fielder = true
      field.filter_by_position_name(field.outfield, Terms.Shots.leg_glance)[0].has_fielder = false
      field.outfield.push({name: Terms.Shots.leg_glance, has_fielder: false})
      expect(field.has_fielder_in_slice(Terms.Shots.leg_glance)).toBeTruthy()

  describe "filter by position name", ->
    it "should find the position", ->
      set = field.filter_by_position_name(field.infield, Terms.Shots.cut)
      expect(set).toEqual([{name: Terms.Shots.cut, has_fielder: false}])
      set = field.filter_by_position_name(field.outfield, Terms.Shots.cut)
      expect(set).toEqual([{name: Terms.Shots.cut, has_fielder: false}])
