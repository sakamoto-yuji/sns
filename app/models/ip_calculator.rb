# app/models/ip_calculator.rb
require 'ipaddr'

class IpCalculator
  attr_reader :ip_obj
  attr_reader :errors

  def initialize(ip_input, subnet_or_cidr)
    @ip_input = ip_input.strip
    @subnet_or_cidr = subnet_or_cidr.strip
    @errors = []
    validate_ip!
    validate_subnet_or_cidr!
    raise ArgumentError, @errors.join(', ') unless @errors.empty?
    @ip_obj = build_ipaddr
  end

  def build_ipaddr
    if @subnet_or_cidr.start_with?('/')
      IPAddr.new(@ip_input + @subnet_or_cidr)
    else
      mask_bits = IPAddr.new(@subnet_or_cidr).to_i.to_s(2).count("1")
      IPAddr.new(@ip_input + '/' + mask_bits.to_s)
    end
  end

  def cidr
    '/' + ip_obj.prefix.to_s
  end

  def subnet_mask
    IPAddr.new('255.255.255.255').mask(ip_obj.prefix).to_s
  end

  def network_address
    ip_obj.to_range.first.to_s
  end

  def broadcast_address
    ip_obj.to_range.last.to_s
  end

  def first_host
    return nil if total_hosts <= 2
    (IPAddr.new(network_address).to_i + 1).to_ip
  end

  def last_host
    return nil if total_hosts <= 2
    (IPAddr.new(broadcast_address).to_i - 1).to_ip
  end

  def total_hosts
    return 0 unless ip_obj.ipv4?

    prefix = ip_obj.prefix.to_i
    return 0 if prefix >= 31  # /31や/32はホストなし（特殊用途）

    2 ** (32 - prefix) - 2
  end
 
  
  def validate_ip!
    IPAddr.new(@ip_input)
  rescue IPAddr::InvalidAddressError
    @errors << "無効なIPアドレスです: #{@ip_input}"
  end

  def validate_subnet_or_cidr!
    if @subnet_or_cidr.start_with?('/')
      if @subnet_or_cidr.length == 1
        @errors << "CIDR表記が不完全です: #{@subnet_or_cidr}"
        return
      end

      prefix_str = @subnet_or_cidr[1..]
      unless prefix_str.match?(/\A\d+\z/)
        @errors << "CIDRのプレフィックスが数字ではありません: #{@subnet_or_cidr}"
        return
      end

      prefix = prefix_str.to_i
      unless (0..32).include?(prefix)
        @errors << "無効なCIDR表記です: #{@subnet_or_cidr}"
      end
    else
      begin
        IPAddr.new(@subnet_or_cidr)
      rescue IPAddr::InvalidAddressError
        @errors << "無効なサブネットマスクです: #{@subnet_or_cidr}"
      end
    end
  end

    
end #ip-calculatorのend

class Integer
  def to_ip
    [24, 16, 8, 0].map { |b| (self >> b) & 255 }.join('.')
  end
end

