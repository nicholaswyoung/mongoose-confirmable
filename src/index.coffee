module.exports = (schema, options) ->
	uuid = require('node-uuid')
	
	schema.add
		active:
			type: Boolean
			default: false
		activated_at:
			type: Date
		activation_token:
			type: String
	
	schema.pre 'save', (next) ->
		@activation_token = uuid.v1() unless @activation_token
		next()
	
	schema.methods.activate = (callback) ->
		@active = true;
		@activated_at = new Date();
		@save(callback)