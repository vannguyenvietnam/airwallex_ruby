module BluesnapRuby
  class Vendor < Base
    attr_accessor :vendorId, :email, :name, :ipnUrl, :firstName, :lastName, :address, :city,
                  :zip, :country, :phone, :state, :defaultPayoutCurrency, :frequency, :delay,
                  :vendorPrincipal, :payoutInfo, :vendorAgreement, :verification

    ENDPOINT = '/1/recipients'

    # Uses the API to create a vendor.
    #
    # @param [Hash] vendor_data
    # @option vendor_data [String] :email *required*
    # @option vendor_data [String] :country *required*
    # @option vendor_data [Hash] :payoutInfo 
    # @return [BluesnapRuby::Vendor]
    def self.create vendor_data
      attributes = self.attributes - [:vendorId] # fix attributes allowed by POST API
      options    = parse_options_for_request(attributes, vendor_data)
      response   = post(URI.parse(BluesnapRuby.api_url).tap{|uri| uri.path = Vendor::ENDPOINT }, options)
      new(response.delete('token'), response)
    end

    # Update a recipient using the pin API.
    #
    # @param [String] token *required*
    # @param [String] email *required*
    # @param [String,PinPayment::BankAccount,Hash] bank_account can be a token, hash or bank account object *required*
    # @return [PinPayment::Recipient]
    def self.update token, email, card_or_token = nil
      new(token).tap{|c| c.update(email, card_or_token) }
    end

    # Fetches all of your recipients using the pin API.
    #
    # @return [Array<PinPayment::Recipient>]
    # TODO: pagination
    def self.all
      response = get(URI.parse(PinPayment.api_url).tap{|uri| uri.path = Vendor::ENDPOINT })
      response.map{|x| new(x.delete('token'), x) }
    end

    # Fetches a customer using the pin API.
    #
    # @param [String] token the recipient token
    # @return [PinPayment::Recipient]
    def self.find token
      response = get(URI.parse(PinPayment.api_url).tap{|uri| uri.path = "#{Vendor::ENDPOINT}/#{token}" })
      new(response.delete('token'), response)
    end

    # Update a recipient using the pin API.
    #
    # @param [String] email the recipients's new email address
    # @param [String, PinPayment::BankAccount, Hash] account_or_token the recipient's new bank account details
    # @return [PinPayment::Customer]
    def update email, account_or_token = nil
      attributes = self.class.attributes - [:token, :created_at]
      options    = self.class.parse_options_for_request(attributes, email: email, bank_account: account_or_token)
      response   = self.class.put(URI.parse(PinPayment.api_url).tap{|uri| uri.path = "#{Vendor::ENDPOINT}/#{token}" }, options)
      self.email = response['email']
      self.bank_account  = response['bank_account']
      self
    end


    private
  end
end
