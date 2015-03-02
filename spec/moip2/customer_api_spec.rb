describe Moip2::CustomerApi do

  let(:customer_api) { described_class.new(sandbox_client) }

  describe "#show" do

    let(:customer_external_id) { "CUS-B6LE6HLFFXKF" }

    let(:customer) do
      VCR.use_cassette("get_customer") do
        customer_api.show(customer_external_id)
      end
    end

    it "should recover customer information" do
      expect(customer.id).to eq customer_external_id
      expect(customer.own_id).to eq "your_customer_own_id"
      expect(customer.email).to eq "john.doe@mailinator.com"
      expect(customer.funding_instrument).to_not be_nil

      expect(customer.funding_instrument.credit_card.id).to eq "CRC-OQPJYLGZOY7P"
      expect(customer.funding_instrument.credit_card.brand).to eq "VISA"

      expect(customer.phone).to_not be_nil

      expect(customer.tax_document).to_not be_nil
      expect(customer.tax_document.type).to eq "CPF"

      expect(customer.shipping_address).to_not be_nil
      expect(customer.shipping_address.zip_code).to eq "01234000"

      expect(customer._links).to_not be_nil
      expect(customer._links.self.href).to eq "https://test.moip.com.br/v2/customers/CUS-B6LE6HLFFXKF"
    end

  end

  describe "#create" do

    let(:customer) do
      {
      ownId: "meu_id_sandbox_1231234",
      fullname: "Jose Silva",
      email: "jose_silva0@email.com",
      birthDate: "1988-12-30",
      taxDocument: {
        type: "CPF",
        number: "22222222222"
        },
      phone: {
        countryCode: "55",
        areaCode: "11",
        number: "66778899"
        },
      shippingAddress: {
        city: "Sao Paulo",
        complement: "8",
        district: "Itaim",
        street: "Avenida Faria Lima",
        streetNumber: "2927",
        zipCode: "01234000",
        state: "SP",
        country: "BRA"
        }
      }
    end

    let(:customer_with_funding_instrument) do
      {
      ownId: "meu_id_de_cliente",
      fullname: "Jose Silva",
      email: "josedasilva@email.com",
      phone: {
        areaCode: "11",
        number: "66778899"
        },
      birthDate: "1988-12-30",
      taxDocument: {
        type: "CPF",
        number: "22222222222"
        },
      shippingAddress: {
        street: "Avenida Faria Lima",
        streetNumber: "2927",
        complement: "8",
        district: "Itaim",
        city: "Sao Paulo",
        state: "SP",
        country: "BRA",
        zipCode: "01234000"
        },
      fundingInstrument: {
        method: "CREDIT_CARD",
        creditCard: {
          expirationMonth: 12,
          expirationYear: 15,
          number: "4073020000000002",
          holder: {
            fullname: "Jose Silva",
            birthdate: "1988-12-30",
            taxDocument: {
              type: "CPF",
              number: "22222222222"
              },
            phone: {
              areaCode: "11",
              number: "66778899"
              }
            }
          }
        }
      }
    end

    let(:created_customer) do
      VCR.use_cassette("create_customer") do
        customer_api.create customer
      end
    end

    let(:created_customer_with_funding_instrument) do
      VCR.use_cassette("create_customer_with_funding_instrument") do
        customer_api.create customer_with_funding_instrument
      end
    end

    it "should create a customer without funding instrument" do
      expect(created_customer.id).to eq "CUS-4GESZSOAH7HX"
      expect(created_customer.own_id).to eq "meu_id_sandbox_1231234"
      expect(created_customer.email).to eq "jose_silva0@email.com"

      expect(created_customer.phone).to_not be_nil

      expect(created_customer.tax_document).to_not be_nil
      expect(created_customer.tax_document.type).to eq "CPF"

      expect(created_customer.shipping_address).to_not be_nil
      expect(created_customer.shipping_address.zip_code).to eq "01234000"

      expect(created_customer._links).to_not be_nil
      expect(created_customer._links.self.href).to eq "https://test.moip.com.br/v2/customers/CUS-4GESZSOAH7HX"
    end

    it "should create a customer with funding instrument" do
      expect(created_customer_with_funding_instrument.id).to eq "CUS-E5CO735TBXTI"
      expect(created_customer_with_funding_instrument.own_id).to eq "meu_id_de_cliente"
      expect(created_customer_with_funding_instrument.email).to eq "josedasilva@email.com"
      expect(created_customer_with_funding_instrument.funding_instrument).to_not be_nil

      expect(created_customer_with_funding_instrument.funding_instrument.credit_card.id).to eq "CRC-F5DR8SVINCUI"
      expect(created_customer_with_funding_instrument.funding_instrument.credit_card.brand).to eq "VISA"

      expect(created_customer_with_funding_instrument.phone).to_not be_nil

      expect(created_customer_with_funding_instrument.tax_document).to_not be_nil
      expect(created_customer_with_funding_instrument.tax_document.type).to eq "CPF"

      expect(created_customer_with_funding_instrument.shipping_address).to_not be_nil
      expect(created_customer_with_funding_instrument.shipping_address.zip_code).to eq "01234000"

      expect(created_customer_with_funding_instrument._links).to_not be_nil
      expect(created_customer_with_funding_instrument._links.self.href).to eq "https://test.moip.com.br/v2/customers/CUS-E5CO735TBXTI"
    end

  end

end
