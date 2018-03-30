Geocoder.configure(
  lookup: :google,
  ip_lookup: :freegeoip,
  api_key: ENV['GOOGLE_MAPS_API_KEY'],
  timeout: 5,
  units: :km
)
