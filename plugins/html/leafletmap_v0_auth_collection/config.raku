%(
	:auth<collection>,
	:authors(
		"finanalyst",
	),
	:css-link( q:to/DATA/ ),
		href="https://unpkg.com/leaflet@1.8.0/dist/leaflet.css"
		integrity="sha512-hoalWLoI8r4UszCkZ5kL8vayOGVae1oxXe/2A4AO6J9+580uKHDO3JdHb7NzwwzK5xr/Fs0W40kiNHxM9vyTtQ=="
		crossorigin=""
		DATA
	:custom-raku<leaflet-blocks.raku>,
	:id<collection-map-id>,
	:information(
		"css-link",
		"js-link",
		"js-script",
		"id",
		"lat",
		"long",
		"zoom",
		"provider",
	),
	:js-link( q:to/DATA/ ),
		src="https://unpkg.com/leaflet@1.8.0/dist/leaflet.js"
		integrity="sha512-BB3hKbKWOc9Ez/TAwyWxNXeoV9c1v6FIeYiBieIWkpLjauysF18NzgR1MBNBXf8/KABdlkX68nAhlwcDFLGPCQ=="
		crossorigin=""
		DATA
	:js-script( [ "leaflet-providers.js", 1 ] ),
	:lat(51.4816),
	:license<Artistic-2.0>,
	:long(-3.1807),
	:name<leafletmap>,
	:provider<OpenStreetMap>,
	:render,
	:template-raku<leaflet-templates.raku>,
	:version<0.3.7>,
	:zoom(16),
)
