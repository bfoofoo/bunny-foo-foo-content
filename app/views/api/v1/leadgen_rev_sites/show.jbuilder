json.(@leadgen_rev_site, *@leadgen_rev_site.attributes.keys)
json.ads do
  json.(@leadgen_rev_site.ads, *Ad.column_names)
end
