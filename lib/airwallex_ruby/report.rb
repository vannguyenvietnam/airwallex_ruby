module AirwallexRuby
  class Report < Base
    attr_accessor :data, :title, :params, :date_range, :next_page_token, :start_row, :total_row_count

    ENDPOINT = '/services/2/report'

    # Fetches a report using the API.
    #
    # @param [String] report_code the code of report. Details here https://developers.airwallex.com/v8976-Tools/reference/get-report-data
    # @param [Hash] options - report query parameters. Details here https://developers.airwallex.com/v8976-Tools/reference/query-parameters-1
    # @options [Integer] :accountId - Airwallex account ID assigned to the shopper.
    # @options [A|C] :accountUpdaterStatus - A (acknowledged) C (completed). By default, both A and C are returned.
    # @options [Success|Failure] :chargeStatus - By default, all charges are returned.
    # @options [String] :contracts - Number or a comma‑separated list of numbers. If not defined, data is returned for all contracts under the specified product. To use this, you must also include the products parameter
    # @options [String] :currency - Three‑letter currency code (uppercase).
    # @options [0|1] :excludeZero - 0 (default) - Do not exclude 1 - Exclude. Whether to exclude zero value orders.
    # @options [json|csv|html] :format - json (default). csv (not applicable to PayoutSummaryStatement). html (only applicable to PayoutSummaryStatement)
    # @options [String] :fraudDeclineReason - 3D Secure AVS/CVV Rules Custom Decline Threshold Custom Review Threshold Decline Fraud Rules Fraud Check Error Review Fraud Rules.
    # @options [String] :from_time - Allows you to to filter the report by the transaction time (in PST). Default values for from_time and to_time are 00:00:00 and 23:59:59, respectively.
    # @options [String] :to_time - Allows you to to filter the report by the transaction time (in PST). Default values for from_time and to_time are 00:00:00 and 23:59:59, respectively.
    # @options [String] :invoiceStatus - Approved Canceled Pending Refunded.
    # @options [String] :merchantBatchId - A merchant generated alphanumeric string.
    # @options [String] :merchantUpdaterId - A merchant generated alphanumeric string.
    # @options [Integer] :pageSize - Number of rows in the response page. If not specified, each page contains a maximum of 10,000 rows. Relevant only for the first page call.
    # @options [String] :paymentType - Screen the sales by the payment method: DeclinedTransactions report Apple Pay Credit Card; TransactionDetail report Alipay Apple Pay Balance Boleto Bancario Business Check Cashier Check cashU Credit Card Direct Debit Electronic Check GlobalCollect Cheque Google Pay Tokenized Card Local Bank Transfer Money Order None Offline Electronic Check Online banking PayPal PaySafeCard Personal Check Prepaid Purchase Order SEPA Direct Debit Skrill (Moneybookers) Ukash Wallie WebMoney Wire Transfer.
    # @options [String] :payoutCurrency - 3‑digit code of the currency of the bank account where you receive proceeds from the transaction.
    # @options [String] :payoutCycle - A Airwallex assigned value identifying the payout cycle.
    # @options [String] :payoutPlannedDate - The date a payment is expected to be initiated according to your payout schedule. If the Planned Date falls on a weekend or bank holiday, the payment is initiated on the next business day.
    # @options [String] :period - THIS_MONTH LAST_WEEK LAST_MONTH LAST_3_MONTHS LAST_6_MONTHS LAST_12_MONTHS CUSTOM — For a custom period, you must also include the from_date and to_date parameters (format is MM/DD/YYYY or YYYY‑MM‑DD) NEXT_MONTH — Only applicable to PayoutSummary.
    # @options [String] :processingStatus - Success Declined.
    # @options [String] :products - Number or a comma‑separated list of numbers. If not defined, data is returned for all products.
    # @options [String] :skuType - ONE_TIME RECURRING.
    # @options [String] :transactionType - SALE REFUND CHARGEBACK.
    # @options [String] :typeOfTransaction - Card Verification Failover Free Trial Payment Subscription Free Trial Subscription Recurring Charge Subscription Retry. If not defined, data is returned for all transaction types.
    # @options [String] :forvendorid - Vendor ID, a unique value assigned by Airwallex to each Marketplace vendor. Parameter is used to retrieve account balance and payout details for vendor.
    # @options [String] :vendor - Vendor ID, a unique value assigned by Airwallex to each Marketplace vendor.
    # @options [Active|Inactive] :vendorStatus - Vendor's account status. If not defined, data is returned for all statuses.
    # @return [AirwallexRuby::Report]
    def self.report report_code, options = {}
      request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
        uri.path = "#{ENDPOINT}/#{report_code}"
      end

      params_text = options.map { |k, v| "#{k}=#{ERB::Util.url_encode(v.to_s)}" }.join("\&")
      request_url.query = params_text
      response = get(request_url)
      response_body = JSON.parse(response.body)
      response_body[:next_page_token] = response.header['next-page-token']
      response_body[:start_row] = response.header['start-row']
      response_body[:total_row_count] = response.header['total-row-count']
      new(response_body)
    end

    # Fetches a report using the API.
    # Provides details about your current account balance (amount that has not been paid out yet), including payout currency(ies), gross and net amounts, and more.
    #
    # @param [Hash] options - report query parameters. Details here https://developers.airwallex.com/v8976-Tools/reference/query-parameters-1
    # @return [AirwallexRuby::Report]
    def self.account_balance_report options = {}
      report('AccountBalance', options)
    end
  end
end
