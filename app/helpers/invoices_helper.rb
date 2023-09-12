module InvoicesHelper

    def currency_code_to_symbol(currency_code)
        case currency_code
        when "USD"
            return "$"
        when "GBP"
            return "£"
        when "EUR"
            return "€"
        else
            return currency_code
        end
    end

    def xero_invoices_to_db(xero_invoices)
        invoices = []
        xero_invoices.each do |xero_invoice|

            invoice_to_store = {
                client: xero_invoice.contact.name,
                xero_invoice_number: xero_invoice.invoice_number,
                xero_invoice_id: xero_invoice.invoice_id,
                outstanding_amount: xero_invoice.amount_due,
                total_amount: xero_invoice.total,
                status: xero_invoice.status,
                currency_code: xero_invoice.currency_code,
                currency_symbol: currency_code_to_symbol(xero_invoice.currency_code),
                due_date: xero_invoice.due_date,
                updated_at: xero_invoice.updated_date_utc,
                created_at: xero_invoice.date,
                user_id: current_user.id
            }

            # puts "invoice_to_store #{invoice_to_store.user_id}"

            invoices << invoice_to_store


            # invoice {
            #     :Type=>"ACCREC", 
            #     :Contact=>{
            #         :ContactID=>"3cbd5263-0965-4c4e-932c-bf50e3297610", 
            #         :Name=>"Rex Media Group", 
            #         :ContactPersons=>[], 
            #         :Addresses=>[], 
            #         :Phones=>[], 
            #         :ContactGroups=>[], 
            #         :HasAttachments=>false, 
            #         :HasValidationErrors=>false
            #     }, 
            #     :LineItems=>[], 
            #     :Date=>Sat, 09 Sep 2023, 
            #     :DueDate=>Sun, 24 Sep 2023, 
            #     :LineAmountTypes=>"Inclusive", 
            #     :InvoiceNumber=>"INV-0030", 
            #     :Reference=>"Monthly support", 
            #     :BrandingThemeID=>"d613f7f9-8fcb-477f-97f0-31eb85b7e5cf", 
            #     :CurrencyCode=>"USD", 
            #     :CurrencyRate=>0.1e1, 
            #     :Status=>"DRAFT", 
            #     :SubTotal=>0.50808e3, 
            #     :TotalTax=>0.4192e2, 
            #     :Total=>0.55e3, 
            #     :InvoiceID=>"1bba28a1-2807-4d2e-86a0-c418a91ac12f", 
            #     :HasAttachments=>false, 
            #     :IsDiscounted=>false, 
            #     :Payments=>[], 
            #     :Prepayments=>[], 
            #     :Overpayments=>[], 
            #     :AmountDue=>0.55e3, 
            #     :AmountPaid=>0.0, 
            #     :AmountCredited=>0.0, 
            #     :UpdatedDateUTC=>Fri, 24 Jun 2016 17:23:41 +0000, 
            #     :CreditNotes=>[], 
            #     :HasErrors=>false
            # }

        end
        return invoices
    end

end
