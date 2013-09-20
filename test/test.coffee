path 			 = require('path')
mongoose 	 = require('mongoose')
confirmable  = require path.join(__dirname, '../src/index')
expect 		 = require('chai').expect

# Setup Test Model
account = new mongoose.Schema()
account.plugin(confirmable)
mongoose.model('Account', account)
mongoose.connect('mongodb://localhost:27017/mongoose_confirmable')

Model = mongoose.model('Account')

describe 'Model', ->
	before (done) -> Model.remove(done)
	
	it 'should store active', ->
		expect(Model.schema).to.have.deep.property('paths.active')
	it 'should store activated_at', ->
		expect(Model.schema).to.have.deep.property('paths.activated_at')
	it 'should store activation_token', ->
		expect(Model.schema).to.have.deep.property('paths.activation_token')
		
	describe 'Defaults', ->
		before (done) ->
			@account = new Model()
			@account.save(done)
			
		it 'should default to inactive', ->
			expect(@account.active).to.equal(false)
		
		it 'should generate an activation_token', ->
			expect(@account.activation_token).to.not.equal(null)
			
		it 'should leave activated_at as undefined', ->
			expect(@account.activated_at).to.equal(undefined)
			
	describe 'Activation', ->
		before (done) ->
			@account = new Model()
			@account.save(done)
		
		it 'should allow activation', (done) ->
			@account.activate (err) =>
				expect(@account.active).to.equal(true)
				expect(@account.activated_at).to.not.equal(null)
				done(err)