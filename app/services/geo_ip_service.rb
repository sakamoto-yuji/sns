require 'maxminddb'

class GeoIpService
  def initialize(ip)
    db_path = Rails.root.join('lib', 'geoip', 'GeoLite2-City.mmdb')
    @reader = MaxMindDB.new(db_path)
    @ip = ip
  end

  def lookup
    result = @reader.lookup(@ip)
    return nil unless result.found?

    {
      country: result.country.name,
      region: result.subdivisions.most_specific.name,
      city: result.city.name
    }
  end
end

