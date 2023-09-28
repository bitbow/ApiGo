# ApiGo 1.0

By using ApiGo and following certain rules, it is possible to manipulate a database, the main objective of ApiGo is to avoid the constant definition of objects that attend to changes in the database.

## Dinamics endpoints

Apigo implement the following _endpoints_:

| Method | URL            				| Description                                                                   |
| ------ | ---------------------------- | ------------------------------------------------------------------------------|
| POST   | /login         				| Send user and password and response token.                                    |
| GET    | /apigo/dinamicresource   	| Returns all data collections.                                                 |
| GET    | /apigo/dinamicresource/:id   | Returns one item of collections.                                              |
| POST   | /apigo/dinamicresource     	| Creates a item using the information sent inside the `request body`.          |
| DELETE | /apigo/dinamicresource/:id 	| Removes the item with the specified `id`.                                 	|
| PUT    | /apigo/dinamicresource/:id 	| Updates the item with the specified `id` using data from the `request body`. 	|


bitbow
