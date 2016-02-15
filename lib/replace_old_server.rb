require_relative 'cloudflare_item'

# Enumerates DNS records matching the name of an old server in all zones,
# and alters the DNS records to point to a new server.
class ReplaceOldServer
  def initialize(old_server, new_server)
    @old_server = old_server
    @new_server = new_server
  end

  def perform!
    matching_dns_records.each do |dns_record|
      dns_record_updater = CloudflareItem.new("/client/v4/zones/#{dns_record.zone_id}/dns_records/#{dns_record.id}")
      dns_record_updater.put! content: new_server, type: dns_record.type, name: dns_record.name
      puts "#{dns_record.name} now points to #{new_server}"
    end
  end

  private

  attr_reader :old_server
  attr_reader :new_server

  def matching_dns_records
    Enumerator.new do |yielder|
      zones = CloudflareItem.new('/client/v4/zones')
      zones.get_all_items.each do |zone|
        dns_records = CloudflareItem.new("/client/v4/zones/#{zone.id}/dns_records")
        dns_records.get_all_items(content: old_server).each do |dns_record|
          yielder << dns_record
        end
      end
    end
  end
end
