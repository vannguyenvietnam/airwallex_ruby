module BluesnapRuby
  class Report < Base
    attr_accessor :data, :title, :params, :date_range

    ENDPOINT = '/services/2/report'

    # Fetches a report using the API.
    #
    # @param [String] report_code the code of report. Details here https://developers.bluesnap.com/v8976-Tools/reference/get-report-data
    # @param [Hash] options - report query parameters. Details here https://developers.bluesnap.com/v8976-Tools/reference/query-parameters-1
    # @options [Integer] :accountId - BlueSnap account ID assigned to the shopper.
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
    # @options [String] :payoutCycle - A BlueSnap assigned value identifying the payout cycle.
    # @options [String] :payoutPlannedDate - The date a payment is expected to be initiated according to your payout schedule. If the Planned Date falls on a weekend or bank holiday, the payment is initiated on the next business day.
    # @options [String] :period - THIS_MONTH LAST_WEEK LAST_MONTH LAST_3_MONTHS LAST_6_MONTHS LAST_12_MONTHS CUSTOM — For a custom period, you must also include the from_date and to_date parameters (format is MM/DD/YYYY or YYYY‑MM‑DD) NEXT_MONTH — Only applicable to PayoutSummary.
    # @options [String] :processingStatus - Success Declined.
    # @options [String] :products - Number or a comma‑separated list of numbers. If not defined, data is returned for all products.
    # @options [String] :skuType - ONE_TIME RECURRING.
    # @options [String] :transactionType - SALE REFUND CHARGEBACK.
    # @options [String] :typeOfTransaction - Card Verification Failover Free Trial Payment Subscription Free Trial Subscription Recurring Charge Subscription Retry. If not defined, data is returned for all transaction types.
    # @options [String] :forvendorid - Vendor ID, a unique value assigned by BlueSnap to each Marketplace vendor. Parameter is used to retrieve account balance and payout details for vendor.
    # @options [String] :vendor - Vendor ID, a unique value assigned by BlueSnap to each Marketplace vendor.
    # @options [Active|Inactive] :vendorStatus - Vendor's account status. If not defined, data is returned for all statuses.
    # @return [BluesnapRuby::Report]
    def self.report report_code, options = {}
      request_url = URI.parse(BluesnapRuby.api_url).tap do |uri| 
        uri.path = "#{ENDPOINT}/#{report_code}"
      end

      params_text = options.map { |k, v| "#{k}=#{ERB::Util.url_encode(v.to_s)}" }.join("\&")
      request_url.query = params_text
      response = get(request_url)
      response_body = JSON.parse(response.body)
      new(response_body)
    end

    # Fetches a report using the API.
    # Provides details about your current account balance (amount that has not been paid out yet), including payout currency(ies), gross and net amounts, and more.
    #
    # @param [Hash] options - report query parameters. Details here https://developers.bluesnap.com/v8976-Tools/reference/query-parameters-1
    # @return [BluesnapRuby::Report]
    def self.account_balance_report options = {}
      report('AccountBalance', options)
    end

    # Fetches a report using the API.
    # Provides details about active subscriptions, such as the next charge date, Subscription ID, and shopper info.
    #
    # @param [Hash] options - report query parameters. Details here https://developers.bluesnap.com/v8976-Tools/reference/query-parameters-1
    # @return [BluesnapRuby::Report]
    def self.active_subscriptions_report options = {}
      report('ActiveSubscriptions', options)
    end

    # Fetches a report using the API.
    # Provides the results of all card addition and update attempts.
    #
    # @param [Hash] options - report query parameters. Details here https://developers.bluesnap.com/v8976-Tools/reference/query-parameters-1
    # @return [BluesnapRuby::Report]
    def self.add_card_attempts_report options = {}
      report('AddCardAttempts', options)
    end

    # Fetches a report using the API.
    # Provides the results of your Account Updater requests. This report is designed for merchants who use BlueSnap's card vault to store credit card numbers.
    #
    # @param [Hash] options - report query parameters. Details here https://developers.bluesnap.com/v8976-Tools/reference/query-parameters-1
    # @return [BluesnapRuby::Report]
    def self.au_bluesnap_vault_cards_report options = {}
      report('AU_BluesnapVaultCards', options)
    end

    # Fetches a report using the API.
    # Provides the results of your Account Updater requests. This report is designed for merchants who vault credit card numbers on their own servers.
    #
    # @param [Hash] options - report query parameters. Details here https://developers.bluesnap.com/v8976-Tools/reference/query-parameters-1
    # @return [BluesnapRuby::Report]
    def self.au_merchant_vault_cards_report options = {}
      report('AU_MerchantVaultCards', options)
    end

    # Fetches a report using the API.
    # Provides transaction-level detail for all the transactions included in your account balance.
    #
    # @param [Hash] options - report query parameters. Details here https://developers.bluesnap.com/v8976-Tools/reference/query-parameters-1
    # @return [BluesnapRuby::Report]
    def self.balance_detail_report options = {}
      report('BalanceDetail', options)
    end

    # Fetches a report using the API.
    # Provides a list of canceled subscriptions that include the plan, shopper, and cancellation details.
    #
    # @param [Hash] options - report query parameters. Details here https://developers.bluesnap.com/v8976-Tools/reference/query-parameters-1
    # @return [BluesnapRuby::Report]
    def self.canceled_subscriptions_report options = {}
      report('CanceledSubscriptions', options)
    end

    # Fetches a report using the API.
    # Displays all chargebacks and chargeback related data.
    #
    # @param [Hash] options - report query parameters. Details here https://developers.bluesnap.com/v8976-Tools/reference/query-parameters-1
    # @return [BluesnapRuby::Report]
    def self.charge_backs_report options = {}
      report('ChargeBacks', options)
    end

    # Fetches a report using the API.
    # Provides a list of all declined authorizations and the fees for those that have been charged.
    #
    # @param [Hash] options - report query parameters. Details here https://developers.bluesnap.com/v8976-Tools/reference/query-parameters-1
    # @return [BluesnapRuby::Report]
    def self.declined_auth_fees_report options = {}
      report('DeclinedAuthFees', options)
    end

    # Fetches a report using the API.
    # Provides a list of declined credit and debit card transactions with decline reason, payment details, and shopper information.
    #
    # @param [Hash] options - report query parameters. Details here https://developers.bluesnap.com/v8976-Tools/reference/query-parameters-1
    # @return [BluesnapRuby::Report]
    def self.declined_transactions_report options = {}
      report('DeclinedTransactions', options)
    end

    # Fetches a report using the API.
    # Provides a list of all ACH / Electronic Check and SEPA Direct Debit transactions. Use this report to track the invoice status from Pending to Approved or Canceled.
    #
    # @param [Hash] options - report query parameters. Details here https://developers.bluesnap.com/v8976-Tools/reference/query-parameters-1
    # @return [BluesnapRuby::Report]
    def self.direct_debit_report options = {}
      report('DirectDebit', options)
    end

    # Fetches a report using the API.
    # Provides details about the transactions included in BlueSnap deposits to your account.
    #
    # @param [Hash] options - report query parameters. Details here https://developers.bluesnap.com/v8976-Tools/reference/query-parameters-1
    # @return [BluesnapRuby::Report]
    def self.payout_detail_report options = {}
      report('PayoutDetail', options)
    end

    # Fetches a report using the API.
    # Helps you reconcile your gross sales to the amount deposited into your bank account for each payout currency. It also itemizes all processing fees, non-processing fees, and other adjustments to your account.
    #
    # @param [Hash] options - report query parameters. Details here https://developers.bluesnap.com/v8976-Tools/reference/query-parameters-1
    # @return [BluesnapRuby::Report]
    def self.payout_summary_report options = {}
      report('PayoutSummary', options)
    end

    # Fetches a report using the API.
    # Access summary reports from past payout cycles to view details such as sales, refunds, fees, and more.
    #
    # @param [Hash] options - report query parameters. Details here https://developers.bluesnap.com/v8976-Tools/reference/query-parameters-1
    # @return [BluesnapRuby::Report]
    def self.payout_summary_statement_report options = {}
      report('PayoutSummaryStatement', options)
    end

    # Fetches a report using the API.
    # Provides details about all the recurring charges that were attempted.
    #
    # @param [Hash] options - report query parameters. Details here https://developers.bluesnap.com/v8976-Tools/reference/query-parameters-1
    # @return [BluesnapRuby::Report]
    def self.recurring_charges_report options = {}
      report('RecurringCharges', options)
    end

    # Fetches a report using the API.
    # Provides a detailed list of all events and how they affect your balance. Allows you to see a snapshot of your balance in real time, at any chosen point in time, or within a chosen date range.
    #
    # @param [Hash] options - report query parameters. Details here https://developers.bluesnap.com/v8976-Tools/reference/query-parameters-1
    # @return [BluesnapRuby::Report]
    def self.running_balance_report options = {}
      report('RunningBalance', options)
    end

    # Fetches a report using the API.
    # Provides details about transactions that were declined because of your fraud rules or BlueSnap's fraud detection logic.
    #
    # @param [Hash] options - report query parameters. Details here https://developers.bluesnap.com/v8976-Tools/reference/query-parameters-1
    # @return [BluesnapRuby::Report]
    def self.stopped_fraud_report options = {}
      report('StoppedFraud', options)
    end

    # Fetches a report using the API.
    # Provides details about each transaction, including shopper info, payment details, subscription info and more.
    #
    # @param [Hash] options - report query parameters. Details here https://developers.bluesnap.com/v8976-Tools/reference/query-parameters-1
    # @return [BluesnapRuby::Report]
    def self.transaction_detail_report options = {}
      report('TransactionDetail', options)
    end

    # Fetches a report using the API.
    # Provides account details for each of the vendors in your marketplace.
    #
    # @param [Hash] options - report query parameters. Details here https://developers.bluesnap.com/v8976-Tools/reference/query-parameters-1
    # @return [BluesnapRuby::Report]
    def self.vendor_details_report options = {}
      report('VendorDetails', options)
    end
  end
end
