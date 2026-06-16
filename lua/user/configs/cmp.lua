-- Returning a table here is recursively merged into the default cmp config
-- (see `modules.utils.load_plugin`). List fields like `sources` are appended,
-- so this just adds lazydev as an extra completion source.
return {
	sources = {
		{ name = "lazydev", group_index = 0 },
	},
}
