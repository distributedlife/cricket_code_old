requirejs = require('../spec_helper').requirejs

sequence = null
Sequence = requirejs('lib/sequence')
describe "a sequence", ->
  beforeEach ->
    sequence = new Sequence()
    sequence.a = jasmine.createSpy('a').andReturn(true)
    sequence.b = jasmine.createSpy('b').andReturn(true)
    sequence.c = jasmine.createSpy('c').andReturn(true)
    sequence.d = jasmine.createSpy('d').andReturn(false)

  it 'starts at stage zero', ->
    expect(sequence.stage).toBe(0)

  it 'plays each stage', ->
    sequence.stages = [sequence.a, sequence.b, sequence.c]
    sequence.play()
    expect(sequence.a).toHaveBeenCalled()
    sequence.play()
    expect(sequence.b).toHaveBeenCalled()
    sequence.play()
    expect(sequence.c).toHaveBeenCalled()

  it 'wont exit a stage until complete', ->
    sequence.stages = [sequence.d, sequence.a]
    sequence.play()
    expect(sequence.d).toHaveBeenCalled()
    expect(sequence.a).not.toHaveBeenCalled()
    sequence.play()
    expect(sequence.d).toHaveBeenCalled()
    expect(sequence.a).not.toHaveBeenCalled()

  it 'is complete when all stages are complete', ->
    sequence.stages = [sequence.a, sequence.b, sequence.c]
    sequence.play()
    expect(sequence.is_complete()).toBeFalsy()
    sequence.play()
    expect(sequence.is_complete()).toBeFalsy()
    sequence.play()
    expect(sequence.is_complete()).toBeTruthy()
