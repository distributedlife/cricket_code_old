requirejs = require('../spec_helper').requirejs
io = require('../stubs/socket.io').io

module_mock = require('../stubs/module_mock')
module_mock.reset(requirejs)
module_mock.stub(requirejs, 'socket.io', io)

field = null
field_validator = null

array_of = (count) ->
  to_return = ({} for num in [count..1])

FieldValidator = requirejs('cricket/field_validator')
ServerField = requirejs('cricket/server_field')
Terms = requirejs('cricket/terms')
describe "a field", ->
  beforeEach ->
    field = new ServerField()
    field_validator = new FieldValidator()

  describe "validating a fielding configuration", ->
    it "must have 9 fielders including slips", ->
      field_validator.has_no_more_than_3_slips = -> return true
      field_validator.has_no_more_than_2_backward_of_square = -> return true
      field_validator.does_not_violate_fielding_restrictions = -> return true

      field.infielders = -> array_of(1)
      field.slips = 3
      field.outfielders = -> array_of(5)
      expect(field_validator.validate_field(field)).toBeTruthy()

      field.infielders = -> array_of(2)
      field.slips = 3
      field.outfielders = -> array_of(5)
      expect(field_validator.validate_field(field)).toBeFalsy()

      field.infielders = -> array_of(1)
      field.slips = 2
      field.outfielders = -> array_of(6)
      expect(field_validator.validate_field(field)).toBeTruthy()

      field.infielders = -> array_of(1)
      field.slips = 3
      field.outfielders = -> array_of(6)
      expect(field_validator.validate_field(field)).toBeFalsy()

    it "must have only 2 fielders in the region backward of square", ->
      field.reset()
      field_validator.has_correct_number_of_fielders = -> return true
      field_validator.has_no_more_than_3_slips = -> return true
      field_validator.does_not_violate_fielding_restrictions = -> return true

      field.set_infielder(Terms.Shots.leg_glance)
      field.set_infielder(Terms.Shots.hook)
      expect(field_validator.validate_field(field)).toBeTruthy()

      field.set_outfielder(Terms.Shots.leg_glance)
      expect(field_validator.validate_field(field)).toBeFalsy()

      field.reset()
      field.set_infielder(Terms.Shots.leg_glance)
      field.set_infielder(Terms.Shots.hook)
      field.set_outfielder(Terms.Shots.hook)
      expect(field_validator.validate_field(field)).toBeFalsy()

    it "must not have more than 3 slips", ->
      field_validator.has_no_more_than_2_backward_of_square = -> return true
      field_validator.has_correct_number_of_fielders = -> return true
      field_validator.does_not_violate_fielding_restrictions = -> return true
      field.slips = 3
      expect(field_validator.validate_field(field)).toBeTruthy()
      field.slips = 4
      expect(field_validator.validate_field(field)).toBeFalsy()


  describe "fielding restrictions", ->
    describe "in place", ->
      beforeEach ->
        field.restrictions_in_place = true

      it "must have no more than 2 fielders in the outfield", ->
        field.outfielders = -> array_of(3)
        expect(field_validator.does_not_violate_fielding_restrictions(field)).toBeFalsy()
        field.outfielders = -> array_of(2)
        expect(field_validator.does_not_violate_fielding_restrictions(field)).toBeTruthy()

    describe "not in place", ->
      beforeEach ->
        field.restrictions_in_place = false

      it "must have no more than 5 fielders in the outfield", ->
        field.outfielders = -> array_of(6)
        expect(field_validator.does_not_violate_fielding_restrictions(field)).toBeFalsy()
        field.outfielders = -> array_of(5)
        expect(field_validator.does_not_violate_fielding_restrictions(field)).toBeTruthy()


  describe "is backward of square", ->
    it "should be true if position is leg glance", ->
      position = {name: Terms.Shots.leg_glance, has_fielder: true}
      expect(field_validator.is_backward_of_square(position)).toBeTruthy()

    it "should be true if position is hook", ->
      position = {name: Terms.Shots.hook, has_fielder: true}
      expect(field_validator.is_backward_of_square(position)).toBeTruthy()

    it "should return false otherwise", ->
      for own shot of Terms.Shots
        if (shot == Terms.Shots.leg_glance || shot == Terms.Shots.hook)
          continue
        position = {name: shot}
        expect(field_validator.is_backward_of_square(position)).toBeFalsy()
