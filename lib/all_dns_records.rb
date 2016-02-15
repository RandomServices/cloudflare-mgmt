require_relative 'cloudflare_item'

# Enumerates DNS records in all zones, optionally matching certain fields.
# The list of matching fields: https://api.cloudflare.com/#dns-records-for-a-zone-list-dns-records
class AllDnsRecords
  def initialize(match_fields = {})
    @match_fields = match_fields
  end

  attr_reader :match_fields

  def matching_dns_records
    Enumerator.new do |yielder|
      zones = CloudflareItem.new('/client/v4/zones')
      zones.get_all_items.each do |zone|
        dns_records = CloudflareItem.new("/client/v4/zones/#{zone.id}/dns_records")
        dns_records.get_all_items(match_fields).each do |dns_record|
          yielder << dns_record
        end
      end
    end
  end
end
