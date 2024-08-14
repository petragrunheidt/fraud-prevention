## Tasks

3.1 Understand the Industry

### 1

#### The main players in the acquirer market

- Merchant: a business or person that sells goods or services to customers. Merchants use payment processing systems to handle transactions and receive payments for their products or services.

- Acquirer: a business responsible for payment processment such as credit transactions. The acquirer provides the infrastructure and services necessary for merchants to accept payments and handles the transfering of monetary assets. For example, CloudWalk acts as an acquirer by facilitating payment processing for businesses, ensuring secure and efficient transactions.

- Sub-Acquirer: The sub-acquirer, also known as a payment facilitator or aggregator, operates under the acquirer's license to provide payment processing services to smaller merchants or businesses. They streamline the onboarding process and handle the integration with the acquirer. For example, a small online store might work with a sub-acquirer like a payment facilitator that partners with CloudWalk to manage their payment transactions.

- Payment Gateway: all of the technology that securely transmits transaction information between the merchant, the acquirer, and other financial entities. It encrypts payment data and ensures that it is sent securely for processing. For example, CloudWalk's payment gateway would handle the secure transfer of payment information from a merchant’s website to the acquirer for transaction approval.

- Issuer: the financial institution that provides banking accounts to consumers. It is responsible for managing the customer's account, authorizing transactions, and handling the billing and payments. When a customer makes a purchase, the issuer verifies that the cardholder has sufficient funds or credit, and then approves or declines the transaction.

#### The money and information flow

  When a customer requests a product from a merchant and provides payment information, the merchant doesn't store this data but forwards it to a payment gateway provided by the acquirer. The payment gateway applies a series of rules to determine whether the payment should be accepted or rejected. It also gathers valuable transaction information that the acquirer uses later. Once the payment is processed, the merchant is informed of the transaction's success or failure.

  At this point, the happy path of the transaction flow is complete. However, complications can still arise. A customer may cancel their purchase and request a refund, or they might report fraudulent activity. These scenarios introduce complexities that the acquirer's system must navigate effectively.

### 2

#### The difference between Adquirer, Sub-Acquirer and Payment Gateway

  For starters, the payment gateway is a lot different from the other two, because it concerns all of the technology behind the processing of payments. Payment gateways are usually data-intensive systems designed to handle the complex and secure transmission of payment information between the merchant, acquirer.

  Now, the difference between an Acquirer and a Sub-Acquirer can be harder to grasp, as they share many goals and responsibilities. Both are involved in enabling merchants to accept payments and managing the flow of funds from the customer’s account to the merchant’s account. However, the primary distinction lies in their level of interaction with the broader financial system and their scope of services.

  The Acquirer is the business that directly interfaces with the Issuer (the banking institution that provides payment cards to customers) and is responsible for facilitating the transfer of funds from the customer's bank to the merchant. The adquirers also must deal with processing chargeback requests, and may be accoutable to loss in cases of fraud.

  Sub-Acquirers, on the other hand, operate under the umbrella of the Acquirer and handle specific parts of the payment processing chain. While they don't have direct connections with Issuers, they act in managing the relationships with smaller merchants who might not meet the criteria to work directly with an Acquirer. Sub-Acquirers often specialize in particular markets or offer additional services such as fraud prevention, customer support, or custom payment solutions that cater to niche business needs.

  In essence, the Acquirer is the main entity responsible for processing payments and managing the risk associated with merchant accounts and the Sub-Acquirers work as intermediaries that bring specialized services to merchants, expanding the reach and capabilities of the Acquirer.

### 3

#### Chargebacks, Cancellations, and Their Connection to Fraud

  Chargebacks is the process in which a customer disputes a transaction, requesting the payment to be refund. Chargebacks can occur for many reasons, for example: when the customer does not recognize a payment in their bank account, or because the merchant failed to deliver the product. When this happens, money that was transfered from the customer to the merchant must be returned to the customer's account
  
  A Cancellation is similar but very different, because it is a request that happens before the transaction is fully completed. For example, if a consumer decides not to go through with a purchase, they might cancel the transaction, and the merchant would refund the amount before it is charged to the customer’s card.

  Chargebacks are usually a lot more related to frauds than Cancellations, because they are the means to address damage caused by an undetected fraud. This causes finantial loss for the Issuer and the Acdquirers, as they are directly responsible for implements Chargeback on systems and sometimes deal with part of the coast associated with frauds. Cancellations, on the other hand are more related to legitimate reasons for a transaction not to occur.

