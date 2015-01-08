requirejs = require('../spec_helper').requirejs

module_mock = require('../stubs/module_mock')
module_mock.reset(requirejs)

ball = module_mock.spy_on(requirejs, 'cricket/server_ball')

BallFactory = requirejs('cricket/ball_factory')

describe "the ball factory", ->
	factory = null;

	beforeEach ->
		factory = new BallFactory();

	it "should create a ball", ->
		b = factory.create_ball()
		expect(ball).toHaveBeenCalled();