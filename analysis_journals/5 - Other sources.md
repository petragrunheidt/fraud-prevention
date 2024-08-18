# Other sources

  The scope of this project is limited to the dataset of the csv file, but there are plenty of other data that can be absolutely significative in fraud analysis

## User history

  User history was something challenging to analyze in this dataset, since the data set is small and there are'nt that many repeating customers, but it is usually a full plate of elements that can be used to strongly predict if a transaction is fraudulent. Here are a few examples:

- Location data: If a user is performing a transaction from a new or unusual location, this can be a strong indicator of fraud. With cellphones and geolocation, it’s easier than ever to verify if a transaction is being made from an expected location.
- Purchase behaviour: In this dataset, we examined the transaction amount as a whole, but the same thing could have been done for each individual user. Also, if we could have data about the merchant the user usually goes for that could be another element to predict fraud
- Days of the week: For individual users, understanding their typical shopping patterns, such as which days of the week they usually make purchases, can be a strong indicator of whether a transaction is legitimate or not.
- User feedback: It does happen a good amount of times that legitimate transactions are flagged as fraudulent when a user does step out of their usual behaviour. In these cases, the user usually will contact their Issuer, and request that the transaction be approved. In this project, we are working with a binary result, approve or deny, but such data could be useful to build a third scenario that is, `review transaction`, or `pending approval`.

## Device history

  During the analysis I was surprised by the fact that transactions without a `device_id` don't have a higher rate of frauds, and that transactions are allowed to be made without data from the device, since all data comes from phones and it is relatively simple to enforce the collection of this data. This data could also be useful for predicting fraud:

- Away from home: We already talked about location in the context of unfamiliar locations. It is also a trend for Issuers to collect data about wether the user is home, or using a network flagged as safe or not. This could be another feature in the fraud score analysis

## Specific contingencies

  Now this one is a lot more specific. Certain events with a particular duration can predict higher rates of fraud. For instance, if a large event, such as a festival, occurs in the covered area and attracts millions of people, it's likely that device thefts will increase during this period. This would be an ideal time to heighten the severity of fraud score checks. It is also a good moment to collect data about which users are more likely to have their devices stolen.
