# DOD Award Feed

An application to fetch Department of Defense contract data.

1. Install dependencies

```bash
> bundle install
```
for example, here is the source text for May 22, 2018: https://dod.defense.gov/News/Contracts/Contract-View/Article/1529001/
If you look in the database for rows with "award_date" of 2018-05-22, you will see only three rows
The script skipped all of the entries listed under the "Army" heading
checked it
The only entry under Army that it should be skipping is the one that starts with Griffon Aerospace - because one of the test rules is to skip entries where more than one company is mentioned
*text rules, I meant