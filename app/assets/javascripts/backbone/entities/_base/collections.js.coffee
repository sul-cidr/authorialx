@AL.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

	class Entities.Collection extends Backbone.Collection
		# default properties of _all_ entities collections
		# myProp: 100
